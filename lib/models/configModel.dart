// import 'package:flutter/material.dart';
//
// // Not Used yet!
// class ConfigModel {
//   static final ConfigModel _configModel = ConfigModel._internal();
//
//   factory ConfigModel() {
//     return _configModel;
//   }
//
//   ConfigModel._internal() {
//     this.theme = theme_dark;
//     this.mainColor =Colors.grey[850]; //Colors.blue[700]; // Colors.grey[850];
//     this.backgroundColor = Colors.grey[850];//Colors.blue[700]; //
//     this.secondColor = Colors.grey[400];//Colors.blue[100];
//     this.drawingColor = Colors.white;
//     this.fontColorLight = Colors.white;
//     this.fontColorMedium = Colors.grey[800];
//     this.fontColorDark = Colors.black;
//   }
//
//   // ConfigModel() {
//   //   this.theme = theme_dark;
//   //   this.mainColor =Colors.grey[850]; //Colors.blue[700]; // Colors.grey[850];
//   //   this.backgroundColor = Colors.grey[850];//Colors.blue[700]; //
//   //   this.secondColor = Colors.grey[400];//Colors.blue[100];
//   //   this.drawingColor = Colors.white;
//   //   this.fontColorLight = Colors.white;
//   //   this.fontColorMedium = Colors.grey[800];
//   //   this.fontColorDark = Colors.black;
//   // }
//
//   // Color mainColor =Colors.grey[850]; //Colors.blue[700]; // Colors.grey[850];
//   // Color backgroundColor = Colors.grey[850];//Colors.blue[700]; //
//   // Color secondColor = Colors.grey[400];//Colors.blue[100];
//   // Color drawingColor = Colors.white;
//   // Color fontColorLight = Colors.white;
//   // Color fontColorMedium = Colors.grey[800];
//   // Color fontColorDark = Colors.black;
//
//   double fontSizeFactor = 1.0;
//   double fontSizeDelta = 3.0;
//
//   bool ignore_updates = false;
//   bool allow_data_collection = false;
//   bool windows_network_throttling_disabled = true;
//   bool internet_centered = true;
//   bool show_other_devices = true;
//   bool show_speeds_permanent = false;
//   bool show_speeds = false;
//   bool high_contrast = false;
//   Map<String, dynamic> theme;
//   Map<String, dynamic> previous_theme;
//   String language =  "";
//
//   //short getter for my variable
//   Color get drawingColor => drawingColor;
//   Color get mainColor => mainColor;
//   Color get backgroundColor => backgroundColor;
//   Color get secondColor => secondColor;
//   Color get fontColorLight => fontColorLight;
//   Color get fontColorMedium => fontColorMedium;
//   Color get fontColorDark => fontColorDark;
//
//   //short setter for my variable
//   set drawingColor(Color value) => drawingColor = value;
//   set mainColor(Color value) => mainColor = value;
//   set backgroundColor(Color value) => backgroundColor = value;
//   set secondColor(Color value) => secondColor = value;
//   set fontColorLight(Color value) => fontColorLight = value;
//   set fontColorMedium(Color value) => fontColorMedium = value;
//   set fontColorDark(Color value) => fontColorDark = value;
//
//
//
//   Map<String, dynamic> theme_dark = {
//     "name": "DarkTheme",
//     "mainColor" : Colors.grey[850], //Colors.blue[700]; // Colors.grey[850];
//     "backgroundColor" : Colors.grey[850], //Colors.blue[700]; //
//     "secondColor" : Colors.grey[400], //Colors.blue[100];
//     "drawingColor" : Colors.white,
//     "fontColorLight" : Colors.white,
//     "fontColorMedium" : Colors.grey[800],
//     "fontColorDark" : Colors.black,
//   };
//
//   Map<String, dynamic> theme_devolo = {
//     "name": "Standart",
//     "mainColor" : Colors.blue[700],
//     "backgroundColor" : Colors.blue[700],
//     "secondColor" : Colors.blue[100],
//     "drawingColor" : Colors.white,
//     "fontColorLight" : Colors.white,
//     "fontColorMedium" : Colors.grey[800],
//     "fontColorDark" : Colors.black,
//   };
//
//   Map<String, dynamic> theme_highContrast = {
//     "name": "High Contrast",
//     "mainColor" : Colors.black,
//     "backgroundColor" : Colors.black,
//     "secondColor" : Colors.white,
//     "drawingColor" : Colors.white,
//     "fontColorLight" : Colors.yellowAccent,
//     "fontColorMedium" : Colors.black,
//     "fontColorDark" : Colors.black,
//   };
//
//   Map<String, dynamic> theme_light = {
//     "name": "Light Theme",
//     "mainColor" : Colors.white54,
//     "backgroundColor" : Colors.white54,
//     "secondColor" : Colors.white,
//     "drawingColor" : Colors.white,
//     "fontColorLight" : Colors.black,
//     "fontColorMedium" : Colors.grey[800],
//     "fontColorDark" : Colors.black,
//   };
//
//   Map<String,dynamic> config = {
//     "ignore_updates": false,
//     "allow_data_collection": false,
//     "windows_network_throttling_disabled":true,
//     "internet_centered": true,
//     "show_other_devices": true,
//     "show_speeds_permanent": false,
//     "show_speeds": false,
//     "high_contrast": false,
//     "language": ""
//   };
//
//
//   void setTheme(Map<String,dynamic> theme) {
//     print(theme);
//     this.mainColor = theme["mainColor"];
//     this.backgroundColor = theme["backgroundColor"];
//     this.secondColor = theme["secondColor"];
//     this.drawingColor = theme["drawingColor"];
//     this.fontColorLight = theme["fontColorLight"];
//     this.fontColorMedium = theme["fontColorMedium"];
//     this.fontColorDark = theme["fontColorDark"];
//
//   }
//
//
//
// }
