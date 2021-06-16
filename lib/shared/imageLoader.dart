/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter/services.dart';

final List<ui.Image> deviceIconList = <ui.Image>[]; //ToDo put somewhere else
final List<String> deviceIconPathList = ["assets/eu_wifi_icon.png","assets/eu_lan_icon_small.png","assets/mini_wifi_icon.png","assets/mini_lan_icon.png",
  "assets/dinrail_icon_small.png","assets/network.png"];

final List<Offset> deviceIconOffsetList = <Offset>[];
List<Offset> networkOffsetList = [];
bool areDeviceIconsLoaded = false;

Future<void> loadAllDeviceIcons() async {
  ByteData data;

  for(var deviceIcon in deviceIconPathList){
   data = await rootBundle.load(deviceIcon);
   ui.Image image = await loadImage(new Uint8List.view(data.buffer));
   deviceIconList.add(image);
  }

  areDeviceIconsLoaded = true;
  print("All device icons are loaded.");

}

List<Image> loadOptimizeImages() {
  List<Image> retList = [];
  Image image = Image.asset('assets/optimisationImages/dLAN200AVmini2_A.png');
  retList.add(image);
  image = Image.asset('assets/optimisationImages/dLAN200AVmini2_B.png');
  retList.add(image);
  image = Image.asset('assets/optimisationImages/dLAN200AVmini2_C.png');
  retList.add(image);
  image = Image.asset('assets/optimisationImages/dLAN200AVplus_A.png');
  retList.add(image);

  print("All Images are loaded.");
  return retList;

}

Future<ui.Image> loadImage(var img) async {
  final Completer<ui.Image> completer = new Completer();
  ui.decodeImageFromList(img, (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

ui.Image? getIconForDeviceType(DeviceType? dt) {
  if(!areDeviceIconsLoaded) { //ToDo
    print("Device Icons are NOT loaded");
    return null;
  }

  if(dt == DeviceType.dtWiFiPlus)
    return deviceIconList.elementAt(0);

  else if(dt == DeviceType.dtLanPlus)
    return deviceIconList.elementAt(1);

  else if(dt == DeviceType.dtWiFiOnly || dt == DeviceType.dtWiFiMini)
    return deviceIconList.elementAt(2);

  else if(dt == DeviceType.dtLanMini || dt == DeviceType.dtUnknown)
    return deviceIconList.elementAt(3);

  else if(dt == DeviceType.dtDINrail)
    return deviceIconList.elementAt(4);

  else
    return deviceIconList.elementAt(3);

}