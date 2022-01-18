/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cockpit_devolo/logging/log_printer.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:xml/xml.dart';
import 'package:logger/logger.dart';

import 'globals.dart';

bool connected = false;

Map<String,dynamic> config = {
  "ignore_updates": false,
  "allow_data_collection": false,
  "windows_network_throttling_disabled":true,
  "show_other_devices": true,
  "show_speeds_permanent": false,
  "theme": theme_light["name"],
  "previous_theme": theme_light["name"],
  "language": "",
  "font_size_factor": 1.0,
  "icon_size_factor": 1.0,
  "selected_network": 0,
  "window_height": 720.0,
  "window_width":1280.0,
  "fullscreen": false,
};

var logger = Logger(
  printer: SimpleLogPrinter()
);

List<XmlNode> findElements(List<XmlNode> xmlNodes, String searchString) {
  List<XmlNode> deviceItems = <XmlNode>[];
  for (XmlNode xmlNodeElement in xmlNodes) {
    if (xmlNodeElement.findAllElements(searchString).isNotEmpty) {
      deviceItems.add(xmlNodeElement);
    }
  }
  return deviceItems;
}

// TODO try to use package_info_plus once the version in the pubspec.yaml is supported by all platforms
Future<void> getVersions() async {
  String fileData = await rootBundle.loadString('assets/version.txt');

  int startIndex = 0;
  if(fileData.contains("versionCockpit")){
    versionCockpit = fileData.substring(fileData.indexOf("=",startIndex)+2,fileData.indexOf(";",startIndex));
    startIndex = fileData.indexOf("buildNumberCockpit");
    buildNumberCockpit = fileData.substring(fileData.indexOf("=",startIndex)+2,fileData.indexOf(";",startIndex));
    startIndex = fileData.indexOf("dateCockpit");
    dateCockpit = fileData.substring(fileData.indexOf("=",startIndex)+2,fileData.indexOf(";",startIndex));
    startIndex = fileData.indexOf("versionLetterCockpit");
    versionLetterCockpit = fileData.substring(fileData.indexOf("=",startIndex)+2,fileData.indexOf(";",startIndex));
  }
}

String getVersionSyntax(){
  String version = "";
  if(versionCockpit != "")
    version += versionCockpit;

  if(buildNumberCockpit != "")
    version += "." + buildNumberCockpit;

  if(versionLetterCockpit != "")
    version += versionLetterCockpit;

  if(dateCockpit != "")
    version += " (" + dateCockpit + ")";

  return version;
}

void saveToSharedPrefs(Map<String, dynamic> inputMap) async {

  String jsonString = json.encode(inputMap);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('config', jsonString);
}

void launchURL(String ip) async {
  String url = "http://"+ ip;
  logger.d("Opening web UI at " + url);

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
    logger.d('not connected');
    connected = false;
  }
}

Future<void> openFile(var path) async {
  final filePath = path;
  await OpenFile.open(filePath);
}

DeviceType getDeviceType(String deviceType){
  DeviceType dt;

  if(deviceType.toLowerCase().contains("repeater")){
    return DeviceType.dtRepeater;
  }
  else if (deviceType.toLowerCase().contains("wifi")) {
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

String? getPathForLanguage(String language){
  if(language == "de")
    return  "assets/flagImages/devolo_DE.png";

  else if(language == "fr")
    return  "assets/flagImages/devolo_FR.png";

  else if(language == "gb" || language == "en")
    return  "assets/flagImages/devolo_UK.png";
}

Future saveWindowSize() async {

  Size size = await DesktopWindow.getWindowSize();
  bool fullscreen = await DesktopWindow.getFullScreen();

  if(size.height == 0.0 || size.width == 0.0)
    return;


  if(fullscreen != config["fullscreen"]) {
    logger.d("Saving window fullscreen...");
    config["fullscreen"] = fullscreen;
    saveToSharedPrefs(config);
    return;
  }
  else if(!fullscreen && (size.height != config["window_height"] || size.width != config["window_width"])) {
    logger.d("Saving window size...");
    config["window_height"] = size.height;
    config["window_width"] = size.width;
    saveToSharedPrefs(config);
  }
}

String getDevoloWebsiteLink() {
    return "https://www.devolo.global";
}
