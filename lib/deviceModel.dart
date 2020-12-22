import 'dart:ui' as ui;
import 'package:cockpit_devolo/handleSocket.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'helpers.dart';
import 'package:cockpit_devolo/main.dart';



enum DeviceType { dtLanMini, dtLanPlus, dtWiFiMini, dtWiFiPlus, dtWiFiOnly, dtUnknown }

class DataratePair {
  DataratePair(int rx, int tx) {
    this.rx = rx;
    this.tx = tx;
  }

  int tx;
  int rx;
}

class DeviceList extends ChangeNotifier{
  List<Device> devices;

  DeviceList() {
    this.devices = <Device>[];
    //notifyListeners();
  }

  void addDevice(Device device) {
    this.devices.add(device);
    print(devices.toString());
    notifyListeners();
  }

  void clearList() {
    devices.clear();
    notifyListeners();
  }
}

//=========================================== Device =========================================
class Device extends ChangeNotifier {
  DeviceType typeEnum;
  String type;
  String name = "";
  String mac;
  String ip;
  String version;
  String MT;
  String serialno;
  List<Device> remoteDevices = <Device>[];
  ui.Image icon;
  Map<String, DataratePair> speeds; //Map<mac address of remote device, datarates to and from this remote device>
  //ToDo bool AttatchedToRouter get from XML

  Device(String type, String name, String mac, String ip, String MT, String serialno, String version, [ui.Image icon]) {
    this.typeEnum = getDeviceType(type);
    this.type = type;
    this.name = name;
    this.mac = mac;
    this.ip = ip;
    this.MT = MT; // product
    this.serialno = serialno;
    this.version = version;
    this.remoteDevices = remoteDevices;
    if (areDeviceIconsLoaded)
      this.icon = getIconForDeviceType(getDeviceType(type)); // areDeviceIconsLoaded ??
    //if (icon != null) this.icon = icon;
    this.speeds = new Map();
  }

  factory Device.fromXML(XmlElement element) {
    Device retDevice = Device(
      element.getElement('type').text,
      element.getElement('name').text,
      element.getElement('macAddress').text,
      element.getElement('ipAddress').text,
      element.getElement('product').text,
      element.getElement('serialno').text,
      element.getElement('version').text,
      //Device.fromXML(Element.getElement('remotes').getElement('item')),
      //genreElement.findElements('genre').map<Genre>((e) => Genre.fromElement(e)).toList(),
    );

    if (element.getElement('remotes') != null) {
      List<XmlNode> remotes = element.getElement('remotes').children;
      remotes = testList(remotes, 'type'); // Checking where items are devices returning the trimmed list
      // print(remotes.length);
      for (var remote in remotes) {
        print('Remote Device found: ' + remote.getElement('type').text);
        retDevice.remoteDevices.add(Device.fromXML(remote));
      }
    }

    if (element.getElement('dataRates') != null) {
      List<XmlNode> dataRates = element.getElement('dataRates').children;
      dataRates = testList(dataRates, 'macAddress');
      //print(dataRates);
      for (var item in dataRates) {
        var txMac = item.getElement('first').getElement('first').getElement('macAddress').text;
        var rxMac = item.getElement('first').getElement('second').getElement('macAddress').text;
        //print(txMac + " " + rxMac);
        var txRateStr = item.getElement('second').getElement('txRate').text;
        var rxRateStr = item.getElement('second').getElement('rxRate').text;
        //print(txRateStr + " " + rxRateStr);

        int txRate = 0, rxRate = 0;
        if (txRateStr.contains("."))
          txRate = double.parse(txRateStr).round();
        else
          txRate = int.parse(txRateStr);
        if (rxRateStr.contains("."))
          rxRate = double.parse(rxRateStr).round();
        else
          rxRate = int.parse(rxRateStr);

        if (retDevice.mac.compareTo(txMac) == 0) {
          retDevice.speeds[rxMac] = new DataratePair(txRate, rxRate);
          print(retDevice.name + " Rates added for " + txMac + " to " + rxMac + ": " + retDevice.speeds[rxMac].rx.toString() + ", " + retDevice.speeds[rxMac].tx.toString());
        }
        for (var remoteDevice in retDevice.remoteDevices) {
          if (remoteDevice.mac.compareTo(txMac) == 0) {
            remoteDevice.speeds[rxMac] = new DataratePair(txRate, rxRate);
            print(remoteDevice.name+ " Rates added for " + txMac + " to " + rxMac + ": " + remoteDevice.speeds[rxMac].rx.toString() + ", " + remoteDevice.speeds[rxMac].tx.toString());
          }
        }
      }
    }
    return retDevice;

  }
}
//=========================================== END Device =========================================

// Tests if XmlNode remotes contains Information about a Device
List<XmlNode> testList(List<XmlNode> remotes, String searchString) {
  List<XmlNode> deviceItems = <XmlNode>[];
  for (XmlNode remote in remotes) {
    if (remote.findAllElements(searchString).isNotEmpty) {
      deviceItems.add(remote);
    }
  }
  return deviceItems;
}
