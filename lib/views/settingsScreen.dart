/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:async';
import 'dart:ui';
import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/alertDialogs.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/buttons.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/views/logsScreen.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';


class SettingsScreen extends StatefulWidget {
  SettingsScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  DrawOverview? painter;

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
  Color switchActiveTrackColor = devoloGreen.withOpacity(0.4);
  Color switchActiveThumbColor = devoloGreen;
  Color switchInactiveThumbColor = Colors.white;
  Color switchInactiveTrackColor = Color(0x61000000);

  /* ===========  =========== */
  String? _newPw;
  bool _hiddenPw = true;
  var _dropNetwork;
  bool _isButtonDisabled = true;
  String? _zipfilename;
  String? _htmlfilename;
  var response;
  var waitForNetworkPasswordResponse = false;
  var networkPasswordResponseTrue = false;
  var networkPasswordResponseFalse = false;

  final _scrollController = ScrollController();
  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  var maxLength = 12;
  var minLength = 8;
  var textLength = 0;

  var _formKey = GlobalKey<FormState>();


  void toggleCheckbox(bool value) {
    setState(() {
      config["show_speeds_permanent"] = value;
      saveToSharedPrefs(config);
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
    DataHand socket = Provider.of<DataHand>(context);
    var _deviceList = Provider.of<NetworkList>(context);

    fontSize = context.watch<FontSize>();

    var width = MediaQuery.of(context).size.width;

    if(!socket.connected) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        while(Navigator.canPop(context)){ // Navigator.canPop return true if can pop
          Navigator.pop(context);
        }
        //Navigator.of(context).popUntil((route) => route.isActive);
      });
    }

    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: paddingBarTop),
        controller: _scrollController, // <---- Here, the controller
        //isAlwaysShown: true, // <---- Required

        child: Stack(
          children: [
          IgnorePointer(
          ignoring: socket.connected ? false: true,
              child: Padding(
                padding: EdgeInsets.only(left: width/7, right: width/7),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).settings,
                      style: TextStyle(fontSize: fontSizeAppBarTitle * fontSize.factor, color: fontColorOnBackground),
                    ),
                    Divider(color: dividerColor, height: dividerTitleSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      Text(
                        S.of(context).general,
                        style: TextStyle(fontSize: fontSizeSectionTitle * fontSize.factor, color: fontColorOnBackground),
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
                          child: Text(S.of(context).dataRatesArePermanentlyDisplayedInTheOverview, style: TextStyle(color: fontColorOnSecond, fontSize: fontSizeListTileSubtitle * fontSize.factor, fontFamily: 'OpenSans')),
                        ),
                        title: Text(S.of(context).enableShowingSpeeds, style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond), semanticsLabel: "Show Speeds"),
                        trailing: Switch(
                          value: config["show_speeds_permanent"],
                          //widget.painter.showSpeedsPermanently,
                          onChanged: toggleCheckbox,
                          activeTrackColor: switchActiveTrackColor,
                          activeColor: switchActiveThumbColor,
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
                          child: Text(S.of(context).theOverviewWillBeCenteredAroundThePlcDeviceConnected, style: TextStyle(color: fontColorOnSecond, fontSize: fontSizeListTileSubtitle * fontSize.factor)),
                        ),
                        title: Text(
                          S.of(context).internetCentered,
                          style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond),
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
                          activeColor: switchActiveThumbColor,
                          inactiveThumbColor: switchInactiveThumbColor,
                          inactiveTrackColor: switchInactiveTrackColor,
                        ),
                      ),
                    ),
                    Divider(color: dividerColor),
                    GestureDetector(
                      onTap: () {
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
                          child: Text(S.of(context).otherDevicesEgPcAreDisplayedInTheOverview, style: TextStyle(color: fontColorOnSecond, fontSize: fontSizeListTileSubtitle * fontSize.factor)),
                        ),
                        title: Text(
                          S.of(context).showOtherDevices,
                          style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond),
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
                          activeColor: switchActiveThumbColor,
                          inactiveThumbColor: switchInactiveThumbColor,
                          inactiveTrackColor: switchInactiveTrackColor,
                        ),
                      ),
                    ),
                    Divider(color: dividerColor, height: dividerTitleSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      Text(
                        S.of(context).appearance,
                        style: TextStyle(fontSize: fontSizeSectionTitle * fontSize.factor, color: fontColorOnBackground),
                      )
                    ]),
                    Divider(color: dividerColor),
                    GestureDetector(
                      onTap: () {
                        //_mainColorPicker("Main color", "Accent color", "Light font color", "Dark font color");
                        _themeDialog("title1");
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                        tileColor: secondColor,
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: listTileSubTitlePaddingTop),
                          child: Text(S.of(context).chooseTheAppTheme, style: TextStyle(color: fontColorOnSecond, fontSize: fontSizeListTileSubtitle * fontSize.factor)),
                        ),
                        title: Text(
                          S.of(context).appTheme,
                          style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text(config["theme"], style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond)),
                        ),
                      ),
                    ),
                    Divider(color: dividerColor),
                    ListTile(
                      contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                      tileColor: secondColor,
                      title: Text(
                        S.of(context).fontSize,
                        style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond),
                      ),
                      trailing: SizedBox(
                          width: 170,
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 23.5,
                                        width: 50,
                                        child: TextButton(
                                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color?>(fontColorOnSecond.withOpacity(0.33))),
                                          onPressed: () {
                                            setState(() {
                                              fontSize.factor = 0.9;
                                              config["font_size_factor"] = 0.9;
                                            });
                                            saveToSharedPrefs(config);
                                            AppBuilder.of(context)!.rebuild();
                                          },
                                          child: Icon(Icons.text_format, size: 23, color: fontColorOnSecond,),
                                        ),
                                    )
                                  ]),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 29.0,
                                        width: 50,
                                        child: TextButton(
                                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color?>(fontColorOnSecond.withOpacity(0.33))),
                                          onPressed: () {
                                            setState(() {
                                              fontSize.factor = 1.1;
                                              config["font_size_factor"] = 1.1;
                                            });
                                            saveToSharedPrefs(config);
                                            AppBuilder.of(context)!.rebuild();
                                          },
                                          child: Icon(Icons.text_format, size: 29, color: fontColorOnSecond,),
                                        ),
                                    )
                                ]),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 36.0,
                                          width: 55,
                                          child: TextButton(
                                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color?>(fontColorOnSecond.withOpacity(0.33))),
                                          onPressed: () {
                                            setState(() {
                                              fontSize.factor = 1.4;
                                              config["font_size_factor"] = 1.4;
                                            });
                                            saveToSharedPrefs(config);
                                            AppBuilder.of(context)!.rebuild();
                                          },
                                          child: Icon(Icons.text_format, size: 38, color: fontColorOnSecond,),
                                        ),
                                      )
                                ]),
                              ],
                            ),
                          )
                          ),
                    ),
                    Divider(color: dividerColor, height: dividerTitleSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      Text(
                        S.of(context).network,
                        style: TextStyle(fontSize: fontSizeSectionTitle * fontSize.factor, color: fontColorOnBackground),
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
                          style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond),
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
                          activeColor: switchActiveThumbColor,
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
                          style: TextStyle(fontSize: fontSizeListTileTitle * fontSize.factor, color: fontColorOnSecond),
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
                          activeColor: switchActiveThumbColor,
                          inactiveThumbColor: switchInactiveThumbColor,
                          inactiveTrackColor: switchInactiveTrackColor,
                        ),
                      ),
                    ),
                    Divider(color: dividerColor),
                    if(_deviceList.getNetworkListLength() != 0)
                    ListTile(
                      contentPadding: EdgeInsets.only(top: listTilePaddingContentTop, bottom: listTilePaddingContentBottom, left: listTilePaddingContentLeft, right: listTilePaddingContentRight),
                      tileColor: secondColor,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: !waitForNetworkPasswordResponse ? 2 : 3,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                focusNode: myFocusNode,
                                initialValue: _newPw,
                                obscureText: _hiddenPw,
                                maxLength: maxLength,
                                //maxLengthEnforcement: MaxLengthEnforcement.none,
                                style: TextStyle(color: fontColorOnSecond, fontSize: fontSizeListTileSubtitle * fontSize.factor),
                                cursorColor: fontColorOnSecond,
                                decoration: InputDecoration(
                                  counterText: "",
                                  suffixText: '${textLength.toString()}/${maxLength.toString()}',
                                  labelText: S.of(context).changePlcNetworkPassword,
                                  labelStyle: TextStyle(color: fontColorOnSecond, fontSize: fontSizeListTileSubtitle * fontSize.factor,),
                                  hoverColor: mainColor.withOpacity(0.2),
                                  contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: secondColor.withOpacity(0.2),
                                  //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: fontColorOnSecond,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: fontColorOnSecond, //Colors.transparent,
                                      //width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: _hiddenPw
                                      ? IconButton(

                                          icon: Icon(
                                            DevoloIcons.devolo_UI_visibility_off,
                                            color: fontColorOnSecond,
                                          ),
                                          onPressed: () {
                                            //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                            setState(() {
                                              _hiddenPw = !_hiddenPw;
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            DevoloIcons.devolo_UI_visibility,
                                            color: fontColorOnSecond,
                                          ),
                                          onPressed: () {
                                            //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                            setState(() {
                                              _hiddenPw = !_hiddenPw;
                                            });
                                          },
                                        ),
                                ),
                                onChanged: (value) {
                                  _newPw = value;
                                  setState(() {
                                    textLength = value.length;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                  return S.of(context).pleaseEnterPassword;
                                }
                                  if(value.length < minLength) {
                                    return S.of(context).passwordMustBeGreaterThan8Characters;
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),


                          //Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              width: 230,
                              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: secondColor.withOpacity(0.2), border: Border.all(color: fontColorOnSecond)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    value: _dropNetwork == null? _dropNetwork=_deviceList.getNetworkNames()[0]: _dropNetwork,
                                    dropdownColor: secondColor,
                                    style: TextStyle(fontSize: fontSizeListTileSubtitle * fontSize.factor, color: fontColorOnSecond),
                                    icon: Icon(
                                      DevoloIcons.ic_arrow_drop_down_24px,
                                      color: fontColorOnSecond,
                                    ),
                                    items: _deviceList.getNetworkNames().map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _dropNetwork = value!;
                                        logger.d("Dropdown: $value");
                                      });
                                    }
                                    ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),child:
                            Row(
                              children: [
                              //if(waitForNetworkPasswordResponse || networkPasswordResponseTrue || networkPasswordResponseFalse)
                                //Spacer(),
                              if(waitForNetworkPasswordResponse)
                                CircularProgressIndicator(color: fontColorOnSecond,),
                              if(networkPasswordResponseTrue)
                                Icon(DevoloIcons.devolo_UI_check_fill, color: devoloGreen),
                              if(networkPasswordResponseFalse)
                                Icon(DevoloIcons.devolo_UI_cancel_fill, color: fontColorOnSecond),
                            ],),
                          ),

                          // buttonstyle is added manually
                          TextButton(
                            child: Text(
                              S.of(context).change,
                              style: TextStyle(fontSize: dialogContentTextFontSize, color: fontColorOnMain),
                              textScaleFactor: fontSize.factor,
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                    if (states.contains(MaterialState.hovered)) {
                                      return devoloGreen.withOpacity(hoverOpacity);
                                    } else if (states.contains(MaterialState.pressed)) {
                                      return devoloGreen.withOpacity(activeOpacity);
                                    }
                                    return devoloGreen;
                                  },
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    )
                                )
                            ), onPressed:
                            waitForNetworkPasswordResponse
                                ? null
                                : () async {
                              if(_formKey.currentState!.validate()){
                                if (_deviceList.getNetworkListLength() == 0) {
                                  waitForNetworkPasswordResponse = false;
                                  networkPasswordResponseFalse = true;
                                  errorDialog(context, S.of(context).networkPasswordErrorTitle, S.of(context).networkPasswordErrorBody + "\n\n" + S.of(context).networkPasswordErrorHint,fontSize);
                                } else {
                                  int index = _deviceList.getNetworkNames().indexWhere((element) => element == _dropNetwork);
                                  socket.sendXML('SetNetworkPassword', newValue: _newPw, valueType: "password", mac: _deviceList.getLocalDevice(index)!.mac);
                                  setState(() {
                                    networkPasswordResponseTrue = false;
                                    networkPasswordResponseFalse = false;
                                    waitForNetworkPasswordResponse = true;
                                  });
                                  var response = await socket.receiveXML("SetNetworkPasswordStatus");
                                  if (response!['status'] == "complete" && int.parse(response['total']) > 0 && int.parse(response['failed']) == 0) {
                                    setState(() {
                                      waitForNetworkPasswordResponse = false;
                                      networkPasswordResponseTrue = true;
                                    });
                                  } else {
                                    errorDialog(context, S.of(context).networkPasswordErrorTitle, S.of(context).networkPasswordErrorBody + "\n\n" + S.of(context).networkPasswordErrorHint,fontSize);
                                    waitForNetworkPasswordResponse = false;
                                    networkPasswordResponseFalse = true;
                                  }
                                }
                              }else{
                                logger.d("validation failed");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    if(_deviceList.getNetworkListLength() != 0)
                    Divider(color: dividerColor),
                    Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                      IconButton(
                        iconSize: 30 * fontSize.factor,
                        icon: Icon(DevoloIcons.ic_view_list_24px),
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
          if(!socket.connected)
              new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: new Container(
                  decoration: new BoxDecoration(color: Colors.grey[200]!.withOpacity(0.1)),
              ),
            ),
            if(!socket.connected)
              Center(
                child: AlertDialog(
                  backgroundColor: backgroundColor,
                  //titleTextStyle: TextStyle(color: fontColorOnMain),
                  //contentTextStyle: TextStyle(color: fontColorOnMain),
                  titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
                  contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                  title: Text(S.of(context).noconnection),
                  content:  Text(S.of(context).noconnectionbody),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _themeDialog(String title1) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              getCloseButton(context),
              Text(
                S.of(context).appTheme,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          titleTextStyle: TextStyle(color: fontColorOnBackground,fontSize: dialogTitleTextFontSize * fontSize.factor),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              var width = MediaQuery.of(context).size.width;
              return SingleChildScrollView(
                child: Container(
                  width: width - 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          new TextButton(
                            child: Column(
                              children: [
                                SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_devolo.PNG'))),
                                new Text(
                                  "Standard Theme",
                                  style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<
                                  Color?>(
                                    (states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return fontColorOnBackground.withOpacity(0.3);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                //config["theme"] = theme_devolo;
                                setTheme(theme_devolo["name"]);
                                config["theme"] = theme_devolo["name"];
                                saveToSharedPrefs(config);
                                AppBuilder.of(context)!.rebuild();
                              });
                            },
                          ),
                          new TextButton(
                            child: Column(
                              children: [
                                SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_dark.PNG'))),
                                new Text(
                                  "Dark Theme",
                                  style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<
                                  Color?>(
                                    (states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return fontColorOnBackground.withOpacity(0.3);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                setTheme(theme_dark["name"]);
                                config["theme"] = theme_dark["name"];
                                saveToSharedPrefs(config);
                                AppBuilder.of(context)!.rebuild();
                              });
                            },
                          ),
                          new TextButton(
                            child: Column(
                              children: [
                                SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_light.PNG'))),
                                new Text(
                                  "Light Theme",
                                  style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<
                                  Color?>(
                                    (states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return fontColorOnBackground.withOpacity(0.3);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                config["theme"] = theme_light["name"];
                                setTheme(theme_light["name"]);
                                saveToSharedPrefs(config);
                                AppBuilder.of(context)!.rebuild();
                              });
                            },
                          ),
                          new TextButton(
                            child: Column(
                              children: [
                                SizedBox(width: 200, height: 130, child: Image(image: AssetImage('assets/theme_images/theme_highContrast.PNG'))),
                                new Text(
                                  "High Contrast Theme",
                                  style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<
                                  Color?>(
                                    (states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return fontColorOnBackground.withOpacity(0.3);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                config["theme"] = theme_highContrast["name"];
                                setTheme(theme_highContrast["name"]);
                                saveToSharedPrefs(config);
                                AppBuilder.of(context)!.rebuild();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
