import 'dart:io'; //only for non-web apps!!!
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import '../models/deviceModel.dart';
import '../shared/helpers.dart';

class dataHand extends ChangeNotifier {
  Socket socket;
  DeviceList _deviceList;
  dynamic xmlLength;
  XmlDocument xmlResponse;
  bool loading = true;

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

    print(xmlDataList);

    XmlDocument document;
    for (var xmlDoc in xmlDataList) {
      document = XmlDocument.parse(xmlDoc);
      if (document.findAllElements('MessageType').first.innerText == "NetworkUpdate") {
        _deviceList.clearList();
        print('DeviceList found!');
        break;
      }
      else if (document.findAllElements('MessageType').first.innerText == "Config") {
        parseConfig(document);
        print('Config found!');
      }
      else if (document.findAllElements('MessageType').first.innerText == "UpdateIndication") {
        parseConfig(document);
        print('Update found!');
      }

      xmlResponse = document;
      print('Another Response found');
    }

    //print('DOC: ' + document.toString());

    var localDeviceList = document.findAllElements('LocalDeviceList'); //TODO: TEST call for every
    for (var dev in localDeviceList) {
      Device device = Device.fromXML(dev.getElement('item'));
      _deviceList.addDevice(device);
      for (var remoteDev in device.remoteDevices) {
        _deviceList.addDevice(remoteDev);
      }
    }
    print('DeviceList ready');
    if (areDeviceIconsLoaded) notifyListeners();
    //return document;
  }

  void sendXML(
    String messageType, {
    String newValue,
    String valueType,
    String newValue2,
    String valueType2,
    String mac,
  }) {
    //TODO Test!!, getting response from backend, maybe use it
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
      xmlString =
          '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <!DOCTYPE boost_serialization><boost_serialization signature="serialization::archive" version="13"><Message class_id="0" tracking_level="0" version="0"><MessageType>' +
              messageType +
              '</MessageType><Config class_id="1" tracking_level="0" version="0"><count>3</count><item_version>0</item_version><item class_id="2" tracking_level="0" version="0"><first>allow_data_collection</first><second>' +
              allowDataCollection.toString() +
              '</second></item><item><first>ignore_updates</first><second>' +
              ignoreUpdates.toString() +
              '</second></item><item><first>windows_network_throttling_disabled</first><second>' +
              windowsNetworkThrottlingDisabled.toString() +
              '</second></item></Config></Message></boost_serialization>';
    } else if (newValue == null && mac != null) {
      xmlString =
          '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' +
              messageType +
              '</MessageType><macAddress>' +
              mac +
              '</macAddress></Message></boost_serialization>';
    } else if (newValue2 == null && mac != null) {
      xmlString =
          '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' +
              messageType +
              '</MessageType><macAddress>' +
              mac +
              '</macAddress>' +
              '<' +
              valueType +
              '>' +
              newValue +
              '</' +
              valueType +
              '></Message></boost_serialization>';
    } else if (newValue2 != null && mac == null) {
      xmlString =
          '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' +
              messageType +
              '</MessageType>' +
              '<' +
              valueType +
              '>' +
              newValue +
              '</' +
              valueType +
              '>' +
              '<' +
              valueType2 +
              '>' +
              newValue2 +
              '</' +
              valueType2 +
              '>' +
              '</Message></boost_serialization>';
    } else if (mac == null) {
      xmlString =
          '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>' +
              messageType +
              '</MessageType></Message></boost_serialization>';
    }

    String xmlLength = xmlString.runes.length.toRadixString(16).padLeft(8, '0'); // message length for backend !disconnects if header wrong or missing!
    //print('LEEENNNGGTHHH ' + xmlLength);
    print(xmlString);
    socket.write('MSGSOCK' + xmlLength + xmlString);
  }

  Future<Map<String, dynamic>> recieveXML() async {
    // ToDo generic?
    loading = true;
    final Map response = new Map<String, dynamic>();

    await new Future.delayed(const Duration(seconds: 2));
    Completer<Map<String, dynamic>> completer = new Completer();
    //handOut(completer.future);

    String messageType = await findFirstElem(xmlResponse, 'MessageType');
    response['messageType'] = messageType;
    if (messageType == "Config") {
      parseConfig(xmlResponse);
      print(config.toString());
    }

    String status = await findFirstElem(xmlResponse, 'status');
    if (status != null) {
      response['status'] = status;
    }

    String filename = await findFirstElem(xmlResponse, 'filename');
    if (filename != null) {
      response['filename'] = filename;
    }

    String htmlfilename = await findFirstElem(xmlResponse, 'htmlfilename');
    if (htmlfilename != null) {
      response['htmlfilename'] = htmlfilename;
    }
    String zipfilename = await findFirstElem(xmlResponse, 'zipfilename');
    if (zipfilename != null) {
      response['zipfilename'] = zipfilename;
    }

    print("Response: " + response.toString());
    //Future.value(response);
    await Future.value(status);
    await Future.value(filename);
    completer.complete();
    return response;
  }

  Future<String> findFirstElem(XmlDocument revXML, String word) async {
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
