import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import '../services/drawOverview.dart';

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
  List<Image> optimizeImages = loadOptimizeImages();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: devoloBlue,
      ),
      body: new Center(
    child: Padding(
    padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(height: 20,),
            RaisedButton(
              child: Text("Optimierungshilfe"),
                color: devoloBlue,
                textColor: Colors.white,
                onPressed: () {_optimiseAlert(context);}
                ),
          ],
        ),
    ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _optimiseAlert(context) { //ToDo not working yet, switch _index and rebuild
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Optimierungs Hilfe"),
            content: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () { print("back");
                  setState(() {
                    _index--;
                  });
                  },),
                  optimizeImages[_index],
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    print("forward");
                    setState(() {
                      _index++;
                    });
                    },),

              ],),
            ),
          );
        });
  }

}
