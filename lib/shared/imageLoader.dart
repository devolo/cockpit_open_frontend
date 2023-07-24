/*
Copyright © 2023, devolo GmbH
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

import 'devolo_icons.dart';
import 'helpers.dart';

final List<Offset> deviceIconOffsetList = <Offset>[];

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

  logger.i("All optimize icons are loaded");
  return retList;

}

Future<ui.Image> loadImage(var img) async {
  final Completer<ui.Image> completer = new Completer();
  ui.decodeImageFromList(img, (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}


IconData getIconForDeviceType(DeviceType? dt){

  if(dt == DeviceType.dtWiFiPlus)
    return DevoloIcons.devolo_icon_ui_adapter_wifi;

  else if(dt == DeviceType.dtLanPlus)
    return DevoloIcons.devolo_icon_ui_adapter_lan;

  else if(dt == DeviceType.dtWiFiOnly || dt == DeviceType.dtWiFiMini)
    return DevoloIcons.devolo_icon_ui_adapter_mini_wifi;

  else if(dt == DeviceType.dtLanMini || dt == DeviceType.dtUnknown)
    return DevoloIcons.devolo_icon_ui_adapter_mini;

  else if(dt == DeviceType.dtDINrail)
    return DevoloIcons.devolo_icon_ui_din_rail;

  else if(dt == DeviceType.dtRepeater)
    return DevoloIcons.devolo_icon_ui_repeater;

  else
    return DevoloIcons.devolo_icon_ui_adapter_mini;
}


IconData getCircledIconForDeviceType(DeviceType? dt){

  if(dt == DeviceType.dtWiFiPlus)
    return DevoloIcons.devolo_icon_ui_adapter_wifi_circled;

  else if(dt == DeviceType.dtLanPlus)
    return DevoloIcons.devolo_icon_ui_adapter_lan_circled;

  else if(dt == DeviceType.dtWiFiOnly || dt == DeviceType.dtWiFiMini)
    return DevoloIcons.devolo_icon_ui_adapter_mini_wifi_circled;

  else if(dt == DeviceType.dtLanMini || dt == DeviceType.dtUnknown)
    return DevoloIcons.devolo_icon_ui_adapter_mini_circled;

  else if(dt == DeviceType.dtDINrail)
    return DevoloIcons.devolo_icon_ui_adapter_dinrail_circled;

  else if(dt == DeviceType.dtRepeater)
    return DevoloIcons.devolo_icon_ui_repeater_circled;

  else
    return DevoloIcons.devolo_icon_ui_adapter_mini_circled;
}


IconData getFilledIconForDeviceType(DeviceType? dt){

  if(dt == DeviceType.dtWiFiPlus)
    return DevoloIcons.devolo_icon_ui_adapter_wifi_filled;

  else if(dt == DeviceType.dtLanPlus)
    return DevoloIcons.devolo_icon_ui_adapter_lan_filled;

  else if(dt == DeviceType.dtWiFiOnly || dt == DeviceType.dtWiFiMini)
    return DevoloIcons.devolo_icon_ui_adapter_mini_wifi_filled;

  else if(dt == DeviceType.dtLanMini || dt == DeviceType.dtUnknown)
    return DevoloIcons.devolo_icon_ui_adapter_mini_filled;

  else if(dt == DeviceType.dtDINrail)
    return DevoloIcons.devolo_icon_ui_adapter_dinrail_filled;

  else if(dt == DeviceType.dtRepeater)
    return DevoloIcons.devolo_icon_ui_repeater_filled;

  else
    return DevoloIcons.devolo_icon_ui_adapter_mini_filled;
}