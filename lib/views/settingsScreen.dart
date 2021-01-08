import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import '../shared/helpers.dart';
import '../services/handleSocket.dart';
import '../services/DrawOverview.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title, this.painter}) : super(key: key);

  final String title;
  DrawNetworkOverview painter;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //DrawNetworkOverview painter;


  // void toggleCheckbox(bool value) async {
  //   setState(() {
  //     widget.painter.showingSpeeds = value;
  //     print(widget.painter.showingSpeeds);
  //
  //     if (widget.painter.showingSpeeds == false) {
  //       widget.painter.showingSpeeds = false;
  //       widget.painter.pivotDeviceIndex = 0;
  //     }
  //   });
  // }

  void toggleCheckbox(bool value)  {
    setState(() {
      widget.painter.showSpeedsPermanently = value;
      print(value);

      if (widget.painter.showSpeedsPermanently) {
        widget.painter.showingSpeeds = true;
        widget.painter.pivotDeviceIndex = 0;
      }
      else{
        widget.painter.showingSpeeds = false;
        widget.painter.pivotDeviceIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        backgroundColor: devoloBlue,
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Checkbox(
                    value: widget.painter.showSpeedsPermanently,
                    onChanged: toggleCheckbox,
                  ),
                  new Text("Enable Showing Speeds"),
                ]),
             Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Checkbox(
                    value: widget.painter.showingSpeeds, //ToDo
                    onChanged: toggleCheckbox,
                  ),
                  new Text("Übertragungsleistung der Geräte Aaufzeichnen und an devolo übermitteln"),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Checkbox(
                  value: widget.painter.showingSpeeds, //ToDo
                  onChanged: toggleCheckbox,
                ),
                  new Text("Alle zukünftigen Updates ignorieren"),

                ])
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}