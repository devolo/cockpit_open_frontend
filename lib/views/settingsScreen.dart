import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/helpers.dart';
import '../services/handleSocket.dart';
import '../services/drawOverview.dart';
import 'logsScreen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title, this.painter}) : super(key: key);

  final String title;
  DrawNetworkOverview painter;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _newPw;

  void toggleCheckbox(bool value) {
    setState(() {
      widget.painter.showSpeedsPermanently = value;
      print(value);

      if (widget.painter.showSpeedsPermanently) {
        widget.painter.showingSpeeds = true;
        widget.painter.pivotDeviceIndex = 0;
      } else {
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
            Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              IconButton(
                icon: Icon(Icons.list_alt),
                tooltip: 'Show Logs',
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new DebugScreen(title: 'Logs')),
                  );
                }, //ToDo
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Text("GUI", style: TextStyle(color: devoloBlue, fontSize: 20),)
            ]),
            Card(
              color: Colors.blueGrey[50],
              child: new Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                new Checkbox(
                  value: widget.painter.showSpeedsPermanently,
                  onChanged: toggleCheckbox,
                ),
                new Text("Enable Showing Speeds"),
              ]),
            ),
            Card(
              color: Colors.blueGrey[50],
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                new Checkbox(
                    value: config["ignore_updates"], //ToDo
                    onChanged: (bool value) {
                      setState(() {
                        config["ignore_updates"] = !config["ignore_updates"];
                      });
                    }),
                new Text("Alle zukünftigen Updates ignorieren"),
              ]),
            ),
            Card(
              color: Colors.blueGrey[50],
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                new Checkbox(
                    value: config["allow_data_collection"], //ToDo
                    onChanged: (bool value) {
                      setState(() {
                        config["allow_data_collection"] = !config["allow_data_collection"];
                        socket.sendXML('Config');
                      });
                    }),
                new Text("Übertragungsleistung der Geräte Aufzeichnen und an devolo übermitteln"),
              ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Netzwerk", style: TextStyle(color: devoloBlue, fontSize: 20),)
                ]),
        Card(
          color: Colors.blueGrey[50],
            child: TextFormField( // ToDo sendXml find out Device Mac connected to Internet + Password formfield (hidden)
              initialValue: _newPw,
              decoration: InputDecoration(
                labelText: 'PLC-Netzwerk Kennwort ändern',
                //helperText: 'Devicename',
              ),
              onChanged: (value) => ( _newPw = value),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte neues Passwort eintragen';
                }
                return null;
              },
            ),),
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Support", style: TextStyle(color: devoloBlue, fontSize: 20),)
                ]),
            Card(
              color: Colors.blueGrey[50],
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                RaisedButton(
                    child: Text('Support Informationen generieren'),
                    color: devoloBlue,
                    textColor: Colors.white,
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
                  onPressed: () {
                    socket.recieveXML().then((response) => openFile(response['htmlfilename']));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.archive_outlined),
                  tooltip: 'öffne zip',
                  onPressed: () {
                    socket.recieveXML().then((response) => openFile(response['zipfilename']));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send_and_archive),
                  tooltip: 'sende an devolo',
                  onPressed: () {
                    socket.recieveXML().then((response) => openFile(response['zipfilename']));
                  }, //ToDo
                ),
              ]),
            ),
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
                  onPressed: () {
                    // Cancel critical action
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                child: Text('Bestätigen'),
                onPressed: () {
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
