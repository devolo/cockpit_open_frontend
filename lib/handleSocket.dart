import 'dart:io';  //only for non-web apps!!!
import 'dart:async';
import 'package:cockpit_devolo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart' ;
import 'deviceModel.dart';


class dataHand extends ChangeNotifier {
  Socket socket;
  final DeviceList _deviceList = DeviceList();
  dynamic xmlLength;

  dataHand() {
    print("Creating new NetworkOverviewModelDesktop");
    handleSocket();
  }

  DeviceList get getdeviceList {
    //
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
    String xmlData = new String.fromCharCodes(data).trim();
    print(xmlData);
    parseXML(xmlData);
    notifyListeners();

  }

  void errorHandler(error, StackTrace trace) {
    print(error);
    return (error);
  }

  void doneHandler() {
    socket.destroy();
  }

  void parseXML(String xmlData) {
    print("============================ Entering parseXML ================================");

    if (xmlData == null) {
      print('XML empty');
      return;
    }

    xmlLength = xmlData.substring(7, 15); // cut the head in front of recieved xml (example: MSGSOCK00001f63) first 7 bytes-> Magicword; next 8 bytes -> message length
    xmlLength = int.parse(xmlLength, radix: 16); // parse HexSting to int  //print("XmlLength: " + xmlLength.toString());
    xmlData = xmlData.substring(xmlData.indexOf('<?'), xmlLength + 13); //why 13? I dont know yet -_(o.O)_- //TODO

    final document = XmlDocument.parse(xmlData);
    if (document.findAllElements('LocalDeviceList').isEmpty) { // ToDo !!!BUG!!! think this is why its loading too long (2 xml in one split)
      print('DeviceList not found!');
      return;
    }

    _deviceList.clearList();

    var localDeviceList = document.findAllElements('LocalDeviceList'); //TODO: TEST call for every localDevice
    for (var dev in localDeviceList) {
      Device device = Device.fromXML(dev.getElement('item'));
      _deviceList.addDevice(device);
      print(device.type);
      for (var remotedev in device.remoteDevices) {
        _deviceList.addDevice(remotedev);
        print(remotedev.type);
      }
    }
    print('DeviceList ready');
    notifyListeners();
    //return document;
  }

  void sendXML(String messageType, {String newValue, String valueType, String newValue2, String valueType2, String mac,}) {  //TODO getting response from backend, maybe use it
    print(newValue);
    String xmlString;

    if(newValue == null){
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+messageType+'</MessageType><macAddress>'+mac+'</macAddress></Message></boost_serialization>';
    }
    else if (newValue2 == null){
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+messageType+'</MessageType><macAddress>'+mac+'</macAddress>'+'<'+valueType+'>'+newValue+'</'+valueType+'></Message></boost_serialization>';
    }
    else {
      xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+messageType+'</MessageType>'+'<'+valueType+'>'+newValue+'</'+valueType+'>'+'<'+valueType2+'>'+newValue2+'</'+valueType2+'>'+'</Message></boost_serialization>';
    }

    String xmlLength = xmlString.runes.length.toRadixString(16).padLeft(8, '0'); // message length for backend !disconnects if header wrong or missing!
    print('LEEENNNGGTHHH ' + xmlLength);
    print(xmlString);
    socket.write('MSGSOCK'+ xmlLength + xmlString);
  }

  // void testSendXML(){
  //   String send = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>'+action+'</MessageType><product>'+MT+'</product><language>de</language></Message></boost_serialization>';
  //   print(send);
  //   String xmlLength = send.runes.length.toRadixString(16).padLeft(8, '0');
  //   print('LEEENNNGGTHHH ' + xmlLength);
  //   socket.write('MSGSOCK'+ xmlLength + send);
  // }

}