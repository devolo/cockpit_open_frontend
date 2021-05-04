/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:convert';

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';

import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:shared_preferences/shared_preferences.dart';

class OverviewScreen extends StatefulWidget {
  OverviewScreen({Key key}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final networkIndex = 0;

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int numDevices = 0;
  Offset _lastTapDownPosition;
  DrawOverview _Painter;

  bool showingSpeeds = false;
  int pivotDeviceIndex = 0;

  FocusNode myFocusNode = new FocusNode();

  void getFromSharedPrefs() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic configTmp = prefs.get("config");
    print('Setting config from Prefs: ${configTmp}');
    config = json.decode(configTmp) as Map<String, dynamic>;
    print(config);
    S.load(Locale(config["language"], ''));
    fontSizeFactor = config["font_size_factor"];


    //config["theme"] = theme_dark["name"];
    AppBuilder.of(context).rebuild();
  }

  @override
  void initState() {
    getFromSharedPrefs();
    //dataHand();
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    final _deviceList = Provider.of<NetworkList>(context);
    socket.setDeviceList(_deviceList);
    _deviceList.selectedNetworkIndex = config["selected_network"];

        _Painter = DrawOverview(context, _deviceList, showingSpeeds, pivotDeviceIndex);

    print("drawing Overview...");

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: _handleTap,
          onTapDown: _handleTapDown,
          onLongPress: () => _handleLongPressStart(context),
          onLongPressUp: _handleLongPressEnd,
          child: Stack(
            children: [
              Center(
                child: CustomPaint(
                  painter: _Painter,
                  child: Container(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var networkIdx = 0; networkIdx < _deviceList.getNetworkListLength(); networkIdx++)
                    FlatButton(
                      textColor: networkIdx != _deviceList.selectedNetworkIndex ? secondColor : fontColorLight,
                      hoverColor: secondColor.withOpacity(0.3),
                      //color: networkIdx != _deviceList.selectedNetworkIndex? Colors.transparent: secondColor,
                      child: networkIdx == 0?
                      networkIdx != _deviceList.selectedNetworkIndex
                          ? Text("${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network}")
                          : Text(
                        "${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ):
                      networkIdx != _deviceList.selectedNetworkIndex
                          ? Text("${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network} ${networkIdx}")
                          : Text(
                              "${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network} ${networkIdx}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      onPressed: () {
                        _deviceList.selectedNetworkIndex = networkIdx;
                        config["selected_network"] = networkIdx;
                        saveToSharedPrefs(config);
                        AppBuilder.of(context).rebuild();
                      },
                    ),
                ],
              )
              //if(_deviceList.getNetworkListLength() > 1)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
              //       tooltip: S.of(context).previousNetwork,
              //       onPressed: () {
              //         print("back");
              //         setState(() {
              //           if(_deviceList.selectedNetworkIndex  > 0){
              //             _deviceList.selectedNetworkIndex --;
              //             //_currImage = optimizeImages[_index];
              //           }
              //         });
              //       },
              //     ),
              //     IconButton(
              //       icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              //       tooltip: S.of(context).nextNetwork,
              //       onPressed: () {
              //         print("forward");
              //         setState(() {
              //           if(_deviceList.selectedNetworkIndex < _deviceList.getNetworkListLength()-1){ // -1 to not switch
              //             _deviceList.selectedNetworkIndex++;
              //             //_currImage = optimizeImages[_index];
              //           }
              //         });
              //       },
              //     ),
              //   ],),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Warning! "UpdateCheck" and "RefreshNetwork" should only be triggered by a user interaction, not continously/automaticly
          setState(() {
            socket.sendXML('RefreshNetwork');
            AppBuilder.of(context).rebuild();
          });
        },
        tooltip: 'Neu laden',
        backgroundColor: secondColor,
        foregroundColor: fontColorDark,
        hoverColor: fontColorLight,
        child: Icon(Icons.refresh, color: mainColor,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _handleTapDown(TapDownDetails details) {
    //print('entering tabDown');
    _lastTapDownPosition = details.localPosition;
  }

  void _handleTap(TapUpDetails details) {
    //print('entering dialog....');
    int index = 0;
    Device hitDevice;
    String hitDeviceName;
    String hitDeviceType;
    String hitDeviceSN;
    String hitDeviceMT;
    String hitDeviceVersion;
    String hitDeviceVersionDate;
    String hitDeviceIp;
    String hitDeviceMac;
    bool hitDeviceAtr;
    bool hitDeviceisLocal;
    bool hitDeviceWebinterface;
    bool hitDeviceIdentify;

    final socket = Provider.of<dataHand>(context, listen: false);
    final deviceList = Provider.of<NetworkList>(context, listen: false);

    print(networkOffsetList);

    networkOffsetList.asMap().forEach((i, networkIconOffset) {
      //for (Offset networkIconOffset in _Painter.networkOffsets) {
      //Offset absoluteOffset = Offset(networkIconOffset.dx + (_Painter.screenWidth / 2), networkIconOffset.dy + (_Painter.screenHeight / 2));
      //print("NetworkIcon: " + networkIconOffset.toString());
      //print("Local: " + details.localPosition.toString());
      //print("absolute: " + absoluteOffset.toString());

      //test if network got hit
      if (_Painter.isPointInsideNetworkIcon(details.localPosition, networkIconOffset, _Painter.hn_circle_radius)) {
        print("Hit Network #" + i.toString());
        setState(() {
          deviceList.selectedNetworkIndex = i;
        });
      }
    });

    for (Offset deviceIconOffset in deviceIconOffsetList) {
      if (index > _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2), deviceIconOffset.dy + (_Painter.screenHeight / 2));

      //test if device got hit
      if (_Painter.isPointInsideCircle(details.localPosition, absoluteOffset, _Painter.hn_circle_radius)) {
        print("Hit icon #" + index.toString());

        hitDevice = deviceList.getDeviceList()[index];
        hitDeviceName = deviceList.getDeviceList()[index].name;
        hitDeviceType = deviceList.getDeviceList()[index].type;
        hitDeviceSN = deviceList.getDeviceList()[index].serialno;
        hitDeviceMT = deviceList.getDeviceList()[index].MT;
        hitDeviceVersion = deviceList.getDeviceList()[index].version;
        hitDeviceVersionDate = deviceList.getDeviceList()[index].version_date;
        hitDeviceIp = deviceList.getDeviceList()[index].ip;
        hitDeviceMac = deviceList.getDeviceList()[index].mac;
        hitDeviceAtr = deviceList.getDeviceList()[index].attachedToRouter;
        hitDeviceisLocal = deviceList.getDeviceList()[index].isLocalDevice;
        hitDeviceWebinterface = deviceList.getDeviceList()[index].webinterfaceAvailable;
        hitDeviceIdentify = deviceList.getDeviceList()[index].identifyDeviceAvailable;

        String _newName = hitDeviceName;

        showDialog<void>(
          context: context,
          barrierDismissible: true, // user doesn't need to tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: backgroundColor.withOpacity(0.9),
              contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
              title: SelectableText(
                S.of(context).deviceinfo,
                style: TextStyle(color: Colors.white),
                textScaleFactor: fontSizeFactor,
              ),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 23,
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
                  SingleChildScrollView(
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Table(
                          defaultColumnWidth: FixedColumnWidth(300.0 * fontSizeFactor),
                          children: [
                            TableRow(children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: SelectableText(
                                  'Name:   ',
                                  style: TextStyle(height: 2),
                                ),
                              ),
                              TextFormField(
                                initialValue: _newName,
                                focusNode: myFocusNode,
                                style: TextStyle(color: fontColorLight),
                                cursorColor: fontColorLight,
                                decoration: InputDecoration(
                                  hoverColor: secondColor.withOpacity(0.2),
                                  contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: secondColor.withOpacity(0.2),//myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: fontColorLight,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: fontColorLight,//Colors.transparent,
                                      //width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.edit_outlined, color: fontColorLight,),
                                    onPressed: (){
                                      //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                      if(_newName != hitDeviceName)
                                        _showEditAlert(context, socket, hitDeviceMac, _newName);
                                    },
                                  ),
                                ),
                                onChanged: (value) => (_newName = value),
                                onEditingComplete: () {
                                  if(_newName != hitDeviceName)
                                    _showEditAlert(context, socket, hitDeviceMac, _newName);
                                  //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                },
                                onTap: (){
                                  setState(() {
                                    myFocusNode.hasFocus;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return S.of(context).pleaseEnterDeviceName;
                                  }
                                  return null;
                                },
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SelectableText(
                                      "${S.of(context).type}   ",
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: SelectableText(hitDeviceType),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SelectableText(
                                      "${S.of(context).serialNumber}   ",
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: SelectableText(hitDeviceSN),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SelectableText(
                                    "${S.of(context).mtnumber}   ",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: SelectableText(hitDeviceMT.substring(2)),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SelectableText(
                                    "${S.of(context).version}   ",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: SelectableText('$hitDeviceVersion ($hitDeviceVersionDate)'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SelectableText(
                                    "${S.of(context).ipaddress}   ",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: SelectableText(hitDeviceIp),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SelectableText(
                                    "${S.of(context).macaddress}   ",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: SelectableText(hitDeviceMac),
                              ),
                            ]),

                          ],
                        ),
                        //Text('Rates: ' +hitDeviceRx),
                        Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                IconButton(

                                  icon: Icon(
                                    Icons.public,
                                  ),
                                  //tooltip: S.of(context).launchWebinterface,
                                  disabledColor: fontColorNotAvailable,
                                  color: fontColorLight,
                                  hoverColor: fontColorLight.withAlpha(50),
                                  iconSize: 24.0 * fontSizeFactor,
                                  onPressed: !hitDeviceWebinterface ? null : () => launchURL(hitDeviceIp),
                                  mouseCursor: !hitDeviceWebinterface ? null : SystemMouseCursors.click,



                                ),
                                Text(
                                  S.of(context).launchWebinterface,
                                  style: TextStyle(fontSize: 14, color: !hitDeviceWebinterface ? fontColorNotAvailable: fontColorLight),
                                  textScaleFactor: fontSizeFactor,
                                  textAlign: TextAlign.center,

                                )
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.lightbulb,
                                    ),
                                    //tooltip: S.of(context).identifyDevice,
                                    disabledColor: fontColorNotAvailable,
                                    color: fontColorLight,
                                    hoverColor: fontColorLight.withAlpha(50),
                                    iconSize: 24.0 * fontSizeFactor,
                                    onPressed: !hitDeviceIdentify ? null : () => socket.sendXML('IdentifyDevice', mac: hitDeviceMac),
                                    mouseCursor: !hitDeviceIdentify ? null : SystemMouseCursors.click,

                                ),
                                Text(
                                  S.of(context).identifyDevice,
                                  style: TextStyle(fontSize: 14, color: !hitDeviceIdentify ? fontColorNotAvailable : fontColorLight),
                                  textScaleFactor: fontSizeFactor,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.find_in_page,
                                      color: fontColorLight,
                                    ),
                                    //tooltip: S.of(context).showManual,
                                    hoverColor: fontColorLight.withAlpha(50),
                                    iconSize: 24.0 * fontSizeFactor,
                                    onPressed: () async {
                                      socket.sendXML('GetManual', newValue: hitDeviceMT, valueType: 'product', newValue2: 'de', valueType2: 'language');
                                      var response = await socket.recieveXML(["GetManualResponse"]);
                                      setState(() {
                                        openFile(response['filename']);
                                      });
                                    }),
                                Text(
                                  S.of(context).showManual,
                                  style: TextStyle(fontSize: 14, color: fontColorLight),
                                  textScaleFactor: fontSizeFactor,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.upload_file,
                                    color: fontColorLight,
                                    semanticLabel: "update",
                                  ),
                                  //tooltip: S.of(context).factoryReset,
                                  hoverColor: fontColorLight.withAlpha(50),
                                  iconSize: 24.0 * fontSizeFactor,
                                  onPressed: () => _handleCriticalActions(context, socket, 'ResetAdapterToFactoryDefaults', hitDevice),
                                ),
                                Text(
                                  S.of(context).factoryReset,
                                  style: TextStyle(fontSize: 14, color: fontColorLight),
                                  textScaleFactor: fontSizeFactor,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),

                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: fontColorLight,
                                  ),
                                  //tooltip: S.of(context).deleteDevice,
                                  hoverColor: fontColorLight.withAlpha(50),
                                  iconSize: 24.0 * fontSizeFactor,
                                  onPressed: () => _handleCriticalActions(context, socket, 'RemoveAdapter', hitDevice),
                                ),
                                Text(
                                  S.of(context).deleteDevice,
                                  style: TextStyle(fontSize: 14, color: fontColorLight),
                                  textScaleFactor: fontSizeFactor,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ), //ToDo Delete Device see wiki
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(
              //       Icons.check_circle_outline,
              //       color: fontColorLight,
              //     ), //Text('Bestätigen'),
              //     tooltip: S.of(context).confirm,
              //     iconSize: 35 * fontSizeFactor,
              //     onPressed: () {
              //       // Critical things happening here
              //       socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
              //       Navigator.maybeOf(context).pop();
              //     },
              //   ),
              // ],
            );
          },
        );
      }
      index++;
    }
  }

  //ToDo UI doesn't change
  void _handleLongPressStart(context) {
    RenderBox renderBox = context.findRenderObject();

    int index = 0;
    String hitDeviceName;
    for (Offset deviceIconOffset in deviceIconOffsetList) {
      if (index > _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2), deviceIconOffset.dy + (_Painter.screenHeight / 2));

      if (_Painter.isPointInsideCircle(_lastTapDownPosition, absoluteOffset, _Painter.hn_circle_radius)) {
        print("Long press on icon #" + index.toString());

        final deviceList = Provider.of<NetworkList>(context, listen: false);
        hitDeviceName = deviceList.getDeviceList()[index].name;

        setState(() {
          //if (_Painter.showSpeedsPermanently && index == _Painter.pivotDeviceIndex) {
          if (config["show_speeds_permanent"]) {
            //_Painter.showingSpeeds = !_Painter.showingSpeeds;
            showingSpeeds = true;
            config["show_speeds"] = true;
          } else {
            //_Painter.showingSpeeds = true;
            showingSpeeds = true;
            config["show_speeds"] = true;
          }
          //_Painter.pivotDeviceIndex = index;
          pivotDeviceIndex = index;

          //do not update pivot device when the "router device" is long pressed
          print('Pivot on longPress:' + _Painter.pivotDeviceIndex.toString());
          print('sowingSpeed on longPress:' + showingSpeeds.toString());
        });
        return;
      }
      index++;
    }
  }

  void _handleLongPressEnd() {
    //print("long press up");

    setState(() {
      if (!config["show_speeds_permanent"]) {
        showingSpeeds = false;
        config["show_speeds"] = false;
        _Painter.pivotDeviceIndex = 0;
        pivotDeviceIndex = 0;
      } else {
        if (!showingSpeeds) _Painter.pivotDeviceIndex = 0;
      }
    });
  }

  void _handleCriticalActions(context, socket, messageType, Device hitDevice) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              S.of(context).confirmAction,//messageType,
              style: TextStyle(color: fontColorLight),
            ),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white),
            content: Stack(
              overflow: Overflow.visible,
              children: [
                hitDevice.attachedToRouter
                    ? Text(
                        S.of(context).pleaseConfirmActionAttentionYourRouterIsConnectedToThis,
                        textScaleFactor: fontSizeFactor,
                      )
                    : Text(S.of(context).pleaseConfirmAction, textScaleFactor: fontSizeFactor),
                Positioned(
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
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: fontColorLight,
                      size: 35 * fontSizeFactor,
                    ),
                    Text(S.of(context).confirm, style: TextStyle(color: fontColorLight),),
                  ],
                ),
                onPressed: () {
                  // Critical things happening here
                  socket.sendXML(messageType, mac: hitDevice.mac);
                  Navigator.maybeOf(context).pop();
                },
              ),
              Spacer(),
              FlatButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: fontColorLight,
                        size: 35 * fontSizeFactor,
                      ),
                      Text(S.of(context).cancel, style: TextStyle(color: fontColorLight),),
                    ],
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context).pop();
                  }),
            ],
          );
        });
  }

  void _showEditAlert(context, socket, hitDeviceMac, _newName) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Confirm",
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
                    Text("Do you really want to rename this device?"),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: fontColorLight,
                      size: 35 * fontSizeFactor,
                    ),
                    Text(S.of(context).confirm, style: TextStyle(color: fontColorLight),),
                  ],
                ),
                autofocus: true,
                onPressed: () {
                  // Critical things happening here
                  socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                  Navigator.maybeOf(context).pop();
                  setState(() {
                    socket.sendXML('RefreshNetwork');
                  });
                },
              ),
              FlatButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: fontColorLight,
                        size: 35 * fontSizeFactor,
                      ),
                      Text(S.of(context).cancel, style: TextStyle(color: fontColorLight),),
                    ],
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context).pop();
                  }),
            ],
          );
        });
  }
}
