import 'dart:async';
import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/views/logsScreen.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title, this.painter}) : super(key: key);

  final String title;
  DrawOverview painter;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _newPw;
  bool _hiddenPw = true;
  bool _isButtonDisabled = true;
  bool _loading = false;
  String _zipfilename;
  String _htmlfilename;
  var response;

  ColorSwatch _tempMainColor;
  ColorSwatch _mainColor;
  Color _tempShadeMainColor = mainColor;
  Color _shadeMainColor = mainColor;
  Color _tempShadeSecondColor = secondColor;
  Color _shadeSecondColor = secondColor;
  Color _tempShadeFontColorLight = fontColorLight;
  Color _shadeFontColorLight = fontColorLight;
  Color _tempShadeFontColorDark = fontColorDark;
  Color _shadeFontColorDark = fontColorDark;

  final _scrollController = ScrollController();

  void saveToSharedPrefs(Map<String, dynamic> inputMap) async {
    print('Config from Prog: ${inputMap}');

    String jsonString = json.encode(inputMap);
    print('Config from Prog: ${jsonString}');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var config = prefs.get("config");
    print('Config from Prefs: ${config}');

    await prefs.setString('config', jsonString);

  }

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
      saveToSharedPrefs(config);
    });
  }

  void _mainColorPicker(title, title2, title3, title4) async {
    _openDialog(
      title,
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: mainColor,
        onColorChange: (color) {
          setState(() {
            _tempShadeMainColor = color;
            mainColor = color;
            backgroundColor = color;
            AppBuilder.of(context).rebuild();
          });
        },
        onMainColorChange: (color) {
          setState(() {
            _tempMainColor = color;
            mainColor = color;
            backgroundColor = color;
            AppBuilder.of(context).rebuild();
          });
        },
        onBack: () => print("Back button pressed"),
      ),
      title2,
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: secondColor,
        onColorChange: (color) {
          setState(() {
            _tempShadeSecondColor = color;
            secondColor = color;
            AppBuilder.of(context).rebuild();
          });
        },
        onMainColorChange: (color) {
          setState(() {
            _shadeSecondColor = color;
            secondColor = color;
            AppBuilder.of(context).rebuild();
          });
        },
        onBack: () => print("Back button pressed"),
      ),
      title3,
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: _shadeFontColorLight,
        onColorChange: (color) {
          setState(() {
            _tempShadeFontColorLight = color;
            fontColorLight = color;
            //drawingColor = color;
            AppBuilder.of(context).rebuild();
          });
        },
        onMainColorChange: (color) => setState(() {
          _tempShadeFontColorLight = color;
          fontColorLight = color;
          AppBuilder.of(context).rebuild();
        }),
        onBack: () => print("Back button pressed"),
      ),
      title4,
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: _shadeFontColorDark,
        onColorChange: (color) {
          setState(() {
            _tempShadeFontColorDark = color;
            fontColorDark = color;
            //drawingColor = color;
          });
        },
        onMainColorChange: (color) => setState(() {
          _tempShadeFontColorDark = color;
          fontColorDark = color;
        }),
        onBack: () => print("Back button pressed"),
      ),
    );
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
    var _deviceList = Provider.of<NetworkList>(context);

    if (config["language"] == "") {
      config["language"] = Localizations.localeOf(context).toString();
    }

    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text(
          S.of(context).settings,
          textScaleFactor: fontSizeFactor,
          style: TextStyle(color: fontColorLight),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        shadowColor: Colors.transparent,
      ),
      body: Scrollbar(
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
                  Text(
                    S.of(context).appearance,
                    style: TextStyle(color: fontColorLight),
                  )
                ]),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  subtitle: Text(S.of(context).changeTheLanguageOfTheApp, style: TextStyle(color: fontColorMedium, fontSize: 15 * fontSizeFactor)),
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(
                      S.of(context).language,
                      style: TextStyle(color: fontColorDark),
                    ),
                    DropdownButton<String>(
                      value: config["language"],
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: mainColor,
                      ),
                      iconSize: 24,
                      elevation: 8,
                      //style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: mainColor,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          config["language"] = newValue;
                          S.load(Locale(newValue, ''));
                        });
                        AppBuilder.of(context).rebuild();
                        saveToSharedPrefs(config);
                      },
                      items: <String>['en', 'de'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value + "  ",
                                style: TextStyle(color: fontColorDark),
                              ),
                              Flag(
                                value == "en" ? "gb" : value, // ToDo which flag?
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
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  subtitle: Text(S.of(context).dataRatesArePermanentlyDisplayedInTheOverview, style: TextStyle(color: fontColorMedium, fontSize: 15 * fontSizeFactor)),
                  title: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(S.of(context).enableShowingSpeeds, style: TextStyle(color: fontColorDark), semanticsLabel: "Show Speeds"),
                    new Checkbox(
                      value: config["show_speeds_permanent"], //widget.painter.showSpeedsPermanently,
                      onChanged: toggleCheckbox,
                      activeColor: mainColor,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  subtitle: Text(S.of(context).theOverviewWillBeCenteredAroundThePlcDeviceConnected, style: TextStyle(color: fontColorMedium, fontSize: 15 * fontSizeFactor)),
                  title: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(
                      S.of(context).internetcentered,
                      style: TextStyle(color: fontColorDark),
                    ),
                    new Switch(
                      value: config["internet_centered"],
                      onChanged: (value) {
                        setState(() {
                          config["internet_centered"] = value;
                          socket.sendXML('RefreshNetwork');
                          saveToSharedPrefs(config);
                        });
                      },
                      activeTrackColor: mainColor.withAlpha(120),
                      activeColor: mainColor,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  subtitle: Text(S.of(context).otherDevicesEgPcAreDisplayedInTheOverview, style: TextStyle(color: fontColorMedium, fontSize: 15 * fontSizeFactor)),
                  title: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(
                      S.of(context).showOtherDevices,
                      style: TextStyle(color: fontColorDark),
                    ),
                    new Switch(
                      value: config["show_other_devices"],
                      onChanged: (value) {
                        setState(() {
                          config["show_other_devices"] = value;
                          socket.sendXML('RefreshNetwork');
                        });
                      },
                      activeTrackColor: mainColor.withAlpha(120),
                      activeColor: mainColor,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(
                      S.of(context).fontsize,
                      style: TextStyle(color: fontColorDark),
                    ),
                    Spacer(),
                    Expanded(
                      child: new SpinBox(
                        min: 0.1,
                        max: 5.0,
                        step: 0.1,
                        acceleration: 0.1,
                        decimals: 1,
                        value: fontSizeFactor.toDouble(),
                        //fontSizeDelta,
                        onChanged: (value) {
                          setState(() {
                            fontSizeFactor = value;
                          });
                          AppBuilder.of(context).rebuild();
                        },
                        //decoration: InputDecoration(labelText: 'Fontsize'),
                      ),
                    ),
                  ]),
                ),
                Divider(),
                GestureDetector(
                  onTap: () {
                    _mainColorPicker("Main color", "Accent color", "Light font color", "Dark font color");
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    tileColor: secondColor,
                    subtitle: Text(S.of(context).chooseMainColorAccentColorAndFontColors, style: TextStyle(color: fontColorMedium, fontSize: 15 * fontSizeFactor)),
                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      new Text(
                        S.of(context).appColor,
                        style: TextStyle(color: fontColorDark),
                      ),
                      Spacer(),
                      Text(config['theme']['name']),
                      // CircleAvatar(
                      //   backgroundColor: mainColor, //_tempMainColor,
                      //   radius: 18.0,
                      //   child: FlatButton(
                      //     height: 40,
                      //     //hoverColor: devoloBlue.withOpacity(0.4),
                      //     //color: devoloBlue.withOpacity(0.4),
                      //     onPressed: () {
                      //       _mainColorPicker("Main color", "Accent color", "Light font color", "Dark font color");
                      //     },
                      //     child: CircleAvatar(
                      //       backgroundColor: secondColor, //_tempShadeColor,
                      //       radius: 18.0,
                      //       child: FlatButton(
                      //         height: 40,
                      //         //hoverColor: devoloBlue.withOpacity(0.4),
                      //         //color: devoloBlue.withOpacity(0.4),
                      //         onPressed: () {
                      //           //_secondColorPicker("Choose secondary color");
                      //           _mainColorPicker("Main color", "Accent color", "Light font color", "Dark font color");
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ]),
                  ),
                ),
                Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(
                    S.of(context).network,
                    style: TextStyle(color: fontColorLight),
                  )
                ]),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    new Text(
                      S.of(context).ignoreUpdates,
                      style: TextStyle(color: fontColorDark),
                    ),
                    new Checkbox(
                        value: config["ignore_updates"],
                        activeColor: mainColor,
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
                    new Text(
                      S.of(context).recordTheTransmissionPowerOfTheDevicesAndTransmitIt,
                      style: TextStyle(color: fontColorDark),
                    ),
                    new Checkbox(
                        value: config["allow_data_collection"],
                        activeColor: mainColor,
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
                    new Text(
                      S.of(context).windowsNetworkThrottling,
                      style: TextStyle(color: fontColorDark),
                    ),
                    new Switch(
                      value: !config["windows_network_throttling_disabled"],
                      onChanged: (value) {
                        setState(() {
                          config["windows_network_throttling_disabled"] = !value;
                          print(config["windows_network_throttling_disabled"]);
                          socket.sendXML('Config');
                        });
                      },
                      activeTrackColor: mainColor.withAlpha(120),
                      activeColor: mainColor,
                    ),
                  ]),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(
                    children: [
                      Expanded(
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
                          value: !_hiddenPw,
                          activeColor: mainColor,
                          onChanged: (bool value) {
                            setState(() {
                              _hiddenPw = !_hiddenPw;
                            });
                          }),
                      Text(
                        S.of(context).showPassword,
                        style: TextStyle(color: fontColorDark),
                      ),
                      FlatButton(
                        height: 62,
                        hoverColor: mainColor.withOpacity(0.4),
                        color: mainColor.withOpacity(0.4),
                        onPressed: () {
                          socket.sendXML('SetNetworkPassword', newValue: _newPw, valueType: "password", mac: _deviceList.getLocal().mac);
                        },
                        child: Text(
                          S.of(context).set, /*style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),*/
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(
                    S.of(context).support,
                    style: TextStyle(color: fontColorLight),
                  )
                ]),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  tileColor: secondColor,
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    FlatButton(
                      height: 60,
                      hoverColor: mainColor.withOpacity(0.4),
                      color: mainColor.withOpacity(0.4),
                      child: Row(children: [
                        Text(
                          S.of(context).generateSupportInformation,
                          style: TextStyle(color: fontColorDark),
                        ),
                        Stack(children: <Widget>[
                          Container(child: _loading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)) : Text("")),
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
                              color: _isButtonDisabled ? Colors.grey : mainColor,
                              onPressed: () {
                                openFile(_htmlfilename);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.archive_outlined),
                              tooltip: S.of(context).openZip,
                              color: _isButtonDisabled ? Colors.grey : mainColor,
                              onPressed: () {
                                openFile(_zipfilename);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.send_and_archive),
                              tooltip: S.of(context).sendToDevolo,
                              color: _isButtonDisabled ? Colors.grey : mainColor,
                              onPressed: () {
                                _contactInfoAlert(context);
                              },
                            ),
                          ],
                        )),
                  ]),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                  // IconButton(
                  //   icon: Icon(Icons.text_fields_sharp),
                  //   tooltip: "Test",
                  //   color: drawingColor,
                  //   onPressed: () {
                  //     if (_deviceList.selectedNetworkIndex == 0) {
                  //       _deviceList.selectedNetworkIndex = 1;
                  //     } else {
                  //       _deviceList.selectedNetworkIndex = 0;
                  //     }
                  //   },
                  // ),
                  IconButton(
                    icon: Icon(Icons.list_alt),
                    tooltip: S.of(context).showLogs,
                    color: drawingColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new DebugScreen(title: 'Logs')),
                      );
                    },
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _contactInfoAlert(context) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).contactInfo),
            backgroundColor: backgroundColor.withOpacity(0.9),
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
                    labelText: S.of(context).yourEmailaddress,
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
                  size: 35 * fontSizeFactor,
                  color: mainColor,
                ), //Text('Bestätigen'),
                onPressed: () {
                  // action happening here
                  Navigator.maybeOf(context).pop();
                },
              ),
              FlatButton(
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 35 * fontSizeFactor,
                    color: mainColor,
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context).pop();
                  }),
            ],
          );
        });
  }

  void _openDialog(String title1, Widget content1, [String title2, Widget content2, String title3, Widget content3, String title4, Widget content4]) {
    double _animatedHeight = 0.0;
    String selected;

    Map<String, dynamic> contents = Map();
    contents[title1] = content1;
    contents[title2] = content2;
    contents[title3] = content3;
    contents[title4] = content4;

    print(contents.entries);

    showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor.withOpacity(0.9),
          contentPadding: const EdgeInsets.all(20.0),
          title: Text(
            S.of(context).appColor,
            style: TextStyle(color: fontColorLight),
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Text(
                    S.of(context).chooseTheme,
                    style: TextStyle(color: fontColorLight),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new FlatButton(
                        minWidth: 200,
                        color: secondColor,
                        child: Column(
                          children: [
                            SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_devolo.PNG'))),
                            new Text(
                              "Standard Theme",
                              style: TextStyle(color: fontColorDark),
                            ),
                          ],
                        ),
                        hoverColor: fontColorLight,
                        onPressed: () {
                          setState(() {
                            config["theme"] = theme_devolo;
                            mainColor = theme_devolo["mainColor"];
                            backgroundColor = theme_devolo["backgroundColor"];
                            secondColor = theme_devolo["secondColor"];
                            drawingColor = theme_devolo["drawingColor"];
                            fontColorLight = theme_devolo["fontColorLight"];
                            fontColorMedium = theme_highContrast["fontColorMedium"];
                            fontColorDark = theme_devolo["fontColorDark"];
                            AppBuilder.of(context).rebuild();
                          });
                        },
                      ),
                      new FlatButton(
                        minWidth: 200,
                        color: secondColor,
                        child: Column(
                          children: [
                            SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_dark.PNG'))),
                            new Text(
                              "Dark Theme",
                              style: TextStyle(color: fontColorDark),
                            ),
                          ],
                        ),
                        hoverColor: fontColorLight,
                        onPressed: () {
                          setState(() {
                            config["theme"] = theme_dark;
                            mainColor = theme_dark["mainColor"];
                            backgroundColor = theme_dark["backgroundColor"];
                            secondColor = theme_dark["secondColor"];
                            drawingColor = theme_dark["drawingColor"];
                            fontColorLight = theme_dark["fontColorLight"];
                            fontColorMedium = theme_highContrast["fontColorMedium"];
                            fontColorDark = theme_dark["fontColorDark"];
                            AppBuilder.of(context).rebuild();
                          });
                        },
                      ),
                      new FlatButton(
                        minWidth: 200,
                        color: secondColor,
                        child: Column(
                          children: [
                            SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_highContrast.PNG'))),
                            new Text(
                              "High Contrast Theme",
                              style: TextStyle(color: fontColorDark),
                            ),
                          ],
                        ),
                        hoverColor: fontColorLight,
                        onPressed: () {
                          setState(() {
                            config["theme"] = theme_highContrast;
                            mainColor = theme_highContrast["mainColor"];
                            backgroundColor = theme_highContrast["backgroundColor"];
                            secondColor = theme_highContrast["secondColor"];
                            drawingColor = theme_highContrast["drawingColor"];
                            fontColorLight = theme_highContrast["fontColorLight"];
                            fontColorMedium = theme_highContrast["fontColorMedium"];
                            fontColorDark = theme_highContrast["fontColorDark"];
                            AppBuilder.of(context).rebuild();
                          });
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    S.of(context).fullyCustomizeColors,
                    style: TextStyle(color: fontColorLight),
                  ),
                  Divider(),
                  for (dynamic con in contents.entries)
                    Column(
                      children: [
                        new GestureDetector(
                          onTap: () {
                            setState(() {
                              print(con);
                              selected = con.key;
                              _animatedHeight != 0.0 ? _animatedHeight = 0.0 : _animatedHeight = 180.0;
                            });
                            AppBuilder.of(context).rebuild();
                          },
                          child: new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Text(
                                  " " + con.key,
                                  style: TextStyle(color: fontColorDark),
                                ),
                                Spacer(),
                                // ToDo CircleAvatar doesn't change
                                // new CircleAvatar(
                                //   backgroundColor: con.value.selectedColor, //_tempShadeColor,
                                //   radius: 15.0,
                                // ),
                                new Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: fontColorDark,
                                ),
                              ],
                            ),
                            color: secondColor, //Colors.grey[800].withOpacity(0.9),
                            height: 50.0,
                            width: 900.0,
                          ),
                        ),
                        new AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          child: Column(
                            children: [
                              Expanded(child: con.value),
                            ],
                          ),
                          height: selected == con.key ? _animatedHeight : 0.0,
                          color: secondColor.withOpacity(0.8),
                          //Colors.grey[800].withOpacity(0.6),
                          width: 900.0,
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          actions: [
            FlatButton(
              child: Icon(
                Icons.check_circle_outline,
                size: 35 * fontSizeFactor,
                color: fontColorLight,
              ), //Text('Bestätigen'),
              onPressed: () {
                // action happening here
                Navigator.maybeOf(context).pop();
                setState(() {});
              },
            ),
            FlatButton(
                child: Icon(
                  Icons.cancel_outlined,
                  size: 35 * fontSizeFactor,
                  color: fontColorLight,
                ), //Text('Abbrechen'),
                onPressed: () {
                  // Cancel critical action
                  Navigator.maybeOf(context).pop();
                  setState(() {});
                }),
          ],
        );
      },
    );
  }
}
