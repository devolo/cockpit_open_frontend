/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:io'; //only for non-web apps!!!
import 'dart:async';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';

class DataHand extends ChangeNotifier {
  late Socket socket;
  NetworkList _networkList = NetworkList();
  XmlDocument xmlResponse = XmlDocument();

  List<dynamic> xmlDebugResponseList = []; // used for debugging log
  int maxResponseListSize = 50; // determines the max number of displayed responses in debugging log

  bool waitingResponse = false;
  Map<String,List<dynamic>> xmlResponseMap = new Map<String,List<dynamic>>();

  // optional parameter to avoid the socket connection with the backend for testing
  DataHand([bool? testing]) {
    print("Creating new NetworkOverviewModelDesktop");
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
    print("Got Data!");
    String? xmlRawData = new String.fromCharCodes(data).trim();
    await parseXML(xmlRawData);
    notifyListeners();
  }

  //TODO - notify user about it?
  void errorHandler(error, StackTrace trace) {
    //FlutterError.dumpErrorToConsole(error);
    print(error);
    // socket.destroy();
    // return usefull?
    return (error);
  }

  //TODO - notify user about it?
  void doneHandler() {
    print("Server left");
    socket.destroy();
  }

  Future<void> parseXML(String? rawData) async {
    print("parsing XML ...");
    print(rawData);

    if (rawData == null || rawData == "") {
      print('XML empty');
      return;
    }

    var xmlDataList = []; //List for all xmlDocuments if dataHandler passes more than one xml
    String? xmlDataNext = rawData;

    while (xmlDataNext != null) {
      var xmlLength = int.parse(xmlDataNext.substring(7, 15), radix: 16); // cut the head in front of recieved xml
      //print("XmlLength: " + xmlLength.toString());
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
        _networkList.clearDeviceList();
        print('DeviceList found ->');

        var localDeviceList = document.findAllElements('LocalDeviceList').first.findElements('item'); //TODO: TEST call for every

        int listCounter = 0;
        for (var dev in localDeviceList) {
          Device device = Device.fromXML(dev, true);
          //print(device.toRealString());
          _networkList.addDevice(device, listCounter);

          for (var remoteDev in device.remoteDevices) {
            //print(remoteDev.toRealString());
            _networkList.addDevice(remoteDev, listCounter);
          }
          listCounter++;
        }

        // init deviceList again when images are loaded to display them
        if(!areDeviceIconsLoaded){
          notifyListeners();
          await Future.doWhile(() async {

            await new Future.delayed(const Duration(seconds: 1));
            if(areDeviceIconsLoaded){
              parseXML(rawData);
            }
            return !areDeviceIconsLoaded;
          }).timeout(Duration(seconds: 30), onTimeout: () {
            print('> Timed Out');
          });
        }

      } else if (document.findAllElements('MessageType').first.innerText == "Config") {
        parseConfig(document);
        print('Config found ->');
        print(document);
      } else if (document.findAllElements('MessageType').first.innerText == "FirmwareUpdateIndication") {
        xmlResponse = document;
        parseFWUpdateIndication(document);

        if (xmlDebugResponseList.length >= maxResponseListSize){
          xmlDebugResponseList.removeLast();
          xmlDebugResponseList.removeLast();
        }
        xmlDebugResponseList.insert(0, document);
        xmlDebugResponseList.insert(0, DateTime.now());

        print('FirmwareUpdateIndication found ->');
        print(document);
      } else if (document.findAllElements('MessageType').first.innerText == "FirmwareUpdateStatus") {
        parseUpdateStatus(document);

        if (xmlDebugResponseList.length >= maxResponseListSize){
          xmlDebugResponseList.removeLast();
          xmlDebugResponseList.removeLast();
        }
        xmlDebugResponseList.insert(0, document);
        xmlDebugResponseList.insert(0, DateTime.now());


        print('UpdateStatus found ->');
        print(document);
      } else {

        xmlResponse = document;

        if (xmlDebugResponseList.length >= maxResponseListSize){
          xmlDebugResponseList.removeLast();
          xmlDebugResponseList.removeLast();
        }
        xmlDebugResponseList.insert(0, document);
        xmlDebugResponseList.insert(0, DateTime.now());

        print('Another Response found ->');
        print(document);

        var xmlResponseType = document.findAllElements('MessageType').first.innerText;

        if(!xmlResponseMap.containsKey(xmlResponseType)) {
          xmlResponseMap[xmlResponseType] = [];
        }
        xmlResponseMap[xmlResponseType]!.add(document);

      }
    }

    print('parsed XML - DeviceList ready!');

    //return document;
  }

  // Warning! "UpdateCheck" and "RefreshNetwork" should only be triggered by a user interaction, not continously/automaticly
  void sendXML(
    String messageType, {
    String? newValue,
    String? valueType,
    String? newValue2,
    String? valueType2,
    String? mac,
  }) {

    waitingResponse = true;
    print(newValue);
    String? xmlString;

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

    if (messageType == "Config") {
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
    //print('LEEENNNGGTHHH ' + xmlLength);
    xmlResponse = XmlDocument(); // delete old xml response
    print(xmlString);
    socket.write('MSGSOCK' + xmlLength + xmlString);
  }

  Future<Map<String, dynamic>?> recieveXML([List<String>? wantedMessageTypes]) async {
    // ToDo generic?
    Map<String, dynamic> response = Map<String, dynamic>();
    String? responseElem;

    await new Future.delayed(const Duration(seconds: 2));

    await Future.doWhile(() async {
      print("waitingforResponse");
      await new Future.delayed(const Duration(seconds: 1));

      if (waitingResponse) {
        String? messageType = await findFirstElem(xmlResponse, 'MessageType');
        response['messageType'] = messageType;

        print("messageType: ${messageType}");
        print("wantedMessageTypes: ${wantedMessageTypes}");

        if (wantedMessageTypes!.contains(messageType)) {
          if (messageType == "Config") {
            parseConfig(xmlResponse);
            print(config.toString());
          } else if (messageType == "UpdateIndication") {
            //"UpdateIndication" for Cockpit Software updates
            response = (await parseUpdateIndication(xmlResponse))!;
            waitingResponse = false;
          } else if (messageType == "FirmwareUpdateIndication") {
            //"FirmwareUpdateIndication"
            responseElem = (await findFirstElem(xmlResponse, 'macAddress'))!; //
            if (responseElem != null) {
              response['macAddress'] = responseElem;
              int devIndex = _networkList.getDeviceList().indexWhere((element) => element.mac == responseElem);
            }
            waitingResponse = false;
          } else if (messageType == "SupportInfoGenerateStatus") {
            //"SupportInfoGenerateStatus"
            responseElem = await findFirstElem(xmlResponse, 'status');
            if (responseElem != null) {
              response['status'] = responseElem;
            }
            responseElem = await findFirstElem(xmlResponse, 'htmlfilename');
            if (responseElem != null) {
              response['htmlfilename'] = responseElem;
            }
            responseElem = await findFirstElem(xmlResponse, 'zipfilename');
            if (responseElem != null) {
              response['zipfilename'] = responseElem;
            }
            responseElem = await findFirstElem(xmlResponse, 'result');
            if (responseElem != null) {
              response['result'] = responseElem;
            }
            waitingResponse = false;
          } else if (messageType == "SetVDSLCompatibilityStatus") {
            responseElem = await findFirstElem(xmlResponse, 'result');
            if (responseElem != null) {
              response['result'] = responseElem;
            }
            if(responseElem != ""){
              waitingResponse = false;
            }
          } else {
            responseElem = await findFirstElem(xmlResponse, 'filename');
            if (responseElem != null) {
              response['filename'] = responseElem;
            }
            responseElem = await findFirstElem(xmlResponse, 'commandline');
            if (responseElem != null) {
              response['commandline'] = responseElem;
            }
            responseElem = await findFirstElem(xmlResponse, 'workdir');
            if (responseElem != null) {
              response['workdir'] = responseElem;
            }
            responseElem = await findFirstElem(xmlResponse, 'macAddress'); //ToDo probably more Macs!
            if (responseElem != null) {
              response['macAddress'] = responseElem;
              int devIndex = _networkList.getDeviceList().indexWhere((element) => element.mac == responseElem);
            }
            waitingResponse = false;
          }
          //waitingResponse = false;
        }
        //Future.value(response);//completer.complete();//return response;
      }
      return waitingResponse;
    }).timeout(Duration(seconds: 30), onTimeout: () {
      print('> Timed Out');
      waitingResponse = false;
      response["messageType"] = wantedMessageTypes;
      response["result"] = "failed";
      return response;

    });

    waitingResponse = false;
    print("Response: " + response.toString());
    return response;
  }

  Future<Map<String, dynamic>?> myReceiveXML(String wantedMessageTypes) async { //TODO List instead of string for exp.: ["UpdateIndication", "FirmwareUpdateIndication"]

    Map<String, dynamic> response = Map<String, dynamic>();
    String? responseElem;

    // introduced as response of SetNetworkPassword needs longer time
    var timoutTime = 30; //s
    if(wantedMessageTypes == "SetNetworkPasswordStatus")
      timoutTime = 120; //s

    bool wait = true;
    await new Future.delayed(const Duration(seconds: 2));

    await Future.doWhile(() async {

      //print("waitingforResponse");
      //print(wait);
      await new Future.delayed(const Duration(seconds: 1));
      //print(xmlResponseMap);
      if(xmlResponseMap.containsKey(wantedMessageTypes)){

        if(wantedMessageTypes == "GetManualResponse"){
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'filename');
          if (responseElem != null) {
            response['filename'] = responseElem;
          }
          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
          }

        }

        else if(wantedMessageTypes == "SetAdapterNameStatus"){
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
          if (responseElem != null) {
            response['result'] = responseElem;
          }
          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
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

          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
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

          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
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

          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
          }
        }

        else if (wantedMessageTypes == "SetNetworkPasswordStatus") {

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

          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
          }
        }

        else if (wantedMessageTypes == "UpdateIndication") {
          wait = false;
          response = (await parseUpdateIndication(xmlResponse))!;


          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
          }
        }
        else if (wantedMessageTypes == "FirmwareUpdateIndication") {
          wait = false;
          parseFWUpdateIndication(xmlResponse);


          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);

          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
          }
        }

        // responses where we need only the result tag
        else {
          wait = false;
          responseElem = await findFirstElem(xmlResponseMap[wantedMessageTypes]!.first, 'result');
          if (responseElem != null) {
            response['result'] = responseElem;
          }
          xmlResponseMap[wantedMessageTypes]!.remove(xmlResponseMap[wantedMessageTypes]!.first);
          if(xmlResponseMap[wantedMessageTypes]!.length == 0){
            xmlResponseMap.remove(wantedMessageTypes);
          }
        }

      }

      return wait;
    }).timeout(Duration(seconds: timoutTime), onTimeout: () {
      print('> Timed Out');
      response['status'] = "timeout";
      wait = false;
    });

    print("Response: " + response.toString());
    return response;
  }

  Future<String?> findFirstElem(XmlDocument revXML, String word) async {
    //print("revXML: "+ revXML.toString());
    dynamic ret = revXML.findAllElements(word);
    if (ret == null)
      return null;
    else if (ret.isEmpty == false)
      return ret.first.innerText;
    else
      return null;
  }

  Future<void> parseConfig(XmlDocument xmlResponse) async {

    print("parseConfig!!!!!!!!!!");
    for (var element in xmlResponse.findAllElements('item')) {
      if (element.lastElementChild!.innerText == "1") {
        config[element.firstElementChild!.innerText] = true;
      } else {
        config[element.firstElementChild!.innerText] = false;
      }
    }

    saveToSharedPrefs(config);
  }

  void parseUpdateStatus(XmlDocument xmlResponse) {
    var items = xmlResponse.findAllElements("item");
    for (var item in items) {
      Device dev = _networkList.getDeviceList().where((element) => element.mac == item.getElement("first")!.getElement("macAddress")!.innerText).first;
      String status = item.getElement("second")!.innerText;

      dev.updateState = status;
      if (status == "complete") _networkList.getUpdateList().removeWhere((element) => element == dev.mac);
      if (status.endsWith("%")) dev.updateStateInt = double.parse(status.substring(status.indexOf(" "), status.indexOf("%")));
      if (status == "pending") dev.updateState = "pending";

      print(dev.toRealString());
    }
    _networkList.changedList();
  }

  void parseFWUpdateIndication(XmlDocument xmlResponse) {
    var items = xmlResponse.findAllElements("item");
    //var macs = item.findAllElements("macAddress"); //ToDo List !! Get Test Devices to get more devices with updates
    _networkList.getUpdateList().clear();

    for (var item in items) {
      try {
        Device dev = _networkList.getDeviceList().where((element) => element.mac == item.getElement("first")!.getElement("macAddress")!.innerText).first;
        _networkList.getUpdateList().add(dev.mac);
      } catch (e) {
        print("ParseFWUpdateIndication failed! - Maybe not in selected deviceList");
        print(e);
        return null;
      }
      //print(dev.toRealString());
      print(_networkList.getUpdateList());
    }
    _networkList.changedList();
  }

  Future<Map<String, dynamic>?> parseUpdateIndication(XmlDocument xmlResponse) async {
    Map<String, dynamic>? response = Map<String, dynamic>();
    String? responseElem;

    String messageType = xmlResponse.findAllElements("MessageType").first.innerText;
    response['messageType'] = messageType;

    responseElem = await findFirstElem(xmlResponse, 'status');
    if (responseElem != null) {
      response['status'] = responseElem;
    }
    responseElem = await findFirstElem(xmlResponse, 'commandline');
    if (responseElem != null) {
      response['commandline'] = responseElem;
    }
    responseElem = await findFirstElem(xmlResponse, 'workdir');
    if (responseElem != null) {
      response['workdir'] = responseElem;
    }

    if (response['status'] == "none") {
      _networkList.cockpitUpdate = false;
    } else {
      _networkList.cockpitUpdate = true;
    }

    //_deviceList.changedList();
    print("ResponseUpdateIndication: " + response.toString());
    return response;
  }
}
