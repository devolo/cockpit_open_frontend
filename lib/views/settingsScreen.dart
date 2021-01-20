import 'dart:async';
import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/views/logsScreen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title, this.painter}) : super(key: key);

  final String title;
  DrawNetworkOverview painter;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _newPw;
  bool _hiddenPw = true;
  String _dropdownValue = 'en';
  bool _isButtonDisabled = true;
  bool _loading = false;
  String _zipfilename;
  String _htmlfilename;
  var response;

  final _scrollController = ScrollController();

  void toggleCheckbox(bool value) {
    setState(() {
      config["show_speeds_permanent"] = value;
      print(value);

      if (config["show_speeds_permanent"]) {
        config["show_speeds"] = true;
        //widget.painter.pivotDeviceIndex = 0;
      } else {
        config["show_speeds"] = false;
        //widget.painter.pivotDeviceIndex = 0;
      }
    });
  }

  //creating the timer that stops the loading after 15 secs
  void startTimer() {
    Timer.periodic(const Duration(seconds: 10), (t) {
      setState(() {
        _isButtonDisabled = false;
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  Widget build(BuildContext context) {
    dataHand socket = Provider.of<dataHand>(context);
    var _deviceList = Provider.of<DeviceList>(context);

    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text(S.of(context).settings),
        centerTitle: true,
        backgroundColor: devoloBlue,
        shadowColor: Colors.transparent,
      ),
      body:Scrollbar(
        controller: _scrollController, // <---- Here, the controller
        isAlwaysShown: true, // <---- Required
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: new SingleChildScrollView(
              controller: _scrollController,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(S.of(context).gui, style: TextStyle(color: drawingColor, fontSize: 20),)
                ]),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).enableShowingSpeeds),
                    new Checkbox(
                      value: config["show_speeds_permanent"], //widget.painter.showSpeedsPermanently,
                      onChanged: toggleCheckbox,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).internetcentered),
                    new Switch(
                      value: config["internet_centered"],
                      onChanged: (value) {
                        setState(() {
                          config["internet_centered"] = value;
                          socket.sendXML('RefreshNetwork');
                        });
                      },
                      activeTrackColor: devoloBlue.withAlpha(120),
                      activeColor: devoloBlue,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).showOtherDevices),
                    new Switch(
                      value: config["show_other_devices"],
                      onChanged: (value) {
                        setState(() {
                          config["show_other_devices"] = value;
                          socket.sendXML('RefreshNetwork');
                        });
                      },
                      activeTrackColor: devoloBlue.withAlpha(120),
                      activeColor: devoloBlue,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).language),
                    DropdownButton<String>(
                      value: _dropdownValue,
                      icon: Icon(Icons.arrow_drop_down_rounded,color: devoloBlue,),
                      iconSize: 24,
                      elevation: 8,
                      //style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: devoloBlue,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                          S.load(Locale(newValue, ''));
                        });
                      },
                      items: <String>['en', 'de']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("  "+value),
                              Flag(
                                value=="en"?"gb": value,
                                height: 15,
                                width: 25,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
                ),
                Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                  Text(S.of(context).network, style: TextStyle(color: drawingColor, fontSize: 20),
                  )
                ]),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).ignoreUpdates),
                    new Checkbox(
                        value: config["ignore_updates"], //ToDo
                        onChanged: (bool value) {
                          setState(() {
                            config["ignore_updates"] = !config["ignore_updates"];
                            socket.sendXML('Config');
                          });
                        }),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).recordTheTransmissionPowerOfTheDevicesAndTransmitIt),
                    new Checkbox(
                        value: config["allow_data_collection"], //ToDo
                        onChanged: (bool value) {
                          setState(() {
                            config["allow_data_collection"] = !config["allow_data_collection"];
                            socket.sendXML('Config');
                          });
                        }),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).windowsNetworkThrottling),
                    new Switch(
                      value: !config["windows_network_throttling_disabled"],
                      onChanged: (value) {
                        setState(() {
                          config["windows_network_throttling_disabled"] = !value;
                          print(config["windows_network_throttling_disabled"]);
                          socket.sendXML('Config');
                        });
                      },
                      activeTrackColor: devoloBlue.withAlpha(120),
                      activeColor: devoloBlue,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          // ToDo sendXml find out Device Mac connected to Internet + Password formfield (hidden)
                          initialValue: _newPw,
                          obscureText: _hiddenPw,
                          decoration: InputDecoration(
                            labelText: S.of(context).changePlcnetworkPassword,
                            //helperText: 'Devicename',
                          ),
                          onChanged: (value) => (_newPw = value),
                          validator: (value) {
                            if (value.isEmpty) {
                              return S.of(context).pleaseEnterPassword;
                            }
                            return null;
                          },
                        ),
                      ),
                      new Checkbox(
                          value: !_hiddenPw, //ToDo
                          onChanged: (bool value) {
                            setState(() {
                              _hiddenPw = !_hiddenPw;
                            });
                          }),
                      Text(S.of(context).showPassword),
                      FlatButton(
                        height: 62,
                          hoverColor: devoloBlue.withOpacity(0.4),
                          color: devoloBlue.withOpacity(0.4),
                          onPressed: () {
                            socket.sendXML('SetNetworkPassword', newValue: _newPw,valueType: "password", mac: _deviceList.getPivot().mac);
                          },
                          child: Text(S.of(context).set,/*style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),*/),
                      )
                    ],
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                  Text(S.of(context).support, style: TextStyle(color: drawingColor, fontSize: 20),
                  )
                ]),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    FlatButton(
                      height: 60,
                      hoverColor: devoloBlue.withOpacity(0.4),
                      color: devoloBlue.withOpacity(0.4),
                      child: Row(children: [
                        Text(S.of(context).generateSupportInformation),

                          Stack(children: <Widget>[
                            Container(child: _loading ? CircularProgressIndicator() : Text("")),
                            if (response != null && _loading == false)
                            Container(
                                child: (response["result"] == "ok" && response.isNotEmpty)
                                    ? Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      )),
                          ]),
                      ]),
                      //color: devoloBlue,
                      //textColor: Colors.white,
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                          socket.sendXML('SupportInfoGenerate');
                        });

                        response = await socket.recieveXML(["SupportInfoGenerateStatus"]);
                        //print('Response: ' + response.toString());

                        setState(() {
                          if (response["result"] == "ok") {
                            _htmlfilename = response["htmlfilename"];
                            _zipfilename = response["zipfilename"];
                            _loading = false;
                            _isButtonDisabled = false;
                          }
                        });
                      },
                    ),
                    //Flexible(child: socket.waitingResponse ? CircularProgressIndicator() : Text(" ")),
                    Spacer(),
                    AbsorbPointer(
                        absorbing: _isButtonDisabled,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.open_in_browser_rounded),
                              tooltip: S.of(context).openBrowser,
                              color: _isButtonDisabled ? Colors.grey : devoloBlue,
                              onPressed: () {
                                openFile(_htmlfilename);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.archive_outlined),
                              tooltip: S.of(context).openZip,
                              color: _isButtonDisabled ? Colors.grey : devoloBlue,
                              onPressed: () {
                                openFile(_zipfilename);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.send_and_archive),
                              tooltip: S.of(context).sendToDevolo,
                              color: _isButtonDisabled ? Colors.grey : devoloBlue,
                              onPressed: () {
                                _contactInfoAlert(context);
                              },
                            ),
                          ],
                        )),
                  ]),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.list_alt),
                    tooltip: S.of(context).showLogs,
                    color: drawingColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new DebugScreen(title: 'Logs')),
                      );
                    }, //ToDo
                  ),
                ]),
              ],
            ),
        ),
          ),
      ),
    );
  }

  void _handleCriticalActions(context, socket, messageType, {mac}) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(messageType),
            content: Text(S.of(context).pleaseConfirmAction),
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.check_circle_outline,
                  size: 35,
                  color: devoloBlue,
                ), //Text('Bestätigen'),
                onPressed: () {
                  // Critical things happening here
                  socket.sendXML(messageType, mac: mac);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 35,
                    color: devoloBlue,
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _contactInfoAlert(context) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).contactInfo),
            content: Column(
              children: <Widget>[
                Text(S.of(context).theCreatedSupportInformationCanNowBeSentToDevolo),
                TextFormField(
                  //initialValue: _newPw,
                  decoration: InputDecoration(
                    labelText: S.of(context).processNumber,
                    //helperText: 'Devicename',
                  ),
                  onChanged: (value) => (_newPw = value),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).pleaseEnterProcessingNumber;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  //initialValue: _newPw,
                  decoration: InputDecoration(
                    labelText: S.of(context).yourName,
                    //helperText: 'Devicename',
                  ),
                  onChanged: (value) => (_newPw = value),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).pleaseFillInYourName;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  //initialValue: _newPw,
                  decoration: InputDecoration(
                    labelText: ' Ihre Mail-Adresse',
                    //helperText: 'Devicename',
                  ),
                  onChanged: (value) => (_newPw = value),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).pleaseEnterYourMailAddress;
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.check_circle_outline,
                  size: 35,
                  color: devoloBlue,
                ), //Text('Bestätigen'),
                onPressed: () {
                  // action happening here
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 35,
                    color: devoloBlue,
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}
