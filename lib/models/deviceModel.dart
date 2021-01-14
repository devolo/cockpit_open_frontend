import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:cockpit_devolo/shared/helpers.dart';



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
  List<Device> _devices = [];

  DeviceList() {
    //this._devices = _devices;
    //notifyListeners();
  }

  List<Device> getDeviceList(){
      return _devices;
  }

  int getLength(){
    return _devices.length;
  }

  int getPivot(){
    for(var elem in _devices){
      if(elem.attachedToRouter==true){
        return _devices.indexOf(elem);
      }
    }
    return 0;
  }

  void setDeviceList(List<Device> devList) {
    _devices = devList;
    notifyListeners();
  }

  void addDevice(Device device) {
    if(device.attachedToRouter & config["internet_centered"]){this._devices.insert(0, device);}
    else{this._devices.add(device);}
    print(_devices);
    notifyListeners();
  }

  void clearList() {
    _devices.clear();
    notifyListeners();
  }


  String toRealString(){
    for(var elem in _devices) {
      return "${elem.toString()} \n";
    }
    return null;
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
  String version_date;
  String MT;
  String serialno;
  List<Device> remoteDevices = <Device>[];
  ui.Image icon;
  Map<String, DataratePair> speeds; //Map<mac address of remote device, datarates to and from this remote device>
  bool attachedToRouter;

  Device(String type, String name, String mac, String ip, String MT, String serialno, String version, String versionDate, atr, [ui.Image icon]) {
    this.typeEnum = getDeviceType(type);
    this.type = type;
    this.name = name;
    this.mac = mac;
    this.ip = ip;
    this.MT = MT; // product
    this.serialno = serialno;
    this.version = version;
    this.version_date = versionDate;
    this.attachedToRouter = atr;
    //this.remoteDevices = remoteDevices;
    if (areDeviceIconsLoaded)
      this.icon = getIconForDeviceType(getDeviceType(type)); // areDeviceIconsLoaded ??
    //if (icon != null) this.icon = icon;
    this.speeds = new Map();
  }

  factory Device.fromXML(XmlElement element) {
    bool attachedToRouter = false;
    for(var elem in element.getElement('states').children){
      if(elem.innerText.contains("gateway"))
        attachedToRouter = true;
    }

    Device retDevice = Device(
      element.getElement('type').text,
      element.getElement('name').text,
      element.getElement('macAddress').text,
      element.getElement('ipAddress').text,
      element.getElement('product').text,
      element.getElement('serialno').text,
      element.getElement('version').text,
        element.getElement('date').text,
        attachedToRouter,
      //Device.fromXML(Element.getElement('remotes').getElement('item')),
      //genreElement.findElements('genre').map<Genre>((e) => Genre.fromElement(e)).toList(),
    );

    if (element.getElement('remotes') != null) {
      List<XmlNode> remotes = element.getElement('remotes').children;
      remotes = testList(remotes, 'type'); // Checking where items are devices returning the trimmed list
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

  String toRealString(){
      return "Device: {name: ${this.name}, type:${this.type}, mac: ${this.mac},ip: ${this.ip}, version: ${this.version},version_date:${this.version_date}, MT: ${this.MT}, serialno: ${this.serialno},remoteDevices: ${this.remoteDevices}, icon:${this.icon},speeds: ${this.speeds}, attachedToRouter: ${this.attachedToRouter} \n";
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
