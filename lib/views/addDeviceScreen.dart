import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';

class AddDeviceScreen extends StatefulWidget {
  AddDeviceScreen({Key key, this.title, DeviceList deviceList}) : super(key: key);

  final String title;
  dataHand model;

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState(title: title);
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  _AddDeviceScreenState({this.title});

  final String title;
  String _newPw;
  String _newTest;
  List<Image> optimizeImages = loadOptimizeImages();
  Image _currImage;
  int _index = 0;

  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    _currImage = optimizeImages.first;
    final socket = Provider.of<dataHand>(context);
    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text("Netzwerk Einstellungen"),
        centerTitle: true,
        backgroundColor: devoloBlue,
        shadowColor: Colors.transparent,
      ),
      body: new SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText(
                'Gerät hinzufügen',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              SelectableText(
                "1.) Stecken Sie beide PLC-Geräte in die gewünschten Wandsteckdosen und warten ca. 45 Sekunden.\n"
                    "2.) Drücken Sie kurz den Verschlüsselungsknopf des ersten (evtl. bereits vorhandenen) PLC-Gerätes.\n"
                    "3.) Drücken Sie innerhalb von zwei Minuten den Verschlüsselungsknopf des zweiten (neuen) PLC-Gerätes ebenfalls kurz.\n"
                    "4.) Sobald die LEDs dauerhaft leuchten, sind die PLC-Geräte betriebsbereit.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(image: AssetImage('assets/addDevice1.png')),
                  Image(image: AssetImage('assets/addDevice2.png')),
                  Image(image: AssetImage('assets/addDevice1.png')),
                  Image(image: AssetImage('assets/addDevice1.png')),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  child: Text("Optimierungshilfe öffnen"),
                  color: Colors.blue[800],
                  textColor: Colors.white,
                  onPressed: () {
                    _optimiseAlert(context);
                  }),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                //TODO sendXml find out Device Mac connected to Internet + Password formfield (hidden)
                initialValue: _newTest,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: 'Testing', labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.amberAccent : Colors.white)
                    //helperText: 'Devicename',
                    ),
                onChanged: (value) => (_newPw = value),
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
      ),
    );
  }

  void _optimiseAlert(context) {
    //ToDo not working yet, switch _index and rebuild
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Optimierungs Hilfe"),
              content: StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          print("back");
                          setState(() {
                            if(_index > 0){
                            _index--;
                            _currImage = optimizeImages[_index];}
                          });
                        },
                      ),
                      Container(
                        child: _currImage,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          print("forward");
                          setState(() {
                            if(_index < optimizeImages.length-1){
                            _index++;
                            _currImage = optimizeImages[_index];}
                          });
                        },
                      ),
                    ],
                  ),
                );
              }));
        });
  }
}
