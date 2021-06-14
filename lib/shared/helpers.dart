/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter/material.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:xml/xml.dart';


final List<ui.Image> deviceIconList = <ui.Image>[]; //ToDo put somewhere else
final List<Offset> deviceIconOffsetList = <Offset>[];
List<Offset> networkOffsetList = [];
bool areDeviceIconsLoaded = false;
bool showNetwork = true;
String _openResult = 'Unknown';

List<XmlNode> findElements(List<XmlNode> remotes, String searchString) {
  List<XmlNode> deviceItems = <XmlNode>[];
  for (XmlNode remote in remotes) {
    if (remote.findAllElements(searchString).isNotEmpty) {
      deviceItems.add(remote);
    }
  }
  return deviceItems;
}

void saveToSharedPrefs(Map<String, dynamic> inputMap) async {

  String jsonString = json.encode(inputMap);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('config', jsonString);
}

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

launchURL(String ip) async {
  String url = "http://"+ ip;
  print("Opening web UI at " + url);

  if (Platform.isFuchsia || Platform.isLinux)
    print("Would now have opened the Web-Interface at " +
        url +
        ", but we are experimental on the current platform. :-/");
  else
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
}

bool connected = false;
void getConnection() async { // get Internet Connection
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //print('connected');
      connected = true;
      //return true;
      //return Future.value(true);
    }
  } on SocketException catch (_) {
    print('not connected');
    connected = false;
    //return false;
    //return Future.value(false);
  }
}


// bool getConnection()  { // get Internet Connection
//   try {
//     InternetAddress.lookup('google.com').then((result) {
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         print('connected');
//         connected = true;
//         //return true;
//       }
//     });
//   } on SocketException {
//     print('not connected');
//     connected = false;
//     //return false;
//   }
// }

Future<void> openFile(var path) async {
  final filePath = path;
  //final filePath = "C:/Program Files (x86)\\devolo\\dlan\\updates\\manuals\\magic-2-lan\\manual-de.pdf";
  final result = await OpenFile.open(filePath);
  _openResult = "type=${result.type}  message=${result.message}";
}

DeviceType getDeviceType(String deviceType){
  DeviceType dt;
  if (deviceType.toLowerCase().contains("wifi")) {
    if (deviceType.toLowerCase().contains("plus") ||
        deviceType.toLowerCase().contains("+")) {
      dt = DeviceType.dtWiFiPlus;
    }
    else if(deviceType.toLowerCase().contains("magic") ){ // Different Icon? else move the condition up
      dt = DeviceType.dtWiFiPlus;
    }
    else {
      dt = DeviceType.dtWiFiMini;
    }
  } else {
    if (deviceType.toLowerCase().contains("plus") ||
        deviceType.toLowerCase().contains("+")) {
      dt = DeviceType.dtLanPlus;
    }
    else if(deviceType.toLowerCase().contains("dinrail") ){
      dt = DeviceType.dtDINrail;
    }
    else if(deviceType.toLowerCase().contains("magic") ){ // Different Icon? else move the condition up
      dt = DeviceType.dtLanPlus;
    }
    else {
      dt = DeviceType.dtLanMini;
    }
  }
  return dt;
}

//======================================= Helper for Images ==============================

Future<void> loadAllDeviceIcons() async {
  ByteData data;

  data = await rootBundle.load('assets/eu_wifi_icon.png');
  ui.Image image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/eu_lan_icon_small.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/mini_wifi_icon.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/mini_lan_icon.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/dinrail_icon_small.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

  data = await rootBundle.load('assets/network.png');
  image = await loadImage(new Uint8List.view(data.buffer));
  deviceIconList.add(image);

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
      case DeviceType.dtDINrail:
      {
        return deviceIconList.elementAt(4);
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


getCloseButton(context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
    child: GestureDetector(
      onTap: () {

      },
      child: Container(
        alignment: FractionalOffset.topRight,
        child: GestureDetector(child: Icon(Icons.clear,color: secondColor,),

          onTap: (){
            Navigator.pop(context);
          },),
      ),
    ),
  );
}