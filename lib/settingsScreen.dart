import 'package:flutter/material.dart';
import 'helpers.dart';
import 'handleSocket.dart';
import 'DrawOverview.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.painter}) : super(key: key);

  DrawNetworkOverview painter;

  @override
  _SettingsScreenState createState() => _SettingsScreenState(painter: painter);
}

class _SettingsScreenState extends State<SettingsScreen> {
  _SettingsScreenState({this.painter});
  DrawNetworkOverview painter;


  void toggleCheckbox(bool value) async {
    setState(() {
      painter.showSpeedsPermanently = value;

      if (!painter.showSpeedsPermanently) {
        painter.showingSpeeds = false;
        painter.pivotDeviceIndex = 0;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("App Settings"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Enable Diagnostic Expert Mode"),
                  new Checkbox(
                    value: painter.showSpeedsPermanently,
                    onChanged: toggleCheckbox,
                  ),
                ])
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}