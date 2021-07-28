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

class DataHand extends ChangeNotifier {
  late Socket socket;
  NetworkList _networkList = NetworkList();

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
    socket = await Socket.connect("localhost", 24271);
    socket.listen(
        (data) => dataHandler(data),
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false
    );

    //commenting out this part of code resolves the starting issue when double clicking the application - seems not to be needed
    //stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  Future<void> dataHandler(data) async {
    logger.d("[dataHandler] - Got Data!");
    String? xmlRawData = new String.fromCharCodes(data).trim();
    await parseXML(xmlRawData);
    notifyListeners();
  }

  //TODO - notify user about it?
  void errorHandler(error, StackTrace trace) {
    //FlutterError.dumpErrorToConsole(error);
    // socket.destroy();
    logger.e(error);
    // return usefull?
    return (error);
  }

  //TODO - notify user about it?
  void doneHandler() {
    logger.w("Server left");
    socket.destroy();
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
        logger.v(document);
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
          } else {
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
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="2" version="0" tracking_level="0"><MessageType>FirmwareUpdateResponse</MessageType><DeviceList class_id="3" version="0" tracking_level="0"><count>1</count><item_version>0</item_version><item><first class_id="4" version="0" tracking_level="0"><macAddress>' +
          newValue! +
          '</macAddress></first><second></second></item></DeviceList></Message></boost_serialization>';
    } else if (messageType == "UpdateResponse") {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType>' + '<' + valueType! + '>' + newValue! + '</' + valueType + '>' + '</Message></boost_serialization>';
    } else if (messageType == "SetVDSLCompatibility") {
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
    socket.write('MSGSOCK' + xmlLength + xmlString);
  }

  Future<Map<String, dynamic>?> receiveXML(String wantedMessageTypes) async { //TODO List instead of string for exp.: ["UpdateIndication", "FirmwareUpdateIndication"]

    Map<String, dynamic> response = Map<String, dynamic>();
    String? responseElem;

    // introduced as response of SetNetworkPassword needs longer time
    var timoutTime = 30; //s
    if(wantedMessageTypes == "SetNetworkPasswordStatus")
      timoutTime = 120; //s

    if(wantedMessageTypes == "FirmwareUpdateStatus")
      timoutTime = 300; //s

    if(wantedMessageTypes == "AddRemoteAdapterStatus")
      timoutTime = 300; //s

    if(wantedMessageTypes == "IdentifyDeviceStatus")
      timoutTime = 300; //s

    bool wait = true;
    await new Future.delayed(const Duration(seconds: 2));

    await Future.doWhile(() async {

      await new Future.delayed(const Duration(seconds: 1));

      if(xmlResponseMap.containsKey(wantedMessageTypes)){

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

        // variable cockpit update is already set in parseXML
        else if (wantedMessageTypes == "UpdateIndication") {
          //"UpdateIndication" for Cockpit Software updates
          wait = false;

          response['messageType'] = wantedMessageTypes;

          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'status');
          if (responseElem != null) {
            response['status'] = responseElem;
          }
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'commandline');
          if (responseElem != null) {
            response['commandline'] = responseElem;
          }
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'workdir');
          if (responseElem != null) {
            response['workdir'] = responseElem;
          }

        }

        else if (wantedMessageTypes == "FirmwareUpdateIndication") {
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'macAddress');
          if (responseElem != null) {
            response['macAddress'] = responseElem;
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
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
          if (responseElem != null) {
            response['result'] = responseElem;
          }
          if(responseElem != ""){
            wait = false;
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

        xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

        if(xmlResponseMap[wantedMessageTypes]!.length == 0){
          xmlResponseMap.remove(wantedMessageTypes);
        }

      }

      return wait;
    }).timeout(Duration(seconds: timoutTime), onTimeout: () {
      logger.w('Receive Response Timed Out');
      response['status'] = "timeout";
      wait = false;
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
    //var macs = item.findAllElements("macAddress"); //ToDo List !! Get Test Devices to get more devices with updates
    _networkList.getUpdateList().clear();

    for (var item in items) {
      try {
        Device dev = _networkList.getAllDevices().where((element) => element.mac == item.getElement("first")!.getElement("macAddress")!.innerText).first;
        _networkList.getUpdateList().add(dev.mac);
      } catch (e) {
        logger.w("ParseFWUpdateIndication failed! - Maybe not in selected deviceList");
        logger.e(e);
        continue;
      }
    }
    _networkList.changedList();
  }
}
