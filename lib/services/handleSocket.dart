/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:io'; //only for non-web apps!!!
import 'dart:async';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'simulateDevices.dart';
import '../shared/globals.dart' as deviceCreationConfig;


class DataHand extends ChangeNotifier {
  late Socket socket;
  var stream;
  NetworkList _networkList = NetworkList();
  DeviceSimulator deviceSimulator = DeviceSimulator();
  bool connected = false;

  List<dynamic> xmlDebugResponseList = []; // used for debugging log
  int maxResponseListSize = 50; // determines the max number of displayed responses in debugging log

  Map<String,List<XmlDocument>> xmlResponseMap = new Map<String,List<XmlDocument>>();

  bool testing = false;

  // optional parameter to avoid the socket connection with the backend for testing
  DataHand([bool? testing]) {
    if(testing == null){
      handleSocket();
    }
  }

  void setNetworkList(NetworkList networkList) {
    _networkList = networkList;
  }

  NetworkList getNetworkList() {
    return _networkList;
  }

  void handleSocket() async {
    logger.d("ConnectSocket");
    try {
      socket = await Socket.connect("localhost", 24271,);
      logger.d("connected!");
      stream = socket.listen(
              (data) => dataHandler(data),
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false
      );
      connected = true;
    }
    on Exception catch(_) {
      print("ERROR");
      await Future.delayed(Duration(seconds: 1));
      handleSocket();
    }

    //commenting out this part of code resolves the starting issue when double clicking the application - seems not to be needed
    //stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  Future<void> dataHandler(data) async {
    logger.d("[dataHandler] - Got Data!");
    String? xmlRawData = new String.fromCharCodes(data).trim();
    await parseXML(xmlRawData);
    notifyListeners();
  }

  void errorHandler(error, StackTrace trace) {
    logger.e(error);//FlutterError.dumpErrorToConsole(error);
    connected = false;
    stream.cancel();
    notifyListeners();
    handleSocket();
  }

  void doneHandler() {
    logger.w("Server left");
    connected = false;
    //socket.destroy();
    stream.cancel();
    notifyListeners();
    handleSocket();
  }


  Future<void> parseXML(String? rawData) async {
    logger.d("parsing XML ...");

    if (rawData == null || rawData == "") {
      logger.w('XML empty');
      return;
    }

    var xmlDataList = []; //List for all xmlDocuments if dataHandler passes more than one xml
    String? xmlDataNext = rawData;

    while (xmlDataNext != null) {
      var xmlLength = int.parse(xmlDataNext.substring(7, 15), radix: 16); // cut the head in front of recieved xml
      //logger.i("XmlLength: " + xmlLength.toString());
      var xmlSingleDoc = xmlDataNext.substring(rawData.indexOf('<?'), xmlLength + 13); //why 13? I dont know yet -_(o.O)_- //TODO
      xmlDataList.add(xmlSingleDoc);

      try {
        xmlDataNext = xmlDataNext.substring(xmlLength + 15);
      } catch (error) {
        xmlDataNext = null;
      }
    }

    XmlDocument document;
    for (var xmlDoc in xmlDataList) {
      document = XmlDocument.parse(xmlDoc);

      if (document.findAllElements('MessageType').first.innerText == "NetworkUpdate") {

        _networkList.clearNetworkList();
        logger.d('DeviceList found ->');
        //logger.v(document);
        logger.v("new Devicelist");
        var localDeviceList = document.findAllElements('LocalDeviceList').first.findElements('item'); //TODO: TEST call for every

        int listCounter = 0;
        for (var dev in localDeviceList) {
          Device device = Device.fromXML(dev, true);
          //logger.i(device.toRealString());
          _networkList.addDevice(device, listCounter);
          if (testing) {
            _networkList.addDevice(device, listCounter+1);
            _networkList.addDevice(device, listCounter+2);
            _networkList.addDevice(device, listCounter+3);
          }


          for (var remoteDev in device.remoteDevices) {
            //logger.i(remoteDev.toRealString());
            _networkList.addDevice(remoteDev, listCounter);
            if (testing) {
              _networkList.addDevice(remoteDev, listCounter+1);
              _networkList.addDevice(remoteDev, listCounter+1);
              _networkList.addDevice(remoteDev, listCounter+1);
              _networkList.addDevice(remoteDev, listCounter+2);
              _networkList.addDevice(remoteDev, listCounter+2);
              _networkList.addDevice(remoteDev, listCounter+3);
            }
          }
          listCounter++;
        }

        if (deviceCreationConfig.simulatedDevices) {
          for (var i=0; i<deviceCreationConfig.nDevices; i++) {
            _networkList.addDevice(deviceSimulator.createDevice(i+1), listCounter);
          }
        }

      } else if (document.findAllElements('MessageType').first.innerText == "Config") {
        parseConfig(document);
        logger.d('Config found ->');
        logger.v(document);
      } else if (document.findAllElements('MessageType').first.innerText == "FirmwareUpdateIndication") {

        if(!xmlResponseMap.containsKey("FirmwareUpdateIndication")) {
          xmlResponseMap["FirmwareUpdateIndication"] = [];
        }
        xmlResponseMap["FirmwareUpdateIndication"]!.add(document);

        parseFWUpdateIndication(document);

        if (xmlDebugResponseList.length >= maxResponseListSize){
          xmlDebugResponseList.removeLast();
          xmlDebugResponseList.removeLast();
        }
        xmlDebugResponseList.insert(0, document);
        xmlDebugResponseList.insert(0, DateTime.now());

        logger.d('FirmwareUpdateIndication found ->');
        logger.v(document);

      } else if (document.findAllElements('MessageType').first.innerText == "FirmwareUpdateStatus") {

        if(!xmlResponseMap.containsKey("FirmwareUpdateStatus")) {
          xmlResponseMap["FirmwareUpdateStatus"] = [];
        }
        xmlResponseMap["FirmwareUpdateStatus"]!.add(document);

        parseFWUpdateStatus(document);

        if (xmlDebugResponseList.length >= maxResponseListSize){
          xmlDebugResponseList.removeLast();
          xmlDebugResponseList.removeLast();
        }
        xmlDebugResponseList.insert(0, document);
        xmlDebugResponseList.insert(0, DateTime.now());


        logger.d('UpdateStatus found ->');
        logger.v(document);
      }

      else if (document.findAllElements('MessageType').first.innerText == "UpdateIndication") {

        if(!xmlResponseMap.containsKey("UpdateIndication")) {
          xmlResponseMap["UpdateIndication"] = [];
        }
        xmlResponseMap["UpdateIndication"]!.add(document);

        //possible status: "none","available","downloaded_setup","downloaded_other","check_failed","download_failed"
        var responseElem = await findFirstElem(document, 'status');
        logger.i(responseElem);
        if (responseElem != null) {
          if (responseElem == "available" || responseElem == "downloaded_setup") {
            _networkList.cockpitUpdate = true;
          }
          else if( responseElem == "none"){
            _networkList.setUpdateList([]);
            _networkList.changedList();
            _networkList.cockpitUpdate = false;
            }
          else {
            _networkList.cockpitUpdate = false;
          }
        }

        if (xmlDebugResponseList.length >= maxResponseListSize){
          xmlDebugResponseList.removeLast();
          xmlDebugResponseList.removeLast();
        }
        xmlDebugResponseList.insert(0, document);
        xmlDebugResponseList.insert(0, DateTime.now());

        logger.d('UpdateIndication found ->');
        logger.v(document);

      }

      else {

        if (xmlDebugResponseList.length >= maxResponseListSize){
          xmlDebugResponseList.removeLast();
          xmlDebugResponseList.removeLast();
        }
        xmlDebugResponseList.insert(0, document);
        xmlDebugResponseList.insert(0, DateTime.now());

        logger.d('Another Response found ->');
        logger.v(document);

        var xmlResponseType = document.findAllElements('MessageType').first.innerText;

        if(!xmlResponseMap.containsKey(xmlResponseType)) {
          xmlResponseMap[xmlResponseType] = [];
        }
        xmlResponseMap[xmlResponseType]!.add(document);

      }
    }

    _networkList.fillNetworkNames();

    logger.d('parsed XML - DeviceList ready!');

    //return document;
  }

  // Warning! "UpdateCheck" and "RefreshNetwork" should only be triggered by a user interaction, not continuously/automatically
  void sendXML(
    String messageType, {
    String? newValue,
    String? valueType,
    String? newValue2,
    String? valueType2,
    String? mac,
    Map<String,String>? updateDevices,
  }) {

    String? xmlString;

    if (messageType == "Config") {

      int allowDataCollection = 0, ignoreUpdates = 0, windowsNetworkThrottlingDisabled = 0;
      if (config["allow_data_collection"] == true) {
        allowDataCollection = 1;
      }
      if (config["ignore_updates"] == true) {
        ignoreUpdates = 1;
      }
      if (config["windows_network_throttling_disabled"] == true) {
        windowsNetworkThrottlingDisabled = 1;
      }

      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <!DOCTYPE boost_serialization><boost_serialization signature="serialization::archive" version="13"><Message class_id="0" tracking_level="0" version="0"><MessageType>' +
          messageType +
          '</MessageType><Config class_id="1" tracking_level="0" version="0"><count>3</count><item_version>0</item_version><item class_id="2" tracking_level="0" version="0"><first>allow_data_collection</first><second>' +
          allowDataCollection.toString() +
          '</second></item><item><first>ignore_updates</first><second>' +
          ignoreUpdates.toString() +
          '</second></item><item><first>windows_network_throttling_disabled</first><second>' +
          windowsNetworkThrottlingDisabled.toString() +
          '</second></item></Config></Message></boost_serialization>';
    } else if (messageType == "FirmwareUpdateResponse") {
      Map<String,String> updateDeviceMap = updateDevices!;
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="2" version="0" tracking_level="0"><MessageType>FirmwareUpdateResponse</MessageType><DeviceList class_id="3" version="0" tracking_level="0">'
          '<count>' + (updateDeviceMap.length).toString() + '</count>'
          '<item_version>0</item_version>';

      updateDeviceMap.forEach((mac,password) => {
        xmlString = xmlString! + '<item><first class_id="4" version="0" tracking_level="0">'
      '<macAddress>' + mac +'</macAddress>'
      '</first>'
      '<second>' + password + '</second>'
      '</item>'
      });

      xmlString = xmlString! + '</DeviceList></Message></boost_serialization>';

    } else if (messageType == "UpdateResponse") {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType>' + '<' + valueType! + '>' + newValue! + '</' + valueType + '>' + '</Message></boost_serialization>';
    } else if (messageType == "SetVDSLCompatibility" || messageType == "SetIpConfig") {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType><macAddress>' + mac! + '</macAddress><' + valueType2! + '>' + newValue2! + '</' + valueType2 + '><' + valueType! + '>' + newValue! + '</' + valueType + '>' + '</Message></boost_serialization>';
    } else if (newValue == null && mac != null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType><macAddress>' + mac + '</macAddress></Message></boost_serialization>';
    } else if (newValue2 == null && mac != null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType><macAddress>' + mac + '</macAddress>' + '<' + valueType! + '>' + newValue! + '</' + valueType + '></Message></boost_serialization>';
    } else if (newValue2 != null && mac == null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType>' + '<' + valueType! + '>' + newValue! + '</' + valueType + '>' + '<' + valueType2! + '>' + newValue2 + '</' + valueType2 + '>' + '</Message></boost_serialization>';
    } else if (mac == null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType></Message></boost_serialization>';
    }

    String xmlLength = xmlString!.runes.length.toRadixString(16).padLeft(8, '0'); // message length for backend !disconnects if header wrong or missing!
    //logger.i('LEEENNNGGTHHH ' + xmlLength);
    logger.d("SendXML ->");
    logger.v(xmlString);
    socket.write('MSGSOCK' + xmlLength + xmlString!);
  }

  void sendSupportInfo(String supportId, String userName, String emailAddr){

    String _from = emailAddr;
    String _body = "Name:       " + userName + "\n" + "Support-ID: " + supportId + "\n" + "E-Mail:     " + emailAddr + "\n";
    String _dest = "devolo";

    String xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0">'
        '<MessageType>' + "SupportInfoSend" + '</MessageType>' +
        '<' + "from" + '>' + _from + '</' + "from" + '>' +
        '<' + "body" + '>' + _body + '</' + "body" + '>' +
        '<' + "dest" + '>' + _dest + '</' + "dest" + '>' +
        '</Message></boost_serialization>';

    String xmlLength = xmlString.runes.length.toRadixString(16).padLeft(8, '0'); // message length for backend !disconnects if header wrong or missing!
    logger.d("SendSupportInfo ->");
    logger.v(xmlString);
    socket.write('MSGSOCK' + xmlLength + xmlString);
  }

  Future<Map<String, dynamic>?> receiveXML(String wantedMessageTypes) async { //TODO List instead of string for exp.: ["UpdateIndication", "FirmwareUpdateIndication"]

    Map<String, dynamic> response = Map<String, dynamic>();
    String? responseElem;

    bool wait = true;
    //await new Future.delayed(const Duration(seconds: 2)); //TODO what is the reason to have a timeout here?

    await Future.doWhile(() async {

      if(xmlResponseMap.containsKey(wantedMessageTypes) || (wantedMessageTypes == "UpdateIndication && FirmwareUpdateIndication" && (xmlResponseMap.containsKey("UpdateIndication") || xmlResponseMap.containsKey("FirmwareUpdateIndication")))){

        if(wantedMessageTypes == "GetManualResponse"){
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'filename');
          if (responseElem != null) {
            response['filename'] = responseElem;
          }
        }

        else if(wantedMessageTypes == "SetAdapterNameStatus"){
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
          if (responseElem != null) {
            response['result'] = responseElem;
          }
        }

        else if (wantedMessageTypes == "UpdateIndication && FirmwareUpdateIndication") {
          wait = false;

          //"UpdateIndication" for Cockpit Software updates
          if (xmlResponseMap.keys.contains("UpdateIndication")) {
            responseElem = await findFirstElem(
                xmlResponseMap["UpdateIndication"]!.first, 'status');
            if (responseElem != null) {
              response['status'] = responseElem;
            }
            responseElem = await findFirstElem(
                xmlResponseMap["UpdateIndication"]!.first, 'commandline');
            if (responseElem != null) {
              response['commandline'] = responseElem;
            }
            responseElem = await findFirstElem(
                xmlResponseMap["UpdateIndication"]!.first, 'workdir');
            if (responseElem != null) {
              response['workdir'] = responseElem;
            }
          }

          //"FirmwareUpdateIndication" for device firmware updates
          else if (xmlResponseMap.keys.contains("FirmwareUpdateIndication")) {
            responseElem = await findFirstElem(
                xmlResponseMap["FirmwareUpdateIndication"]!.first, 'macAddress');
            if (responseElem != null) {
              response['macAddress'] = responseElem;
            }
          }
        }

        else if (wantedMessageTypes == "SupportInfoGenerateStatus") {
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != null) {
            response['status'] = responseElem;
          }
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'htmlfilename');
          if (responseElem != null) {
            response['htmlfilename'] = responseElem;
          }
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'zipfilename');
          if (responseElem != null) {
            response['zipfilename'] = responseElem;
          }
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
          if (responseElem != null) {
            response['result'] = responseElem;
          }
        }

        // here we want to ignore the first response with <status>running</status>
        else if (wantedMessageTypes == "ResetAdapterToFactoryDefaultsStatus") {

          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != "running") {
            wait = false;

            responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
            if (responseElem != null) {
              response['result'] = responseElem;
            }
          }
        }

        // ignore responses with <status>running</status> tag given by dLan devices
        else if (wantedMessageTypes == "IdentifyDeviceStatus") {

          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != "running") {
            wait = false;

            responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
            if (responseElem != null) {
              response['result'] = responseElem;
            }
          }
        }

        // ignore responses with <status>running</status>
        else if (wantedMessageTypes == "FirmwareUpdateStatus") {

          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != "running") {
            wait = false;

            var items = xmlResponseMap[wantedMessageTypes]!.first.findAllElements('item');
            for (var item in items) {

              if(item.getElement("second")!.innerText == "failed"){

                if(!response.containsKey('failed'))
                  response['failed'] = [];

                response['failed'].add(item.getElement("first")!.getElement("macAddress")!.innerText);
                logger.i("update failed: " + response['failed'].toString());
              }

              if(item.getElement("second")!.innerText == "password"){

                if(!response.containsKey('password'))
                  response['password'] = [];

                response['password'].add(item.getElement("first")!.getElement("macAddress")!.innerText);
                logger.i("password needed: " + response['password'].toString());
              }
            }

            response['status'] = responseElem;
          }
        }

        else if (wantedMessageTypes == "SetNetworkPasswordStatus") {
          logger.d(responseElem);

          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != null) {
              response['status'] = responseElem;
            }
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'total');
          if (responseElem != null) {
            response['total'] = responseElem;
          }
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'failed');
          if (responseElem != null) {
            response['failed'] = responseElem;
          }
        }

        // ignore responses with <status>running</status>
        else if (wantedMessageTypes == "AddRemoteAdapterStatus") {

          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != "running") {
            wait = false;

            responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
            if (responseElem != null) {
              response['result'] = responseElem;
            }
          }
        }

        else if (wantedMessageTypes == "SetVDSLCompatibilityStatus") {
          String? responseStatus = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
          logger.w(xmlResponseMap[wantedMessageTypes].toString());
          if (responseElem != null) {
            if (responseStatus != "running") {
              wait = false;
              response['result'] = responseElem;
            }
          }
        }

        // ignore responses with <status>running</status>
        else if (wantedMessageTypes == "SetIpConfigStatus") {

          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != "running") {
            wait = false;

            responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
            if (responseElem != null) {
              response['result'] = responseElem;
            }
          }
        }


        // responses where we need only the result tag
        else {
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
          if (responseElem != null) {
            response['result'] = responseElem;
          }
        }

        if(wantedMessageTypes == "UpdateIndication && FirmwareUpdateIndication"){
          if(xmlResponseMap.containsKey("UpdateIndication")){
            xmlResponseMap["UpdateIndication"]!.remove(xmlResponseMap["UpdateIndication"]!.first);

            if(xmlResponseMap["UpdateIndication"]!.length == 0){
              xmlResponseMap.remove("UpdateIndication");
            }
          }
          else{
            xmlResponseMap["FirmwareUpdateIndication"]!.remove(xmlResponseMap["FirmwareUpdateIndication"]!.first);

            if(xmlResponseMap["FirmwareUpdateIndication"]!.length == 0){
              xmlResponseMap.remove("FirmwareUpdateIndication");
            }
          }
        }
        else{
          logger.i(wantedMessageTypes);
          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
          }
        }
      }

      if(wait)
        await new Future.delayed(const Duration(milliseconds: 500));

      return wait;
    });

    logger.d("return Response -> ");
    logger.v(response.toString());
    return response;
  }

  Future<String?> findFirstElem(XmlDocument revXML, String word) async {
    //logger.i("revXML: "+ revXML.toString());
    dynamic ret = revXML.findAllElements(word);
    if (ret == null)
      return null;
    else if (ret.isEmpty == false)
      return ret.first.innerText;
    else
      return null;
  }

  Future<void> parseConfig(XmlDocument xmlResponse) async {

    for (var element in xmlResponse.findAllElements('item')) {
      if (element.lastElementChild!.innerText == "1") {
        config[element.firstElementChild!.innerText] = true;
      } else {
        config[element.firstElementChild!.innerText] = false;
      }
    }

    saveToSharedPrefs(config);
  }

  void parseFWUpdateStatus(XmlDocument xmlResponse) {
    var items = xmlResponse.findAllElements("item");
    for (var item in items) {

      try{
        Device dev = _networkList.getAllDevices().where((element) => element.mac == item.getElement("first")!.getElement("macAddress")!.innerText).first;
        String status = item.getElement("second")!.innerText;

        if (status == "complete") {
          dev.updateState = status;
          _networkList.getUpdateList().removeWhere((element) => element == dev.mac);
          _networkList.getCheckedUpdateMacs().removeWhere((element) => element == dev.mac);

        }
        if (status.endsWith("%")){
          dev.updateState = status.substring(status.indexOf(" ")+1, status.indexOf("%"));
        }
        else
          dev.updateState = status;


      } catch (e) {
        logger.w("parseUpdateStatus failed! - Maybe not in selected deviceList");
        logger.e(e);
        continue;
      }

    }
    _networkList.changedList();
  }

  void parseFWUpdateIndication(XmlDocument xmlResponse) {

    var items = xmlResponse.findAllElements("item");

    List<String> macAdresses = [];
    List<String> privacyWarningMacs = [];
    for (var item in items) {
      try {
        macAdresses.add(item.getElement("first")!.getElement("macAddress")!.innerText);
        if(item.getElement("second")!.innerText == "1"){
          privacyWarningMacs.add(item.getElement("first")!.getElement("macAddress")!.innerText);
        }

      } catch (e) {
        logger.w("ParseFWUpdateIndication failed! - Maybe not in selected deviceList");
        logger.e(e);
        continue;
      }
    }

    if(privacyWarningMacs.isEmpty){
      _networkList.setUpdateList(macAdresses);
    }
    else {
      _networkList.setUpdateList(macAdresses, privacyWarningMacs : privacyWarningMacs);
    }

    _networkList.changedList();
  }
}

