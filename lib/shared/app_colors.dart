/*
Copyright © 2023, devolo GmbH
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:flutter/material.dart';

import 'helpers.dart';

Color mainColor= Colors.white; // used for top bar
Color backgroundColor= Colors.white; // used for background + dialog background. Maybe create sperate dialog Color?
Color secondColor= Colors.white; // used mainly for the surfaces in help and settings. Maybe create new color surface?
Color accentColor= Colors.white; // color for every second entry in list
Color drawingColor= Colors.white; // canvas + buttons
Color fontColorOnMain= Colors.white;
Color fontColorOnBackground= Colors.white;
Color fontColorOnSecond= Colors.white ;
Color updateableDevicesColor = Colors.white;
Color disabledColor = Colors.white; //disabled checkboxes in update Screen
// Color surfaceColor= Colors.white;
// Color fontColorOnSurface= Colors.white;
// Color dialogColor= Colors.white;
// Color fontColorOnDialog= Colors.white;

Color devoloBlue = Color.fromARGB(255, 0, 114, 180);
Color devoloMediumBlue = Color.fromARGB(255, 81, 154, 207);
Color devoloLightBlue = Color.fromARGB(255, 177, 203, 232);
Color devoloGray = Color.fromARGB(255, 67, 74, 79);
Color devoloLighterGray = Color.fromARGB(255, 108, 116, 121);
Color devoloLightGray = Color.fromARGB(255, 193, 195, 197);
Color devoloLightGray66 = Color.fromARGB(255, 131, 136, 139);
Color devoloGreen = Color.fromARGB(255, 118, 184, 42);
Color devoloOrange = Color.fromARGB(255, 238, 114, 3);
Color devoloRed = Color.fromARGB(255, 199, 20, 61);

Color buttonDisabledBackground = Color.fromARGB(255,234, 235, 236);
Color buttonDisabledForeground = Color.fromARGB(255,131, 136, 139);
Color buttonDisabledForeground2 = Color.fromARGB(2555,193, 195, 197);

double hoverOpacity = 0.7;
double activeOpacity = 0.33;

var theme_list = [theme_dark, theme_devolo, theme_light, theme_highContrast];

//void setTheme(Map<String,dynamic> theme) {
void setTheme(String theme_name) {
  dynamic theme;
  bool themeExists = false;
  logger.d("Set Theme Name: " + theme_name);
  for(var elem in theme_list) {
    if(elem["name"] == theme_name) {
      theme = elem;
      themeExists = true;
    }
  }

  if(themeExists){
    mainColor = theme["mainColor"];
    backgroundColor = theme["backgroundColor"];
    secondColor = theme["secondColor"];
    accentColor = theme["accentColor"];
    drawingColor = theme["drawingColor"];
    fontColorOnMain = theme["fontColorOnMain"];
    fontColorOnBackground = theme["fontColorOnBackground"];
    fontColorOnSecond = theme["fontColorOnSecond"];
    updateableDevicesColor = theme["updateableDevicesColor"];
    disabledColor = theme["disabledColor"];
  }
}

Map<String, dynamic> theme_dark = {
  "name": "Dark Theme",
  "mainColor" : devoloGray, //devoloGray;
  "backgroundColor" : devoloGray, //devoloGray;
  "secondColor" : Colors.white, //Colors.grey[400];
  "accentColor" : Color.fromARGB(255,131, 136, 139),
  "drawingColor" : Colors.white,
  "fontColorOnMain" : Colors.white,
  "fontColorOnBackground" : Colors.white,
  "fontColorOnSecond" : devoloGray,
  "updateableDevicesColor" : devoloOrange.withOpacity(0.8),
  "disabledColor" : devoloLightGray
};


Map<String, dynamic> theme_devolo = {
  "name": "Standard",
  "mainColor" : devoloBlue,
  "backgroundColor" : devoloBlue,
  "secondColor" : Colors.white,//devoloBlueLight,
  "accentColor" : Color.fromARGB(255,81, 154, 207),
  "drawingColor" : Colors.white,
  "fontColorOnMain" : Colors.white,
  "fontColorOnBackground" : Colors.white,
  "fontColorOnSecond" : devoloGray,
  "updateableDevicesColor" : devoloOrange.withOpacity(0.8),
  "disabledColor" : devoloLightGray66
};

Map<String, dynamic> theme_highContrast = {
  "name": "High Contrast",
  "mainColor" : Colors.black,
  "backgroundColor" : Colors.black,
  "secondColor" : Colors.white,
  "accentColor" : Colors.yellowAccent.withOpacity(0.2),
  "drawingColor" : Colors.yellowAccent,
  "fontColorOnMain" : Colors.yellowAccent,
  "fontColorOnBackground" : Colors.yellowAccent,
  "fontColorOnSecond" : Colors.black,
  "updateableDevicesColor" : devoloOrange.withOpacity(0.7),
  "disabledColor" : devoloLightGray66
};

Map<String, dynamic> theme_light = {
  "name": "Light Theme",
  "mainColor" : devoloBlue,
  "backgroundColor" : Colors.white,
  "secondColor" : Color.fromARGB(255, 234, 235, 236),
  "accentColor" : Color.fromARGB(255, 234, 235, 236),
  "drawingColor" : devoloGray,
  "fontColorOnMain" : Colors.white,
  "fontColorOnBackground" : devoloGray,
  "fontColorOnSecond" : devoloGray,
  "updateableDevicesColor" : devoloOrange,
  "disabledColor" : devoloLightGray66
};

