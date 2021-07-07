/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';


class NetworkList extends ChangeNotifier{
  List<List<Device>> _networkList = [];
  List<String> _networkNames = [];
  int selectedNetworkIndex = 0;
  List<String> _updateMacs = [];
  List<String> checkedUpdateMacs = [];
  bool cockpitUpdate = false;

  NetworkList();

  List<Device> getDeviceList(){
    if(_networkList.isEmpty){
      return [];
    }
    else {
      try {
        return _networkList[selectedNetworkIndex];
      }
      catch(e) {
        logger.w("[getDeviceList] - _networkList[selectedNetworkIndex] not existing");
        return _networkList[0];
      }
    }
  }

  List<String> getUpdateList(){
    return _updateMacs;
  }

  void setUpdateList(List<String> updateList){
    _updateMacs = updateList;
    checkedUpdateMacs = updateList;
  }

  List<List<Device>> getNetworkList(){
    return _networkList;
  }

  List<Device> getAllDevices(){

    List<Device> allDevices = [];
    for(int i = 0; i < _networkList.length; i++){
      for(int j = 0; j < _networkList[i].length; j++){
        allDevices.add(_networkList[i][j]);
      }
    }

    return allDevices;
  }

  List<Device> getAllDevicesFilteredByState(){

    if(_updateMacs.isEmpty){
      return getAllDevices();
    }

    List<Device> filteredDevices = [];
    List<Device> nonFilteredDevices = [];
    for(List<Device> network in _networkList){
      for(Device device in network){
        if(_updateMacs.contains(device.mac))
          filteredDevices.add(device);
        else
          nonFilteredDevices.add(device);
      }
    }

    List<Device> allDevices = filteredDevices + nonFilteredDevices;

    return allDevices;
  }

  int getNetworkListLength(){
    int length = 0;
    for(var elem in _networkList){
      if(elem.isNotEmpty){
        length++;
      }
    }
    return length;
  }

  Device? getPivotDevice(){
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

  Device? getLocalDevice(){
    for(var dev in _networkList[selectedNetworkIndex]){
      if(dev.isLocalDevice==true){
        return dev;
      }
    }
    return null;
  }


  String getNetworkType(networkIndex){
    String type = "";
    bool meshDevice = false;

    for(var device in _networkList[networkIndex]){
      if (device.type.contains('dLAN')){
        type = "dLAN";
        break;
      }
      else if(device.type.contains('Magic')){
        type = "Magic";
      }
      else if(device.type.contains('Mesh')){
        meshDevice = true;
      }
      else{
        type = "PLC";
      }
    }

    // name network "Mesh" if one mesh device exists.
    if(meshDevice)
      type = "Mesh";

    return type;
  }

  void setDeviceList(List<Device> devList) {

    if(!_networkList.asMap().containsKey(selectedNetworkIndex)){
      this._networkList.insert(selectedNetworkIndex, []);
    }
    _networkList[selectedNetworkIndex] = devList;
    notifyListeners();
  }

  void addDevice(Device device, int whichNetworkIndex) {
    //for multiple localDevices with its own remote devices
    if(!_networkList.asMap().containsKey(whichNetworkIndex)){ // is testing if "whichNetworkIndex" exists in List
      this._networkList.insert(whichNetworkIndex, []);
    }

    if(device.attachedToRouter & config["internet_centered"]){
      this._networkList[whichNetworkIndex].insert(0, device);
    }
    else{
      this._networkList[whichNetworkIndex].add(device);
    }
  }

  Device? getDeviceByMac(String mac){

    Device? searchedDevice;

    try {
      searchedDevice = getAllDevices().firstWhere((element) =>
      element.mac == mac, orElse: null);
    } catch(error){
      searchedDevice = null;
    }
    return searchedDevice;
  }

  void clearDeviceList() {
    _networkList[selectedNetworkIndex].clear();
    notifyListeners();
  }

  void clearNetworkList() {
    _networkList.clear();
    notifyListeners();
  }

  void changedList() {
    notifyListeners();
  }

  String networkListToRealString(){

    String ret = "";

    if(_networkList.isEmpty){
      return ret;
    }

    for(int i = 0; i < _networkList.length; i++){
      for(int j = 0; j < _networkList[i].length; j++){
        ret += "${_networkList[i][j].toRealString()} \n";
      }
    }
    return ret;
  }

  String selectedNetworkListToRealString(){

    String ret = "";

    if(!_networkList.asMap().containsKey(selectedNetworkIndex)){
      return ret;
    }

    for(var devlocal in _networkList[selectedNetworkIndex]) {
      ret += "${devlocal.toRealString()} \n";
    }
    return ret;
  }
}



