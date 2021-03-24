import 'package:cockpit_devolo/views/appBuilder.dart';
import 'package:flutter/material.dart';

Color mainColor;// = Colors.grey[850]; //Colors.blue[700]; // Colors.grey[850];
Color backgroundColor;// = Colors.grey[850];//Colors.blue[700]; //
Color secondColor;// = Colors.grey[400];//Colors.blue[100];
Color drawingColor;// = Colors.white;
Color fontColorLight;// = Colors.white;
Color fontColorMedium;// = Colors.grey[800];
Color fontColorDark;// = Colors.black;

double fontSizeFactor = 1.0;
double fontSizeDelta = 3.0;

var theme_list = [theme_dark, theme_devolo, theme_light, theme_highContrast];


Map<String,dynamic> config = {
  "ignore_updates": false,
  "allow_data_collection": false,
  "windows_network_throttling_disabled":true,
  "internet_centered": true,
  "show_other_devices": true,
  "show_speeds_permanent": false,
  "show_speeds": false,
  "high_contrast": false,
  "theme": theme_dark["name"],
  "previous_theme": theme_dark["name"],
  "language": "",
  "font_size_factor": fontSizeFactor,
};

//void setTheme(Map<String,dynamic> theme) {
void setTheme(String theme_name) {
  dynamic theme;
  print("Set Theme Name: " + theme_name);
  for(var elem in theme_list) {
    if(elem["name"] == theme_name) {
      theme = elem;
    }
  }
  mainColor = theme["mainColor"];
  backgroundColor = theme["backgroundColor"];
  secondColor = theme["secondColor"];
  drawingColor = theme["drawingColor"];
  fontColorLight = theme["fontColorLight"];
  fontColorMedium = theme["fontColorMedium"];
  fontColorDark = theme["fontColorDark"];

}

Map<String, dynamic> theme_dark = {
  "name": "Dark Theme",
  "mainColor" : Colors.grey[850], //Colors.blue[700]; // Colors.grey[850];
  "backgroundColor" : Colors.grey[850], //Colors.blue[700]; //
  "secondColor" : Colors.grey[400], //Colors.blue[100];
  "drawingColor" : Colors.white,
  "fontColorLight" : Colors.white,
  "fontColorMedium" : Colors.grey[800],
  "fontColorDark" : Colors.black,
};


Map<String, dynamic> theme_devolo = {
  "name": "Standard",
  "mainColor" : Colors.blue[700],
  "backgroundColor" : Colors.blue[700],
  "secondColor" : Colors.blue[100],
  "drawingColor" : Colors.white,
  "fontColorLight" : Colors.white,
  "fontColorMedium" : Colors.grey[800],
  "fontColorDark" : Colors.black,
};

Map<String, dynamic> theme_highContrast = {
  "name": "High Contrast",
  "mainColor" : Colors.black,
  "backgroundColor" : Colors.black,
  "secondColor" : Colors.white,
  "drawingColor" : Colors.white,
  "fontColorLight" : Colors.yellowAccent,
  "fontColorMedium" : Colors.black,
  "fontColorDark" : Colors.black,
};

Map<String, dynamic> theme_light = {
  "name": "Light Theme",
  "mainColor" : Colors.white,
  "backgroundColor" : Colors.white,
  "secondColor" : Colors.grey[300],
  "drawingColor" : Colors.grey,
  "fontColorLight" : Colors.black,
  "fontColorMedium" : Colors.grey[800],
  "fontColorDark" : Colors.black,
};

