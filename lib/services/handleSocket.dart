import 'dart:io'; //only for non-web apps!!!
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';

class dataHand extends ChangeNotifier {
  Socket socket;
  DeviceList _deviceList;
  dynamic xmlLength;
  XmlDocument xmlResponse;
  bool waitingResponse = false;

  dataHand() {
    print("Creating new NetworkOverviewModelDesktop");
    handleSocket();
  }

  void setDeviceList(DeviceList devList) {
    _deviceList = devList;
    //_deviceList.setDeviceList(devList);
  }

  void handleSocket() {
    Socket.connect("localhost", 24271).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler, onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    }).catchError((Object e) {
      // was AsyncError before ???
      print("Unable to connect: $e");
    });
    //Connect standard in to the socket
    stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  Future<void> dataHandler(data) async {
    String xmlRawData = new String.fromCharCodes(data).trim();
    //print(xmlRawData);
    await parseXML(xmlRawData);
    notifyListeners();
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
    return (error);
  }

  void doneHandler() {
    socket.destroy();
  }

  Future<void> parseXML(String rawData) async {
    print("============================ Entering parseXML ================================");

    if (rawData == null) {
      print('XML empty');
      return;
    }

    // xmlLength = xmlRawData.substring(7, 15); // cut the head in front of recieved xml (example: MSGSOCK00001f63) first 7 bytes-> Magicword; next 8 bytes -> message length
    // xmlLength = int.parse(xmlLength, radix: 16); // parse HexSting to int  //print("XmlLength: " + xmlLength.toString());
    // var xmlDataFirst = xmlRawData.substring(xmlRawData.indexOf('<?'), xmlLength + 13); //why 13? I dont know yet -_(o.O)_- //TODO
    // xmlDataList.add(xmlDataFirst);

    var xmlDataList = []; //List for all xmlDocuments if dataHandler passes more than one xml
    var xmlDataNext = rawData; //

    while (xmlDataNext != null) {
      xmlLength = xmlDataNext.substring(7, 15); // cut the head in front of recieved xml
      //print("XmlLengthHEX: " + xmlLength.toString());
      xmlLength = int.parse(xmlLength, radix: 16);
      print("XmlLength: " + xmlLength.toString());
      var xmlSingleDoc = xmlDataNext.substring(rawData.indexOf('<?'), xmlLength + 13); //why 13? I dont know yet -_(o.O)_- //TODO
      xmlDataList.add(xmlSingleDoc);
      try {
        xmlDataNext = xmlDataNext.substring(xmlLength + 15);
      } catch (error) {
        //print(error);
        xmlDataNext = null;
      }
    }

    //print(xmlDataList);

    XmlDocument document;
    for (var xmlDoc in xmlDataList) {
      document = XmlDocument.parse(xmlDoc);

      if (document.findAllElements('MessageType').first.innerText == "NetworkUpdate") { // If received Message is general NetworkUpdate
        _deviceList.clearList();
        print('DeviceList found!');

        var localDeviceList = document.findAllElements('LocalDeviceList'); //TODO: TEST call for every
        for (var dev in localDeviceList) {
          Device device = Device.fromXML(dev.getElement('item'),true);
          _deviceList.addDevice(device);
          for (var remoteDev in device.remoteDevices) {
            _deviceList.addDevice(remoteDev);
          }
        }

        // Check if new Devices have Updates to set updateAvailable
        sendXML('UpdateCheck');
        await recieveXML();
        _deviceList.changedList();
        break;
      }
      else if (document.findAllElements('MessageType').first.innerText == "Config") {
        parseConfig(document);
        print('Config found!');
      }
      else if (document.findAllElements('MessageType').first.innerText == "UpdateIndication") {
        waitingResponse = false;
        xmlResponse = document;
        print('Update found ->');
        print(document);
      }
      else {
        waitingResponse = false;
        xmlResponse = document;
        print('Another Response found ->');
        print(document);
      }
    }

    print('DeviceList ready');

    if (areDeviceIconsLoaded) notifyListeners();
    //return document;
  }

  //ToDo send real xml not just string
  void sendXML(
    String messageType, {
    String newValue,
    String valueType,
    String newValue2,
    String valueType2,
    String mac,
  }) {
    //TODO Test!!, getting response from backend, use it
    waitingResponse = true;
    print(newValue);
    String xmlString;

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
    }
    else if (messageType == "FirmwareUpdateResponse"){ // ToDo Update more devices
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="2" version="0" tracking_level="0"><MessageType>FirmwareUpdateResponse</MessageType><DeviceList class_id="3" version="0" tracking_level="0"><count>1</count><item_version>0</item_version><item><first class_id="4" version="0" tracking_level="0"><macAddress>' + newValue + '</macAddress></first><second></second></item></DeviceList></Message></boost_serialization>';
    }

    else if (newValue == null && mac != null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType><macAddress>' + mac + '</macAddress></Message></boost_serialization>';
    } else if (newValue2 == null && mac != null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType><macAddress>' + mac + '</macAddress>' + '<' + valueType + '>' + newValue + '</' + valueType + '></Message></boost_serialization>';
    } else if (newValue2 != null && mac == null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType>' + '<' + valueType + '>' + newValue + '</' + valueType + '>' + '<' + valueType2 + '>' + newValue2 + '</' + valueType2 + '>' + '</Message></boost_serialization>';
    } else if (mac == null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' + messageType + '</MessageType></Message></boost_serialization>';
    }

    String xmlLength = xmlString.runes.length.toRadixString(16).padLeft(8, '0'); // message length for backend !disconnects if header wrong or missing!
    //print('LEEENNNGGTHHH ' + xmlLength);
    print(xmlString);
    socket.write('MSGSOCK' + xmlLength + xmlString);
  }

  Future<Map<String, dynamic>> recieveXML() async {
    // ToDo generic?
    final Map response = new Map<String, dynamic>();
    String responseElem;

    await new Future.delayed(const Duration(seconds: 2));
    Completer<Map<String, dynamic>> completer = new Completer();
    //handOut(completer.future);
    //await _waitingResponse = false;

    await Future.doWhile(() async {
      print("waitingforResponse");
      await new Future.delayed(const Duration(seconds: 1));

      if (!waitingResponse) {
        String messageType = await findFirstElem(xmlResponse, 'MessageType');
        response['messageType'] = messageType;
        if (messageType == "Config") {
          parseConfig(xmlResponse);
          print(config.toString());
        }

        // for(var elem in xmlResponse.findAllElements('Message').first.children){
        //   print("Element "+elem.toString());
        //   print(elem.innerText);
        // }

        responseElem = await findFirstElem(xmlResponse, 'status');
        if (responseElem != null) {
          response['status'] = responseElem;
        }
        responseElem = await findFirstElem(xmlResponse, 'filename');
        if (responseElem != null) {
          response['filename'] = responseElem;
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
          int devIndex = _deviceList.getDeviceList().indexWhere((element) => element.mac == responseElem);
          _deviceList.getDeviceList()[devIndex].updateAvailable = true;
        }

        //Future.value(response);
        completer.complete();
        //return response;
      }
      return waitingResponse;
    });
    print("Response: " + response.toString());
    return response;
  }

  Future<String> findFirstElem(XmlDocument revXML, String word) async {
    //print("revXML: "+ revXML.toString());
    dynamic ret = revXML.findAllElements(word);
    if (ret.isEmpty == false)
      ret = ret.first.innerText;
    else
      ret = null;
    return ret;
  }

  void parseConfig(XmlDocument xmlResponse) {
    for (var element in xmlResponse.findAllElements('item')) {
      //print(element.firstElementChild.innerText); //print(element.lastElementChild.innerText);
      if (element.lastElementChild.innerText == "1") {
        config[element.firstElementChild.innerText] = true;
      } else {
        config[element.firstElementChild.innerText] = false;
      }
    }
  }
}
