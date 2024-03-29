/*
Copyright © 2023, devolo GmbH
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter/foundation.dart';

import 'helpers.dart';

bool compareListOfDeviceList(List<List<Device>> first, List<List<Device>> other){
  if(first.length != other.length){
    return false;
  }

  for(int i = 0; i < first.length; i++){
    if(!compareDeviceList(first[i], other[i])){
      return false;
    }
  }

  return true;
}

bool compareDeviceList(List<Device> first, List<Device> other){
  if(first.length != other.length){
    return false;
  }

  for(int i = 0; i < first.length; i++){
    if(!compareDevice(first[i], other[i])){
      return false;
    }
  }

  return true;
}

bool compareDevice(Device first, Device other){

  if(first.remoteDevices.length == other.remoteDevices.length){
    for(int i = 0; i < first.remoteDevices.length; i++){
      if(!compareDevice(first.remoteDevices[i],other.remoteDevices[i])){
        return false;
      }

    }
  }
  else{
    logger.w("failed: remote Devices length are different");
    return false;
  }

  if(!compareSpeedRates(first.speeds,other.speeds)){
    logger.w("failed compareSpeedRates");
    return false;
  }

  if(

  first.typeEnum == other.typeEnum &&
      first.type == other.type &&
      first.networkType == other.networkType &&
      first.name == other.name &&
      first.mac == other.mac &&
      first.ip == other.ip &&
      first.version == other.version &&
      first.versionDate == other.versionDate &&
      first.MT == other.MT &&
      first.serialno == other.serialno &&
      //List<Device> remoteDevices = <Device>[];
      //Map<String, DataratePair>? speeds; //Map<mac address of remote device, datarates to and from this remote device>
      first.attachedToRouter == other.attachedToRouter &&
      first.isLocalDevice == other.isLocalDevice &&
      first.updateState == other.updateState &&
      first.webinterfaceAvailable == other.webinterfaceAvailable &&
      first.webinterfaceURL== other.webinterfaceURL &&
      first.identifyDeviceAvailable == other.identifyDeviceAvailable &&
      first.selectedVDSL == other.selectedVDSL &&
      listEquals(first.supportedVDSL,other.supportedVDSL) &&
      listEquals(first.disableLeds,other.disableLeds) &&
      listEquals(first.disableTraffic, other.disableTraffic) &&
      listEquals(first.disableStandby,other.disableStandby) &&
      first.ipConfigMac== other.ipConfigMac &&
      first.ipConfigAddress == other.ipConfigAddress &&
      first.ipConfigNetmask == other.ipConfigNetmask &&
      first.incomplete == other.incomplete

  ){
    return true;
  }
  else{
    logger.w("failed compare attributes");
    return false;
  }


}

bool compareNetworkList(NetworkList first, NetworkList other){

  if(first.getNetworkList().length == other.getNetworkList().length){
    for(int i = 0; i < first.getNetworkList().length; i++){
      if(first.getNetworkList()[i].length == other.getNetworkList()[i].length){
        for(int j = 0; j < first.getNetworkList()[i].length; j++){
          if(!compareDevice(first.getNetworkList()[i][j], other.getNetworkList()[i][j])){
            logger.w("failed compareDevice 1");
            return false;
          }
        }
      }
      else{
        logger.w("failed: Networklist length are different");
        return false;
      }
    }
  }
  else{
    return false;
  }

  if(
  first.selectedNetworkIndex == other.selectedNetworkIndex &&
      listEquals(first.getUpdateList(), other.getUpdateList()) &&
      first.cockpitUpdate == other.cockpitUpdate
  ){
    return true;
  }
  else{
    return false;
  }
}

bool compareSpeedRates(Map<String, DataratePair>? rates1, Map<String, DataratePair>? rates2){

  if(rates1 == null && rates2 == null){
    return true;
  }

  else if(rates1 != null && rates2 == null){
    return false;
  }

  else if(rates1 == null && rates2 != null){
    return false;
  }

  if(rates1!.length == rates2!.length){
    var rates1Keys = rates1.keys;

    bool checkKeys = true;
    rates1Keys.forEach((element) {

      if(rates2.containsKey(element)){
        if(!compareDataratePair(rates1[element]!, rates2[element]!))
          checkKeys = false;
      }

      if(!rates2.containsKey(element)){
        checkKeys = false;
      }


    });

    return checkKeys;

  }
  else{
    return false;
  }

}

bool compareDataratePair(DataratePair first, DataratePair other){
  if(
      first.rx == other.rx &&
      first.tx == other.tx
  ){
    return true;
  }
  else
    return false;
}
