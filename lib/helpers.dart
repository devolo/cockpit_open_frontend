import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'deviceClass.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;

final List<ui.Image> deviceIconList = new List(); //ToDo put somewhere else
bool areDeviceIconsLoaded = false;

String macToCanonical(String mac) {
  if (mac != null)
    return mac
        .replaceAll(":", "")
        .replaceAll(":", "")
        .replaceAll(".", "")
        .replaceAll("-", "")
        .toLowerCase();
  else
    return "";
}

DeviceType getDeviceType(String deviceType){
  DeviceType dt;
  if (deviceType.toLowerCase().contains("wifi")) {
    if (deviceType.toLowerCase().contains("plus") ||
        deviceType.toLowerCase().contains("+")) {
      dt = DeviceType.dtWiFiPlus;
    } else {
      dt = DeviceType.dtWiFiMini;
    }
  } else {
    if (deviceType.toLowerCase().contains("plus") ||
        deviceType.toLowerCase().contains("+")) {
      dt = DeviceType.dtLanPlus;
    } else {
      dt = DeviceType.dtLanMini;
    }
  }
  return dt;
}

//======================================= Helper for Images ==============================

Future<Null> loadAllDeviceIcons() async {
  ByteData data;

  data = await rootBundle.load('assets/eu_wifi_icon.png');
  ui.Image image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/eu_lan_icon.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/mini_wifi_icon.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/mini_lan_icon.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  areDeviceIconsLoaded = true;
  print('IconList '+ deviceIconList.toString());
  // setState(() {
  //   print("All device icons are loaded.");
  // });
}

Future<ui.Image> loadImage(List<int> img) async {
  final Completer<ui.Image> completer = new Completer();
  ui.decodeImageFromList(img, (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

ui.Image getIconForDeviceType(DeviceType dt) {
  if (!areDeviceIconsLoaded) return null;

  switch (dt) {
    case DeviceType.dtLanMini:
      {
        return deviceIconList.elementAt(3);
      }
    case DeviceType.dtLanPlus:
      {
        return deviceIconList.elementAt(1);
      }
    case DeviceType.dtWiFiMini:
      {
        return deviceIconList.elementAt(2);
      }
    case DeviceType.dtWiFiPlus:
      {
        return deviceIconList.elementAt(0);
      }
    case DeviceType.dtWiFiOnly:
      {
        return deviceIconList.elementAt(2);
      }
    case DeviceType.dtUnknown:
      {
        return deviceIconList.elementAt(3);
      }
    default:
      {
        return deviceIconList.elementAt(3);
      }
  }
}
