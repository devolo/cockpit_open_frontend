/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:async';
import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/models/configModel.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
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
  //ConfigModel configModel = ConfigModel();

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  /* =========== Styling =========== */

  double listTilePaddingContentTop = 10;
  double listTilePaddingContentBottom = 10;
  double listTilePaddingContentRight = 10;
  double listTilePaddingContentLeft = 10;

  //space between title and subtitle
  double listTileSubTitlePaddingTop = 10;

  Color dividerColor = Colors.transparent;
  double dividerTitleSpacing = 30;

  // Switch colors
  Color switchActiveTrackColor = mainColor.withAlpha(100);
  Color switchActiveColor = Colors.white;
  Color switchInactiveThumbColor = Colors.black;
  Color switchInactiveTrackColor = Colors.grey[600];

  /* ===========  =========== */



  String _newPw;
  bool _hiddenPw = true;
  bool _isButtonDisabled = true;
  bool _loading = false;
  String _zipfilename;
  String _htmlfilename;
  var response;
  var waitForNetworkPasswordResponse = false;
  var networkPasswordResponseTrue = false;
  var networkPasswordResponseFalse = false;

  ColorSwatch _tempMainColor;
  ColorSwatch _mainColor;
  Color _tempShadeMainColor; //=configModel.mainColor;
  Color _shadeMainColor; // = mainColor;
  Color _tempShadeSecondColor; // = secondColor;
  Color _shadeSecondColor; // = secondColor;
  Color _tempShadeFontColorLight; // = fontColorLight;
  Color _shadeFontColorLight; // = fontColorLight;
  Color _tempShadeFontColorDark; // = fontColorDark;
  Color _shadeFontColorDark; // = fontColorDark;

  final _scrollController = ScrollController();
  FocusNode myFocusNode = new FocusNode();


  void toggleCheckbox(bool value) {
    setState(() {
      config["show_speeds_permanent"] = value;

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

    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text(
          S.of(context).settings,
          style: TextStyle(fontSize: fontSizeAppBarTitle * fontSizeFactor, color: fontColorLight),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        shadowColor: Colors.transparent,
      ),
      body: Scrollbar(
        controller: _scrollController, // <---- Here, the controller
        isAlwaysShown: true, // <---- Required
        child: Padding(
          padding: const EdgeInsets.only(left: 200, right: 200),
          child: new SingleChildScrollView(
            controller: _scrollController,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Divider(color: dividerColor, height: dividerTitleSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(
                    S.of(context).general,
                    style: TextStyle(fontSize: fontSizeSectionTitle * fontSizeFactor, color: fontColorLight),
                  )
                ]),
                Divider(color: dividerColor),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      toggleCheckbox(!config["show_speeds_permanent"]);
                      saveToSharedPrefs(config);
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                    tileColor: secondColor,
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: listTileSubTitlePaddingTop),
                      child: Text(S.of(context).dataRatesArePermanentlyDisplayedInTheOverview, style: TextStyle(color: fontColorMedium, fontSize: fontSizeListTileSubtitle * fontSizeFactor)
                      ),
                    ),
                    title: Text(S.of(context).enableShowingSpeeds, style: TextStyle(fontSize: fontSizeListTileTitle*fontSizeFactor, color: fontColorDark), semanticsLabel: "Show Speeds"
                    ),
                    trailing: Switch(
                      value: config["show_speeds_permanent"], //widget.painter.showSpeedsPermanently,
                      onChanged: toggleCheckbox,
                      activeTrackColor: switchActiveTrackColor,
                      activeColor: switchActiveColor,
                      inactiveThumbColor: switchInactiveThumbColor,
                      inactiveTrackColor: switchInactiveTrackColor,
                    ),
                  ),
                ),

                Divider(color: dividerColor),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      config["internet_centered"] = !config["internet_centered"];
                      socket.sendXML('RefreshNetwork');
                      saveToSharedPrefs(config);
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                    tileColor: secondColor,
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: listTileSubTitlePaddingTop),
                      child: Text(S.of(context).theOverviewWillBeCenteredAroundThePlcDeviceConnected, style: TextStyle(color: fontColorMedium, fontSize: fontSizeListTileSubtitle * fontSizeFactor)
                      ),
                    ),
                    title: Text(
                        S.of(context).internetcentered,
                        style: TextStyle(fontSize: fontSizeListTileTitle* fontSizeFactor, color: fontColorDark),
                      ),

                    trailing: Switch(
                        value: config["internet_centered"],
                        //materialTapTargetSize: MaterialTapTargetSize,
                        onChanged: (value) {
                          setState(() {
                            config["internet_centered"] = value;
                            socket.sendXML('RefreshNetwork');
                            saveToSharedPrefs(config);
                          });
                        },
                        activeTrackColor: switchActiveTrackColor,
                        activeColor: switchActiveColor,
                        inactiveThumbColor: switchInactiveThumbColor,
                        inactiveTrackColor: switchInactiveTrackColor,
                      ),
                  ),
                ),

                Divider(color: dividerColor),
                GestureDetector(
                  onTap:() {
                    setState(() {
                      config["show_other_devices"] = !config["show_other_devices"];
                      socket.sendXML('RefreshNetwork');
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                    tileColor: secondColor,
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: listTileSubTitlePaddingTop),
                      child: Text(S.of(context).otherDevicesEgPcAreDisplayedInTheOverview, style: TextStyle(color: fontColorMedium, fontSize: fontSizeListTileSubtitle * fontSizeFactor)
                      ),
                    ),
                    title: Text(
                        S.of(context).showOtherDevices,
                        style: TextStyle(fontSize: fontSizeListTileTitle*fontSizeFactor, color: fontColorDark),
                      ),
                    trailing: Switch(
                        value: config["show_other_devices"],
                        onChanged: (value) {
                          setState(() {
                            config["show_other_devices"] = value;
                            socket.sendXML('RefreshNetwork');
                            saveToSharedPrefs(config);
                          });
                        },
                        activeTrackColor: switchActiveTrackColor,
                        activeColor: switchActiveColor,
                        inactiveThumbColor: switchInactiveThumbColor,
                        inactiveTrackColor: switchInactiveTrackColor,
                      ),

                  ),
                ),
                Divider(color: dividerColor, height: dividerTitleSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(
                    S.of(context).appearance,
                    style: TextStyle(fontSize: fontSizeSectionTitle * fontSizeFactor, color: fontColorLight),
                  )
                ]),
                Divider(color: dividerColor),
                GestureDetector(
                  onTap: () {
                    _mainColorPicker("Main color", "Accent color", "Light font color", "Dark font color");
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                    tileColor: secondColor,
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: listTileSubTitlePaddingTop),
                      child: Text(S.of(context).chooseMainColorAccentColorAndFontColors, style: TextStyle(color: fontColorMedium, fontSize: fontSizeListTileSubtitle * fontSizeFactor)
                      ),
                    ),
                    title: Text(
                        S.of(context).appColor,
                        style: TextStyle(fontSize: fontSizeListTileTitle * fontSizeFactor, color: fontColorDark),
                      ),

                    trailing: Text(config["theme"], style: TextStyle(fontSize: fontSizeListTileTitle * fontSizeFactor, color: fontColorDark)),
                  ),
                ),
                Divider(color: dividerColor),
                ListTile(
                  contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                  tileColor: secondColor,
                  title: Text(S.of(context).fontsize, style: TextStyle(fontSize: fontSizeListTileTitle * fontSizeFactor, color: fontColorDark),
                  ),
                  trailing: SizedBox( width: 150, height: 300, child: SpinBox(
                    cursorColor: mainColor,
                    min: 0.1,
                    max: 5.0,
                    step: 0.1,
                    acceleration: 0.1,
                    decimals: 1,
                    value: fontSizeFactor.toDouble(),
                    incrementIcon: Icon(Icons.add_circle, color: mainColor),
                    decrementIcon: Icon(Icons.remove_circle, color: mainColor),
                    decoration: InputDecoration(
                      focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: mainColor)),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: mainColor)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        fontSizeFactor = value;
                        config["font_size_factor"] = value;
                      });
                      saveToSharedPrefs(config);
                      AppBuilder.of(context).rebuild();
                    },
                  ),
                  ),
                ),
                Divider(color: dividerColor, height: dividerTitleSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(
                    S.of(context).network,
                    style: TextStyle(fontSize: fontSizeSectionTitle * fontSizeFactor, color: fontColorLight),
                  )
                ]),
                Divider(color: dividerColor),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      config["ignore_updates"] = !config["ignore_updates"];
                      socket.sendXML('Config');
                      saveToSharedPrefs(config);
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                    tileColor: secondColor,
                    title: Text(
                        S.of(context).ignoreUpdates,
                        style: TextStyle(fontSize: fontSizeListTileTitle * fontSizeFactor, color: fontColorDark),
                      ),
                    trailing: Switch(
                          value: config["ignore_updates"],
                          onChanged: (bool value) {
                            setState(() {
                              config["ignore_updates"] = !config["ignore_updates"];
                              socket.sendXML('Config');
                              saveToSharedPrefs(config);
                            });
                          },
                          activeTrackColor: switchActiveTrackColor,
                          activeColor: switchActiveColor,
                          inactiveThumbColor: switchInactiveThumbColor,
                          inactiveTrackColor: switchInactiveTrackColor,
                      ),

                  ),
                ),
                Divider(color: dividerColor),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      config["allow_data_collection"] = !config["allow_data_collection"];
                      socket.sendXML('Config');
                      saveToSharedPrefs(config);
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                    tileColor: secondColor,
                    title: Text(
                        S.of(context).recordTheTransmissionPowerOfTheDevicesAndTransmitIt,
                        style: TextStyle(fontSize: fontSizeListTileTitle*fontSizeFactor, color: fontColorDark),
                    ),
                    trailing: Switch(
                          value: config["allow_data_collection"],
                          onChanged: (bool value) {
                            setState(() {
                              config["allow_data_collection"] = !config["allow_data_collection"];
                              socket.sendXML('Config');
                              saveToSharedPrefs(config);
                            });
                          },
                          activeTrackColor: switchActiveTrackColor,
                          activeColor: switchActiveColor,
                          inactiveThumbColor: switchInactiveThumbColor,
                          inactiveTrackColor: switchInactiveTrackColor,
                    ),
                  ),
                ),
                Divider(color: dividerColor),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      config["windows_network_throttling_disabled"] = !config["windows_network_throttling_disabled"];
                      socket.sendXML('Config');
                      saveToSharedPrefs(config);
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                    tileColor: secondColor,
                    title: Text(
                        S.of(context).windowsNetworkThrottling,
                        style: TextStyle(fontSize: fontSizeListTileTitle* fontSizeFactor, color: fontColorDark),
                    ),
                    trailing: Switch(
                        value: !config["windows_network_throttling_disabled"],
                        onChanged: (value) {
                          setState(() {
                            config["windows_network_throttling_disabled"] = !value;
                            socket.sendXML('Config');
                            saveToSharedPrefs(config);
                          });
                        },
                        activeTrackColor: switchActiveTrackColor,
                        activeColor: switchActiveColor,
                        inactiveThumbColor: switchInactiveThumbColor,
                        inactiveTrackColor: switchInactiveTrackColor,
                    ),
                  ),
                ),
                Divider(color: dividerColor),
                ListTile(
                  contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                  tileColor: secondColor,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: !waitForNetworkPasswordResponse
                            ?2
                            :3,
                        child: TextFormField(
                          focusNode: myFocusNode,
                          initialValue: _newPw,
                          obscureText: _hiddenPw,
                          style: TextStyle(color: fontColorDark),
                          cursorColor: fontColorDark,
                          decoration: InputDecoration(
                            labelText: S.of(context).changePlcnetworkPassword,
                            labelStyle: TextStyle(color: fontColorDark),
                              hoverColor: mainColor.withOpacity(0.2),
                              contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              filled: true,
                              fillColor: secondColor.withOpacity(0.2),//myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: fontColorDark,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: fontColorDark,//Colors.transparent,
                                  //width: 2.0,
                                ),
                              ),
                            suffixIcon: _hiddenPw?
                            IconButton(
                              icon: Icon(Icons.visibility_off, color: fontColorDark,),
                              onPressed: (){
                                //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                setState(() {
                                  _hiddenPw = !_hiddenPw;
                                });
                              },
                            ):
                            IconButton(
                              icon: Icon(Icons.visibility, color: fontColorDark,),
                              onPressed: (){
                                //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                setState(() {
                                  _hiddenPw = !_hiddenPw;
                                });
                              },
                            ),
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

                      if(waitForNetworkPasswordResponse || networkPasswordResponseTrue || networkPasswordResponseFalse)
                        Spacer(),
                      if(waitForNetworkPasswordResponse)
                        CircularProgressIndicator(),
                      if(networkPasswordResponseTrue)
                        Icon(Icons.check_circle_outline, color: Colors.green),
                      if(networkPasswordResponseFalse)
                        Icon(Icons.close, color: fontColorDark),

                      Spacer(
                      ),
                      FlatButton(
                        height: 62,
                        hoverColor: mainColor.withOpacity(0.4),
                        color: mainColor.withOpacity(0.4),
                        onPressed: waitForNetworkPasswordResponse
                            ? null
                            : () async {

                          if(_deviceList.getNetworkListLength() == 0){
                            waitForNetworkPasswordResponse = false;
                            networkPasswordResponseFalse = true;
                            _errorDialog(context,S.of(context).networkPasswordErrorTitle,S.of(context).networkPasswordErrorBody + "\n\n" + S.of(context).networkPasswordErrorHint);

                          }

                          else {
                            socket.sendXML(
                                'SetNetworkPassword', newValue: _newPw,
                                valueType: "password",
                                mac: _deviceList
                                    .getLocal()
                                    .mac);
                            setState(() {
                              networkPasswordResponseTrue = false;
                              networkPasswordResponseFalse = false;
                              waitForNetworkPasswordResponse = true;
                            });
                            var response = await socket.myReceiveXML(
                                "SetNetworkPasswordStatus");
                            print(response);
                            if (response['status'] == "complete" &&
                                int.parse(response['total']) > 0 &&
                                int.parse(response['failed']) == 0) {
                              setState(() {
                                waitForNetworkPasswordResponse = false;
                                networkPasswordResponseTrue = true;
                              });
                            }
                            else {
                              _errorDialog(context, S
                                  .of(context)
                                  .networkPasswordErrorTitle, S
                                  .of(context)
                                  .networkPasswordErrorBody + "\n\n" + S
                                  .of(context)
                                  .networkPasswordErrorHint);
                              waitForNetworkPasswordResponse = false;
                              networkPasswordResponseFalse = true;
                            }
                          }
                        },
                        child: Text(
                          S.of(context).save, /*style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),*/
                        ),
                      )
                    ],
                  ),
                ),
                Divider(color: dividerColor),
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
          content: Stack(
            overflow: Overflow.visible,
            children: [
              Positioned.fill(
                top: -90,
                right: -35,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: secondColor,
                      child: Icon(Icons.close, color: fontColorDark),
                    ),
                  ),
                ),
              ),
              StatefulBuilder(
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
                                //config["theme"] = theme_devolo;
                                setTheme(theme_devolo["name"]);
                                config["theme"] = theme_devolo["name"];
                                saveToSharedPrefs(config);

                                // mainColor = theme_devolo["mainColor"];
                                // backgroundColor = theme_devolo["backgroundColor"];
                                // secondColor = theme_devolo["secondColor"];
                                // drawingColor = theme_devolo["drawingColor"];
                                // fontColorLight = theme_devolo["fontColorLight"];
                                // fontColorMedium = theme_devolo["fontColorMedium"];
                                // fontColorDark = theme_devolo["fontColorDark"];
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
                                setTheme(theme_dark["name"]);
                                config["theme"] = theme_dark["name"];
                                saveToSharedPrefs(config);

                                // mainColor = theme_dark["mainColor"];
                                // backgroundColor = theme_dark["backgroundColor"];
                                // secondColor = theme_dark["secondColor"];
                                // drawingColor = theme_dark["drawingColor"];
                                // fontColorLight = theme_dark["fontColorLight"];
                                // fontColorMedium = theme_dark["fontColorMedium"];
                                // fontColorDark = theme_dark["fontColorDark"];
                                AppBuilder.of(context).rebuild();
                              });
                            },
                          ),
                          new FlatButton(
                            minWidth: 200,
                            color: secondColor,
                            child: Column(
                              children: [
                                SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_devolo.PNG'))),
                                new Text(
                                  "Light Theme",
                                  style: TextStyle(color: fontColorDark),
                                ),
                              ],
                            ),
                            hoverColor: fontColorLight,
                            onPressed: () {
                              setState(() {
                                config["theme"] = theme_light["name"];
                                setTheme(theme_light["name"]);
                                saveToSharedPrefs(config);

                                // mainColor = theme_light["mainColor"];
                                // backgroundColor = theme_light["backgroundColor"];
                                // secondColor = theme_light["secondColor"];
                                // drawingColor = theme_light["drawingColor"];
                                // fontColorLight = theme_light["fontColorLight"];
                                // fontColorMedium = theme_light["fontColorMedium"];
                                // fontColorDark = theme_light["fontColorDark"];
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
                                config["theme"] = theme_highContrast["name"];
                                setTheme(theme_highContrast["name"]);
                                saveToSharedPrefs(config);

                                // mainColor = theme_highContrast["mainColor"];
                                // backgroundColor = theme_highContrast["backgroundColor"];
                                // secondColor = theme_highContrast["secondColor"];
                                // drawingColor = theme_highContrast["drawingColor"];
                                // fontColorLight = theme_highContrast["fontColorLight"];
                                // fontColorMedium = theme_highContrast["fontColorMedium"];
                                // fontColorDark = theme_highContrast["fontColorDark"];
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
            ],
          ),

        );
      },
    );
  }

  void _errorDialog(context, title, body) {

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: fontColorLight),
            ),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18 * fontSizeFactor),
            content: Stack(
              overflow: Overflow.visible,
              children: [
                Positioned(
                  top: -85,
                  right: -35,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: secondColor,
                        child: Icon(Icons.close, color: fontColorDark),
                      ),
                    ),
                  ),
                ),
                Text(body),
              ],
            ),
            actions: <Widget>[

            ],
          );
        });
  }
}
