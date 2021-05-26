/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:ui' as ui;
import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:cockpit_devolo/shared/helpers.dart';

enum DeviceType { dtLanMini, dtLanPlus, dtWiFiMini, dtWiFiPlus, dtWiFiOnly, dtDINrail, dtUnknown }

//=========================================== Device =========================================
class Device extends ChangeNotifier {
  DeviceType? typeEnum;
  String type  = "";
  String name = "";
  String mac  = "";
  String ip  = "";
  String version  = "";
  String version_date  = "";
  String MT  = "";
  String serialno  = "";
  List<Device> remoteDevices = <Device>[];
  ui.Image? icon;
  Map<String, DataratePair>? speeds; //Map<mac address of remote device, datarates to and from this remote device>
  bool attachedToRouter = false;
  bool isLocalDevice = false;
  bool updateAvailable = false;
  String updateState = "";
  double updateStateInt = 0;
  bool webinterfaceAvailable = false;
  bool identifyDeviceAvailable = false;
  String selected_vdsl = "";
  List<String> supported_vdsl = [];
  String mode_vdsl  = "";


  Device(String type, String name, String mac, String ip, String MT, String serialno, String version, String versionDate, atRouter, isLocal, bool webinterfaceAvailable, bool identifyDeviceAvailable, selectedVDSL, supportedVDSL, modeVDSL, [ui.Image? icon]) {
    this.typeEnum = getDeviceType(type);
    this.type = type;
    this.name = name;
    this.mac = mac;
    this.ip = ip;
    this.MT = MT; // product
    this.serialno = serialno;
    this.attachedToRouter = atRouter;
    this.isLocalDevice = isLocal;
    this.webinterfaceAvailable = webinterfaceAvailable;
    this.identifyDeviceAvailable = identifyDeviceAvailable;
    this.selected_vdsl = selectedVDSL;
    this.supported_vdsl = supportedVDSL;
    this.mode_vdsl = modeVDSL;


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

    // get attribute if device is attached to the router
    bool attachedToRouter = false;
    var gatewayStates=element.getElement('states');
    if(gatewayStates != null){
      for(var elem in gatewayStates.children){
        if(elem.innerText.contains("gateway"))
          attachedToRouter = true;
      }
    }

    bool webinterfaceAvailable = false;
    bool identifyDeviceAvailable = false;

    if (element.getElement('actions') != null) {

      var firstList = element.getElement('actions')!.findAllElements('first');
      for(var first in firstList){
        if(first.innerText == "identify_device"){
          identifyDeviceAvailable = true;
        }
        else if(first.innerText == "web_interface"){
          webinterfaceAvailable = true;
        }
      }
    }

    // get Attribute for VDSL compatibility
    // get attributes for selected and supported vdsl profiles
    XmlElement? vdsl_compat;
    var selected_VDSL = "";
    List<String> supported_VDSL = [];
    var mode_VDSL = "";

    var actions=element.getElement('actions')!.findAllElements("item").toList();
    if(actions.isNotEmpty) {
      try {
        vdsl_compat = actions.firstWhere((element) => element.innerText.contains("supported_profiles"),); //orElse: () {return null;}
      }
      catch(error) {
        print("Error: ${error}");
        vdsl_compat = null;
      }
    }
    if(vdsl_compat != null) {
      mode_VDSL = vdsl_compat.findAllElements("item").toList().firstWhere((element) => element.innerText.contains("mode"),).lastElementChild!.innerText;
      print(mode_VDSL);
      supported_VDSL = vdsl_compat.findAllElements("item").toList().firstWhere((element) => element.innerText.contains("supported_profiles"), ).lastElementChild!.innerText.split(" "); // ToDo is always last element child or <second> ?
      selected_VDSL = vdsl_compat.findAllElements("item").toList().firstWhere((element) => element.innerText.contains("selected_profile"), ).lastElementChild!.innerText;
      //print("${element.getElement('name').text}: ${selected_VDSL} , ${supported_VDSL}");
    }



    Device retDevice = Device(
      element.getElement('type')!.text,
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
      selected_VDSL,
      supported_VDSL,
      mode_VDSL,
      //Device.fromXML(Element.getElement('remotes').getElement('item')),
      //genreElement.findElements('genre').map<Genre>((e) => Genre.fromElement(e)).toList(),
    );

    if (element.getElement('remotes') != null) {
      List<XmlNode> remotes = element.getElement('remotes')!.children;
      remotes = testList(remotes, 'type'); // Checking where items are devices returning the trimmed list
      for (dynamic remote in remotes) {
        //print('Remote Device found: ' + remote.getElement('type').text);
        retDevice.remoteDevices.add(Device.fromXML(remote, false));
      }
    }

    if (element.getElement('dataRates') != null) {
      List<XmlNode> dataRates = element.getElement('dataRates')!.children;
      dataRates = testList(dataRates, 'macAddress');
      //print(dataRates);
      for (var item in dataRates) {
        var txMac = item.getElement('first')!.getElement('first')!.getElement('macAddress')!.text;
        var rxMac = item.getElement('first')!.getElement('second')!.getElement('macAddress')!.text;
        //print(txMac + " " + rxMac);
        var txRateStr = item.getElement('second')!.getElement('txRate')!.text;
        var rxRateStr = item.getElement('second')!.getElement('rxRate')!.text;
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
          retDevice.speeds![rxMac] = new DataratePair(rxRate, txRate);
          //print(retDevice.name + " Rates added for " + txMac + " to " + rxMac + ": " + retDevice.speeds[rxMac].rx.toString() + ", " + retDevice.speeds[rxMac].tx.toString());
        }
        for (var remoteDevice in retDevice.remoteDevices) {
          if (remoteDevice.mac.compareTo(txMac) == 0) {
            remoteDevice.speeds![rxMac] = new DataratePair(rxRate, txRate);
            //print(remoteDevice.name+ " Rates added for " + txMac + " to " + rxMac + ": " + remoteDevice.speeds[rxMac].rx.toString() + ", " + remoteDevice.speeds[rxMac].tx.toString());
          }
        }
      }
    }
    return retDevice;
  }

  String toRealString(){
    return "Name: ${this.name},\n type:${this.type},\n mac: ${this.mac},\n ip: ${this.ip},\n version: ${this.version},\n version_date:${this.version_date},\n MT: ${this.MT},\n serialno: ${this.serialno},\n remoteDevices: ${this.remoteDevices},\n icon:${this.icon},\n speeds: ${this.speeds},\n attachedToRouter: ${this.attachedToRouter},\n isLocalDevice: ${this.isLocalDevice},\n UpdateAvailable: ${this.updateAvailable},\n UpdateStatus: ${this.updateState},\n UpdateStatusInt: ${this.updateStateInt}, \n SelectedVDSL: ${this.selected_vdsl}, \n SupportedVDSL: ${this.supported_vdsl} \n";
  }
}
//=========================================== END Device =========================================