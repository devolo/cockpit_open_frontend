/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:xml/xml.dart';

bool connected = false;

Map<String,dynamic> config = {
  "ignore_updates": false,
  "allow_data_collection": false,
  "windows_network_throttling_disabled":true,
  "internet_centered": true,
  "show_other_devices": true,
  "show_speeds_permanent": false,
  "theme": theme_devolo["name"],
  "previous_theme": theme_devolo["name"],
  "language": "",
  "font_size_factor": fontSizeFactor,
  "selected_network": 0,
};

List<XmlNode> findElements(List<XmlNode> xmlNodes, String searchString) {
  List<XmlNode> deviceItems = <XmlNode>[];
  for (XmlNode xmlNodeElement in xmlNodes) {
    if (xmlNodeElement.findAllElements(searchString).isNotEmpty) {
      deviceItems.add(xmlNodeElement);
    }
  }
  return deviceItems;
}

void saveToSharedPrefs(Map<String, dynamic> inputMap) async {

  String jsonString = json.encode(inputMap);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('config', jsonString);
}

void launchURL(String ip) async {
  String url = "http://"+ ip;
  print("Opening web UI at " + url);

  //TODO is it still not working on linux? To be tested
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

void getConnection() async { // get Internet Connection
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      connected = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    connected = false;
  }
}

Future<void> openFile(var path) async {
  final filePath = path;
  await OpenFile.open(filePath);
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