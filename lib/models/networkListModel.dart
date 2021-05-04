/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';


class NetworkList extends ChangeNotifier{
  List<List<Device>> _networkList = [];
  int selectedNetworkIndex = 0;
  List<String> _updateMacs = [];
  bool CockpitUpdate = false;
  List<Device> _devices = [];  //contains all devices

  NetworkList();

  List<Device> getDeviceList(){
    if(_networkList.isEmpty){
      return [];
    }else {
      try {
        return _networkList[selectedNetworkIndex];
      }
      catch(e) {
        print("Error Networks not ready");
      return _networkList[0];}
    }
    //return _devices;
  }

  List<String> getUpdateList(){
    return _updateMacs;
  }

  List<List<Device>> getNetworkList(){
    return _networkList;
  }

  List<Device> getAllDevices(){
    return _devices;
  }

  int getNetworkListLength(){
    int length = 0;
    for(var elem in _networkList){
      if(elem.isNotEmpty){
        length++;
      }
    }
    return length;
    //return _networkList[selectedNetworkIndex].length;
  }

  int getPivotIndex(){
    for(var elem in _networkList[selectedNetworkIndex]){
      if(elem.attachedToRouter==true){
        return _networkList[selectedNetworkIndex].indexOf(elem);
      }
    }
    return 0;
  }

  Device getPivot(){
    try {
      var trying = _networkList[selectedNetworkIndex];
    }catch(error) {
      selectedNetworkIndex = 0;
    }
    for(var dev in _networkList[selectedNetworkIndex]){
      if(dev.attachedToRouter==true){
        return dev;
      }
    }
    return null;
  }

  Device getLocal(){
    for(var dev in _networkList[selectedNetworkIndex]){
      if(dev.isLocalDevice==true){
        return dev;
      }
    }
    return null;
  }

  String getNetworkType(networkIndex){
    String type;
    for(var net in _networkList[networkIndex]){
      if(net.type.contains('Magic')){
        type = "Magic";
        //print("Type: " + type);
        break;
      }
      else if (net.type.contains('dLAN')){
        type = "dLAN";
        //print("Type: " + type);
        break;
      }
      else{
        type = "PLC";
        //print("Type: " + type);
        break;
      }
    }
    return type;
  }

  void setDeviceList(List<Device> devList) {
    _networkList[selectedNetworkIndex] = devList;
    notifyListeners();
  }

  void addDevice(Device device, int whichNetworkIndex) {
    //for multiple localDevices with its own remote devices
    if(!_networkList.asMap().containsKey(whichNetworkIndex)){ // is testing if "whichNetworkIndex" exists in List
      this._networkList.insert(whichNetworkIndex, []);
    }

    if(device.attachedToRouter & config["internet_centered"]){
      this._devices.insert(0, device);
      this._networkList[whichNetworkIndex].insert(0, device);
    }
    else{
      this._devices.add(device);
      this._networkList[whichNetworkIndex].add(device);
    }

    if(_networkList.length == 1){
      //print("NetworkList length: ${_networkList.length}");
      showNetwork = false;
    }
    //notifyListeners();
  }


  void clearList() {
    _networkList[selectedNetworkIndex].clear();
    notifyListeners();
  }

  void clearNetworkList() {
    _networkList.clear();
    notifyListeners();
  }

  void clearDeviceList() {
    _devices.clear();
    notifyListeners();
  }

  void changedList() {
    notifyListeners();
  }


  String toRealString(){
    String ret;
    for(var devlocal in _networkList[selectedNetworkIndex]) {
      ret = "${devlocal.toRealString()} \n";
      for(var devremote in devlocal.remoteDevices){
        ret += "${devremote.toRealString()} \n";
      }
      return ret;
    }
    return null;
  }
}


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
