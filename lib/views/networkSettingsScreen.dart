import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import '../services/DrawOverview.dart';

class NetworkSettingsScreen extends StatefulWidget {
  NetworkSettingsScreen({Key key, this.title, DeviceList deviceList}) : super(key: key);

  final String title;
  dataHand model;


  @override
  _NetworkSettingsScreenState createState() => _NetworkSettingsScreenState(title: title);
}

class _NetworkSettingsScreenState extends State<NetworkSettingsScreen> {
  _NetworkSettingsScreenState({this.title});

  final String title;
  String _newPw;
  bool _updating = false;

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: devoloBlue,
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            TextFormField( //TODO sendXml find out Device Mac connected to Internet + Password formfield (hidden)
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
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
