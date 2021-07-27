/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/
import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

enum DeviceType { dtLanMini, dtLanPlus, dtWiFiMini, dtWiFiPlus, dtWiFiOnly, dtDINrail, dtUnknown }

//=========================================== Device =========================================
class Device extends ChangeNotifier {
  DeviceType? typeEnum;
  String type  = "";
  String networkType  = "";
  String name = "";
  String mac  = "";
  String ip  = "";
  String version  = "";
  String versionDate  = "";
  String MT  = "";
  String serialno  = "";
  List<Device> remoteDevices = <Device>[];
  Map<String, DataratePair>? speeds; //Map<mac address of remote device, datarates to and from this remote device>
  bool attachedToRouter = false;
  bool isLocalDevice = false;
  String updateState = "0";
  bool webinterfaceAvailable = false;
  bool identifyDeviceAvailable = false;
  String selectedVDSL = "";
  List<String> supportedVDSL = [];
  String modeVDSL  = "";
  List<int> disableLeds = List.filled(2, 0); // first value indicates if the action is available for the device, second shows the value
  List<int> disableStandby = List.filled(2, 0); // first value indicates if the action is available for the device, second shows the value
  List<int> disableTraffic = List.filled(2, 0); // first value indicates if the action is available for the device, second shows the value


  Device(String type, String networkType, String name, String mac, String ip, String MT, String serialno, String version, String versionDate, atRouter, isLocal, bool webinterfaceAvailable, bool identifyDeviceAvailable, selectedVDSL, supportedVDSL, modeVDSL, List<int> disableLeds, List<int> disableStandby, List<int> disableTraffic) {
    this.typeEnum = getDeviceType(type);
    this.type = type;
    this.networkType = networkType;
    this.name = name;
    this.mac = mac;
    this.ip = ip;
    this.MT = MT; // product
    this.serialno = serialno;
    this.attachedToRouter = atRouter;
    this.isLocalDevice = isLocal;
    this.webinterfaceAvailable = webinterfaceAvailable;
    this.identifyDeviceAvailable = identifyDeviceAvailable;
    this.selectedVDSL = selectedVDSL;
    this.supportedVDSL = supportedVDSL;
    this.modeVDSL = modeVDSL;
    this.disableLeds = disableLeds;
    this.disableStandby = disableStandby;
    this.disableTraffic = disableTraffic;

    if(version.contains("_")) {
      this.version = version.substring(0,version.indexOf("_"));
      this.versionDate = version.substring(version.indexOf("_")+1);
    }
    else {
      this.version = version;
      this.versionDate = versionDate;
    }

    this.speeds = new Map();

  }

  factory Device.fromXML(XmlElement element, bool islocalDevice) {

    // get attribute if device is attached to the router
    bool attachedToRouter = false;
    String networkType = "";

    var states=element.getElement('states');
    if(states != null){
      var firstList = states.findAllElements('first');
      for(var first in firstList){
        if(first.innerText.contains("gateway"))
          attachedToRouter = true;
       if(first.innerText.contains("network_type")){
          networkType = first.parent!.getElement('second')!.innerText;
        }
      }
    }

    bool webinterfaceAvailable = false;
    bool identifyDeviceAvailable = false;
    List<int> disable_leds = List.filled(2, 0); // first value indicates if the action is available for the device, second shows the value
    List<int> disable_standby = List.filled(2, 0); // first value indicates if the action is available for the device, second shows the value
    List<int> disable_traffic = List.filled(2, 0); // first value indicates if the action is available for the device, second shows the value

    if (element.getElement('actions') != null) {

      var firstList = element.getElement('actions')!.findAllElements('first');
      for(var first in firstList){
        if(first.innerText == "identify_device"){
          identifyDeviceAvailable = true;
        }
        else if(first.innerText == "web_interface"){
          webinterfaceAvailable = true;
        }
        else if(first.innerText == "disable_leds"){
          var disableLedsStatus = first.parentElement!.findAllElements("item").first.findElements("second").first.innerText;
          disable_leds = [1,int.parse(disableLedsStatus)];
        }
        else if(first.innerText == "disable_standby"){
          var disableStandbyStatus = first.parentElement!.findAllElements("item").first.findElements("second").first.innerText;
          disable_standby = [1,int.parse(disableStandbyStatus)];

        }
        else if(first.innerText == "disable_traffic"){
          var disableTrafficStatus = first.parentElement!.findAllElements("item").first.findElements("second").first.innerText;
          disable_traffic = [1,int.parse(disableTrafficStatus)];
        }
      }
    }

    // get Attribute for VDSL compatibility
    // get attributes for selected and supported vdsl profiles
    XmlElement? vdslCompat;
    var selectedVDSL = "";
    List<String> supportedVDSL = [];
    var modeVDSL = "";

    var actions=element.getElement('actions')!.findAllElements("item").toList();
    if(actions.isNotEmpty) {
      try {
        vdslCompat = actions.firstWhere((element) => element.innerText.contains("supported_profiles"),); //orElse: () {return null;}
      }
      catch(error) {
        //logger.i("Error: ${error}");
        vdslCompat = null;
      }
    }
    if(vdslCompat != null) {
      modeVDSL = vdslCompat.findAllElements("item").toList().firstWhere((element) => element.innerText.contains("mode"),).lastElementChild!.innerText;
      //logger.i(mode_VDSL);
      supportedVDSL = vdslCompat.findAllElements("item").toList().firstWhere((element) => element.innerText.contains("supported_profiles"), ).lastElementChild!.innerText.split(" "); // ToDo is always last element child or <second> ?
      selectedVDSL = vdslCompat.findAllElements("item").toList().firstWhere((element) => element.innerText.contains("selected_profile"), ).lastElementChild!.innerText;
      //logger.i("${element.getElement('name').text}: ${selected_VDSL} , ${supported_VDSL}");
    }

    Device retDevice = Device(
      element.getElement('type')!.text,
      networkType,
      element.getElement('name')!.text,
      element.getElement('macAddress')!.text,
      element.getElement('ipAddress')!.text,
      element.getElement('product')!.text,
      element.getElement('serialno')!.text,
      element.getElement('version')!.text,
      element.getElement('date')!.text,
      attachedToRouter,
      islocalDevice,
      webinterfaceAvailable,
      identifyDeviceAvailable,
      selectedVDSL,
      supportedVDSL,
      modeVDSL,
      disable_leds,
      disable_standby,
      disable_traffic,
    );

    if (element.getElement('remotes') != null) {
      List<XmlNode> remotes = element.getElement('remotes')!.children;
      remotes = findElements(remotes, 'type'); // Checking where items are devices returning the trimmed list
      for (dynamic remote in remotes) {
        //logger.i('Remote Device found: ' + remote.getElement('type').text);
        retDevice.remoteDevices.add(Device.fromXML(remote, false));
      }
    }

    if (element.getElement('dataRates') != null) {
      List<XmlNode> dataRates = element.getElement('dataRates')!.children;
      dataRates = findElements(dataRates, 'macAddress');
      //logger.i(dataRates);
      for (var item in dataRates) {
        var txMac = item.getElement('first')!.getElement('first')!.getElement('macAddress')!.text;
        var rxMac = item.getElement('first')!.getElement('second')!.getElement('macAddress')!.text;
        //logger.i(txMac + " " + rxMac);
        var txRateStr = item.getElement('second')!.getElement('txRate')!.text;
        var rxRateStr = item.getElement('second')!.getElement('rxRate')!.text;
        //logger.i(txRateStr + " " + rxRateStr);

        int txRate = double.parse(txRateStr).round();
        int rxRate = double.parse(rxRateStr).round();

        if (retDevice.mac.compareTo(txMac) == 0) {
          retDevice.speeds![rxMac] = new DataratePair(rxRate, txRate);
          //logger.i(retDevice.name + " Rates added for " + txMac + " to " + rxMac + ": " + retDevice.speeds[rxMac].rx.toString() + ", " + retDevice.speeds[rxMac].tx.toString());
        }
        for (var remoteDevice in retDevice.remoteDevices) {
          if (remoteDevice.mac.compareTo(txMac) == 0) {
            remoteDevice.speeds![rxMac] = new DataratePair(rxRate, txRate);
            //logger.i(remoteDevice.name+ " Rates added for " + txMac + " to " + rxMac + ": " + remoteDevice.speeds[rxMac].rx.toString() + ", " + remoteDevice.speeds[rxMac].tx.toString());
          }
        }
      }
    }
    return retDevice;
  }

  String toRealString(){
    return '''Name: ${this.name},
 type: ${this.type},
 typeEnum: ${this.typeEnum},
 networkType: ${this.networkType},
 mac: ${this.mac},
 ip: ${this.ip},
 version: ${this.version},
 version_date: ${this.versionDate},
 MT: ${this.MT},
 serialno: ${this.serialno},
 remoteDevices: ${this.remoteDevices},
 speeds: ${this.speeds},
 attachedToRouter: ${this.attachedToRouter},
 isLocalDevice: ${this.isLocalDevice},
 webinterfaceAvailable: ${this.webinterfaceAvailable},
 identifyDeviceAvailable: ${this.identifyDeviceAvailable},
 UpdateStatus: ${this.updateState},
 SelectedVDSL: ${this.selectedVDSL},
 SupportedVDSL: ${this.supportedVDSL},
 ModeVDSL: ${this.modeVDSL},
 disable_leds: ${this.disableLeds},
 disable_standby: ${this.disableStandby},
 disable_traffic: ${this.disableTraffic}
''';
  }
}
//=========================================== END Device =========================================