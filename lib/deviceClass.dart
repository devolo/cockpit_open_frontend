import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'helpers.dart';
import 'package:cockpit_devolo/main.dart';

enum DeviceType { dtLanMini, dtLanPlus, dtWiFiMini, dtWiFiPlus, dtWiFiOnly, dtUnknown }
DeviceList deviceList = DeviceList(); // ToDo Better find another way to share devicelist
final List<ui.Image> deviceIconList = new List(); //ToDo put somewhere else
final List<Offset> deviceIconOffsetList = new List();
bool areDeviceIconsLoaded = false;


class DataratePair {
  DataratePair(int rx, int tx) {
    this.rx = rx;
    this.tx = tx;
  }

  int tx;
  int rx;
}

class DeviceList {
  List<Device> devices = List<Device>();
  List<Offset> _deviceIconOffsetList = new List();

  DeviceList(){
    this.devices = List<Device>();
  }

  void addDevice(Device device){
    this.devices.add(device);
    print(deviceList.devices.toString());
  }

  void clearList(){
    devices.clear();
  }
}

//=========================================== Device =========================================
class Device {
  DeviceType typeEnum;
  String type;
  String name = "";
  String mac;
  String ip;
  String version;
  String MT;
  String serialno;
  List<Device> remoteDevices = List<Device>();
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
    this.icon = getIconForDeviceType(getDeviceType(type));
    // if (icon != null)
    //   this.icon = icon;

    speeds = new Map(); // ToDo Speedsmap implementation
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
      print('Find neasted Remotes');
      List<XmlNode> remotes = element.getElement('remotes').children;
      //print(remotes);
      remotes = testList(remotes); // Checking where items are devices returning the trimmed list
      print(remotes.length);
      for (var remote in remotes) {
        print('Remote add: ' + remote.getElement('type').text);
        retDevice.remoteDevices.add(Device.fromXML(remote));
      }
    }
    deviceList.addDevice(retDevice);
    return retDevice;
  }
}
//=========================================== END Device =========================================


// Tests if XmlNode remotes contains Information about a Device
List<XmlNode> testList(List<XmlNode> remotes) {
  List<XmlNode> deviceItems = List<XmlNode>();
  for (XmlNode remote in remotes) {
    if (remote.findAllElements('type').isNotEmpty) {
      deviceItems.add(remote);
    }
  }
  return deviceItems;
}
