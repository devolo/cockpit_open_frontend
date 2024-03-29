/*
Copyright © 2023, devolo GmbH
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
  List<String> _checkedUpdateMacs = [];
  List<String> _privacyWarningMacs = [];
  bool cockpitUpdate = false;
  List<int>pivotDeviceIndexList = [];

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

  List<String> getCheckedUpdateMacs(){
    return _checkedUpdateMacs;
  }

  List<String> getPrivacyWarningMacs(){
    return _privacyWarningMacs;
  }

  void setUpdateList(List<String> updateList, {List<String>? privacyWarningMacs}){

    _updateMacs = [...updateList];
    _checkedUpdateMacs= [...updateList];

    if(privacyWarningMacs != null)
      _privacyWarningMacs = [...privacyWarningMacs];
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

  Device? getLocalDevice([int? selectedNetwork]){
    int index = selectedNetworkIndex;
    if(selectedNetwork != null)
      index = selectedNetwork;

    for(var dev in _networkList[index]){
      if(dev.isLocalDevice==true){
        return dev;
      }
    }
    return null;
  }

  List<Device> getLocalDevices(){

    List<Device> localDevices = [];

    for(var network in _networkList){
      for(var dev in network){
        if(dev.isLocalDevice==true){
          localDevices.add(dev);
        }
      }
    }
    return localDevices;
  }

  void fillNetworkNames(){
    _networkNames.clear();
    String type = "";

    for(int networkIndex = 0; networkIndex < _networkList.length; networkIndex++) {
      for (var device in _networkList[networkIndex]) {
        if (device.type.contains('Magic')) {
          type = "Magic";
          break;
        }
        else if (device.type.contains('dLAN')) {
          type = "dLAN";
          break;
        }
        else if(device.type.contains('Mesh')){
          type = "Mesh";
          break;
        }
        else if(device.type.toLowerCase().contains('repeater')){
          type = "Repeater";
          break;
        }
        else {
          type = "PLC";
          break;
        }
      }

      if(!_networkNames.contains("$type Network")) {
        _networkNames.insert(networkIndex, "$type Network");
      } else {
        var count = _networkNames.where((element) => element.contains(type)).length;
        _networkNames.insert(networkIndex, "$type Network ${count+1}");
      }
    }

    logger.d("Networknames $_networkNames");
  }

  String getNetworkName(networkIndex) {
    if (_networkNames.isNotEmpty)
      return _networkNames.elementAt(networkIndex);
    else
      return "";
  }

  List<String> getNetworkNames() {
    return _networkNames;
  }

  List<String> getNetworkTypes(){
    List<String> networkTypes = [];
    for(var network in _networkList){
      networkTypes.add(network.first.networkType);
    }
    logger.d(networkTypes.toString());
    return networkTypes;
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

    if(device.attachedToRouter){
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



