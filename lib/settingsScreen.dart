import 'package:flutter/material.dart';
import 'helpers.dart';
import 'handleSocket.dart';
import 'DrawOverview.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title, this.painter}) : super(key: key);

  final String title;
  DrawNetworkOverview painter;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //DrawNetworkOverview painter;


  void toggleCheckbox(bool value) async {
    setState(() {
      widget.painter.showingSpeeds = value;
      print(widget.painter.showingSpeeds);

      if (widget.painter.showingSpeeds == false) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Enable Showing Speeds"),
                  new Checkbox(
                    value: widget.painter.showingSpeeds,
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