import 'dart:io';  //only for non-web apps!!!
import 'dart:async';
import 'package:cockpit_devolo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart' ;
import 'deviceClass.dart';


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
    parseXML(xmlData);
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
      final emptyXml = '''<?xml version="1.0" ?>
<metadata>
</metadata>'''; //TODO Shitty workaround,  Note: maby work with messagetype? NetworkUpdate
      print("Empty String");
      final document = XmlDocument.parse(emptyXml);
      //return document;
    }

    xmlLength = xmlData.substring(7, 15); // cut the head in front of recieved xml (example: MSGSOCK00001f63) first 7 bytes-> Magicword; next 8 bytes -> message length
    xmlLength = int.parse(xmlLength, radix: 16); // parse HexSting to int  //print("XmlLength: " + xmlLength.toString());
    xmlData = xmlData.substring(xmlData.indexOf('<?'), xmlLength + 13); //why 13? I dont know yet -_(o.O)_- //TODO

    final document = XmlDocument.parse(xmlData);
    if (document.findAllElements('LocalDeviceList').isEmpty) {
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
    notifyListeners();
    //return document;
  }

  void sendXML(String newName, String mac) {
    print(newName);
    String xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><!DOCTYPE boost_serialization><boost_serialization version="5" signature="serialization::archive"><Message class_id="1" version="0" tracking_level="0"><MessageType>SetAdapterName</MessageType><macAddress>'+mac+'</macAddress><name>'+newName+'</name></Message></boost_serialization>';
    //var len = xmlString.runes.length;
    String xmlLength = xmlString.runes.length.toRadixString(16).padLeft(8, '0');
    print('LEEENNNGGTHHH ' + xmlLength);
    print(xmlString);
    socket.write('MSGSOCK'+ xmlLength + xmlString);
  }
}