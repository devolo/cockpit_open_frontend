import 'dart:io';  //only for non-web apps!!!
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart' ;
import 'deviceModel.dart';
import 'helpers.dart';



class dataHand extends ChangeNotifier {
  Socket socket;
  final DeviceList _deviceList = DeviceList();
  dynamic xmlLength;
  var xmlResponse;

  dataHand() {
    print("Creating new NetworkOverviewModelDesktop");
    handleSocket();
  }

  DeviceList get getdeviceList {
    return _deviceList;
  }

  void set setdeviceList(List<Device> devList) {
    notifyListeners();
    _deviceList.devices = devList;
  }

  void handleSocket() {
    Socket.connect("localhost", 24271).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false);
    }).catchError((Object e) { // was AsyncError before ???
      print("Unable to connect: $e");
    });
    //Connect standard in to the socket
    stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  void dataHandler(data) {
    String xmlRawData = new String.fromCharCodes(data).trim();
    //print(xmlRawData);
    parseXML(xmlRawData);
    notifyListeners();

  }

  void errorHandler(error, StackTrace trace) {
    print(error);
    return (error);
  }

  void doneHandler() {
    socket.destroy();
  }

  void parseXML(String rawData) {
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

    while(xmlDataNext != null ){
      xmlLength = xmlDataNext.substring(7, 15); // cut the head in front of recieved xml
        print("XmlLengthHEX: " + xmlLength.toString());
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
    for(var xmlDoc in xmlDataList){
      document = XmlDocument.parse(xmlDoc);
      if (document.findAllElements('LocalDeviceList').isNotEmpty) {
        _deviceList.clearList();
        print('DeviceList found!');
        break;
      }
      xmlResponse = document;
      print('DeviceList NOT found!');
    }

    print('DOC: ' + document.toString());

    var localDeviceList = document.findAllElements('LocalDeviceList'); //TODO: TEST call for every
    for (var dev in localDeviceList) {
      Device device = Device.fromXML(dev.getElement('item'));
      _deviceList.addDevice(device);
      print(device.type);
      for (var remoteDev in device.remoteDevices) {
        _deviceList.addDevice(remoteDev);
        print(remoteDev.type);
      }
    }
    print('DeviceList ready');
    if(areDeviceIconsLoaded)
      notifyListeners();
    //return document;
  }

  void sendXML(String messageType, {String newValue, String valueType, String newValue2, String valueType2, String mac,}) {  //TODO Test!!, getting response from backend, maybe use it
    print(newValue);
    String xmlString;

    if(newValue == null && mac != null){
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+messageType+'</MessageType><macAddress>'+mac+'</macAddress></Message></boost_serialization>';
    }
    else if (newValue2 == null && mac != null){
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+messageType+'</MessageType><macAddress>'+mac+'</macAddress>'+'<'+valueType+'>'+newValue+'</'+valueType+'></Message></boost_serialization>';
    }
    else if (newValue2 != null && mac == null) {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+messageType+'</MessageType>'+'<'+valueType+'>'+newValue+'</'+valueType+'>'+'<'+valueType2+'>'+newValue2+'</'+valueType2+'>'+'</Message></boost_serialization>';
    }
    else if(mac == null){
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+messageType+'</MessageType></Message></boost_serialization>';
    }

    String xmlLength = xmlString.runes.length.toRadixString(16).padLeft(8, '0'); // message length for backend !disconnects if header wrong or missing!
    //print('LEEENNNGGTHHH ' + xmlLength);
    print(xmlString);
    socket.write('MSGSOCK'+ xmlLength + xmlString);
  }

  List<String> recieveXML(XmlDocument revXML){ // ToDo generic?
    List<String> response = [];
    String status = revXML.findAllElements('status').first.innerText;
    response.add(status);
    String messageType = revXML.findAllElements('MessageType').first.innerText;
    response.add(messageType);

    return response;

  }


}