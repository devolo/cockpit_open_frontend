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

  int getPivotIndex(){
    for(var elem in _devices){
      if(elem.attachedToRouter==true){
        return _devices.indexOf(elem);
      }
    }
    return 0;
  }
  Device getPivot(){
    for(var dev in _devices){
      if(dev.attachedToRouter==true){
        return dev;
      }
    }
    return null;
  }

  void setDeviceList(List<Device> devList) {
    _devices = devList;
    notifyListeners();
  }

  void addDevice(Device device) {
    if(device.attachedToRouter & config["internet_centered"]){this._devices.insert(0, device);}
    else{this._devices.add(device);}
    //print(_devices);
    //notifyListeners();
  }

  void clearList() {
    _devices.clear();
    notifyListeners();
  }

  void changedList() {
    notifyListeners();
  }


  String toRealString(){
    String ret;
    for(var devlocal in _devices) {
      ret = "${devlocal.toRealString()} \n";
      for(var devremote in devlocal.remoteDevices){
        ret += "${devremote.toRealString()} \n";
      }

      return ret;
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
  bool isLocalDevice;
  bool updateAvailable = false;
  String updateState = "";
  double updateStateInt = 0;

  Device(String type, String name, String mac, String ip, String MT, String serialno, String version, String versionDate, atRouter, isLocal,[ui.Image icon]) {
    this.typeEnum = getDeviceType(type);
    this.type = type;
    this.name = name;
    this.mac = mac;
    this.ip = ip;
    this.MT = MT; // product
    this.serialno = serialno;
    this.attachedToRouter = atRouter;
    this.isLocalDevice = isLocal;
    if(version.contains("_")) {
      this.version = version.substring(0,version.indexOf("_"));
      this.version_date = version.substring(version.indexOf("_")+1);
    }
    else {
      this.version = version;
      this.version_date = versionDate;
    }
    //this.remoteDevices = remoteDevices;
    if (areDeviceIconsLoaded)
      this.icon = getIconForDeviceType(getDeviceType(type)); // areDeviceIconsLoaded ??
    //if (icon != null) this.icon = icon;
    this.speeds = new Map();
  }

  factory Device.fromXML(XmlElement element, bool islocalDevice) {
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
      islocalDevice,
      //Device.fromXML(Element.getElement('remotes').getElement('item')),
      //genreElement.findElements('genre').map<Genre>((e) => Genre.fromElement(e)).toList(),
    );

    if (element.getElement('remotes') != null) {
      List<XmlNode> remotes = element.getElement('remotes').children;
      remotes = testList(remotes, 'type'); // Checking where items are devices returning the trimmed list
      for (var remote in remotes) {
        //print('Remote Device found: ' + remote.getElement('type').text);
        retDevice.remoteDevices.add(Device.fromXML(remote, false));
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
          //print(retDevice.name + " Rates added for " + txMac + " to " + rxMac + ": " + retDevice.speeds[rxMac].rx.toString() + ", " + retDevice.speeds[rxMac].tx.toString());
        }
        for (var remoteDevice in retDevice.remoteDevices) {
          if (remoteDevice.mac.compareTo(txMac) == 0) {
            remoteDevice.speeds[rxMac] = new DataratePair(txRate, rxRate);
            //print(remoteDevice.name+ " Rates added for " + txMac + " to " + rxMac + ": " + remoteDevice.speeds[rxMac].rx.toString() + ", " + remoteDevice.speeds[rxMac].tx.toString());
          }
        }
      }
    }
    return retDevice;
  }

  String toRealString(){
      return "Name: ${this.name},\n type:${this.type},\n mac: ${this.mac},\n ip: ${this.ip},\n version: ${this.version},\n version_date:${this.version_date},\n MT: ${this.MT}, serialno: ${this.serialno},\n remoteDevices: ${this.remoteDevices},\n icon:${this.icon},\n speeds: ${this.speeds},\n attachedToRouter: ${this.attachedToRouter},\n isLocalDevice: ${this.isLocalDevice},\n UpdateAvailable: ${this.updateAvailable},\n UpdateStatus: ${this.updateState},\n UpdateStatusInt: ${this.updateStateInt} \n";
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
