import 'package:flutter/material.dart';

Color mainColor =Colors.grey[850]; //Colors.blue[700]; // Colors.grey[850];
Color backgroundColor = Colors.grey[850];//Colors.blue[700]; //
Color secondColor = Colors.grey[400];//Colors.blue[100];
Color drawingColor = Colors.white;
Color fontColorLight = Colors.white;
Color fontColorMedium = Colors.grey[800];
Color fontColorDark = Colors.black;

double fontSizeFactor = 1.0;
double fontSizeDelta = 3.0;

Map<String, dynamic> theme_dark = {
  "name": "DarkTheme",
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

