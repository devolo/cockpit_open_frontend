import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/helpers.dart';
import '../services/handleSocket.dart';
import '../services/DrawOverview.dart';
import 'logsScreen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title, this.painter}) : super(key: key);

  final String title;
  DrawNetworkOverview painter;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //DrawNetworkOverview painter;


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
    final socket = Provider.of<dataHand>(context);

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
                      value: config["allow_data_collection"], //ToDo
                      onChanged: (bool value) {
                        setState(() {
                          config["allow_data_collection"] = !config["allow_data_collection"];
                          socket.sendXML('Config');
                        });
                      }
                  ),
                  new Text("Übertragungsleistung der Geräte Aufzeichnen und an devolo übermitteln"),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Checkbox(
                  value: config["ignore_updates"], //ToDo
                  onChanged: (bool value) {
                    setState(() {
                      config["ignore_updates"] = !config["ignore_updates"];
                    });
                  }
                ),
                  new Text("Alle zukünftigen Updates ignorieren"),

                ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
                child: Text('Support Informationen generieren'),
                onPressed: () async {
                  socket.sendXML('SupportInfoGenerate');
                  print(await socket.recieveXML());
                  setState(() {
                    //socket.recieveXML().then((path) =>openFile(path[0]));

                    socket.recieveXML().whenComplete(() => print('COPÜMLETEE'));
                  });
                }),
            IconButton(
              icon: Icon(Icons.open_in_browser_rounded),
              tooltip: 'öffne bowser',
              onPressed: () {socket.recieveXML().then((response) =>openFile(response['htmlfilename']));},
            ),
            IconButton(
              icon: Icon(Icons.archive_outlined),
              tooltip: 'öffne zip',
              onPressed: () {socket.recieveXML().then((response) =>openFile(response['zipfilename']));},
            ),
            IconButton(
              icon: Icon(Icons.send_and_archive),
              tooltip: 'sende an devolo',
              onPressed: () {socket.recieveXML().then((response) =>openFile(response['zipfilename']));}, //ToDo
            ),
          ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
        IconButton(
          icon: Icon(Icons.list_alt),
          tooltip: 'Show Logs',
          onPressed: () {Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new LogsScreen(title: 'Logs')),
          );}, //ToDo
        ),
            ]),

          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _handleCriticalActions(context, socket, messageType, {mac}) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(messageType),
            content: Text('Bitte Aktion bestätigen.'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Abbrechen'),
                  onPressed: (){
                    // Cancel critical action
                    Navigator.of(context).pop();
                  }
              ),
              FlatButton(
                child: Text('Bestätigen'),
                onPressed: (){
                  // Critical things happening here
                  socket.sendXML(messageType, mac: mac);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}