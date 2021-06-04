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
  OverviewScreen({Key? key}) : super(key: key);

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
  late Offset _lastTapDownPosition;
  late DrawOverview _Painter;

  bool showingSpeeds = false;
  int pivotDeviceIndex = 0;

  bool _changeNameLoading = false;

  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<DataHand>(context);
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
                      child: networkIdx == 0
                          ? networkIdx != _deviceList.selectedNetworkIndex
                              ? Text("${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network}")
                              : Text(
                                  "${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                          : networkIdx != _deviceList.selectedNetworkIndex
                              ? Text("${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network} ${networkIdx}")
                              : Text(
                                  "${_deviceList.getNetworkType(networkIdx)} ${S.of(context).network} ${networkIdx}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                      onPressed: () {
                        _deviceList.selectedNetworkIndex = networkIdx;
                        config["selected_network"] = networkIdx;
                        saveToSharedPrefs(config);
                        AppBuilder.of(context)!.rebuild();
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
            AppBuilder.of(context)!.rebuild();
          });
        },
        tooltip: 'Neu laden',
        backgroundColor: secondColor,
        foregroundColor: fontColorDark,
        hoverColor: fontColorLight,
        child: Icon(
          Icons.refresh,
          color: mainColor,
        ),
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
    String hitDeviceVDSLprofile;
    List<String> hitDeviceVDSLList;
    String hitDeviceVDSLmode;

    String _vdslProfile;
    bool _vdslModeAutomatic = true;

    final socket = Provider.of<DataHand>(context, listen: false);
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
        hitDeviceVDSLmode = deviceList.getDeviceList()[index].mode_vdsl;
        hitDeviceVDSLprofile = deviceList.getDeviceList()[index].selected_vdsl;
        hitDeviceVDSLList = deviceList.getDeviceList()[index].supported_vdsl;

        String _newName = hitDeviceName;
        _vdslProfile = hitDeviceVDSLprofile;

        showDialog<void>(
          context: context,
          barrierDismissible: true, // user doesn't need to tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: backgroundColor.withOpacity(0.9),
              contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
              title: Column(
                children: [
                  getCloseButton(context),
                  SelectableText(
                    S.of(context).deviceinfo,
                    style: TextStyle(color: Colors.white),
                    textScaleFactor: fontSizeFactor,
                  ),
                ],
              ),
              titlePadding: EdgeInsets.all(2),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 23,
              ),
              content: SingleChildScrollView(
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
                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                if (_changeNameLoading)
                                  CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(secondColor),
                                    strokeWidth: 2.0,
                                  ),
                                SizedBox(width: 25),
                                SelectableText(
                                  'Name:   ',
                                  style: TextStyle(height: 2),
                                ),
                              ]),
                              TextFormField(
                                initialValue: _newName,
                                focusNode: myFocusNode,
                                style: TextStyle(color: fontColorLight),
                                cursorColor: fontColorLight,
                                decoration: InputDecoration(
                                  hoverColor: secondColor.withOpacity(0.2),
                                  contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: secondColor.withOpacity(0.2),
                                  //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
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
                                      color: fontColorLight, //Colors.transparent,
                                      //width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: fontColorLight,
                                    ),
                                    onPressed: () async {
                                      if (_newName != hitDeviceName) {
                                        bool confResponse = await _confirmDialog(context, S.of(context).deviceNameDialogTitle, S.of(context).deviceNameDialogBody);
                                        if (confResponse) {
                                          _changeNameLoading = true;
                                          socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                          var response = await socket.myReceiveXML("SetAdapterNameStatus");
                                          if (response!['result'] == "ok") {
                                            hitDeviceName = _newName;
                                            await Future.delayed(const Duration(seconds: 1), () {});
                                            socket.sendXML('RefreshNetwork');

                                            //setState(() {
                                            //   socket.sendXML('RefreshNetwork');
                                            //});
                                          } else if (response['result'] == "device_not_found") {
                                            _errorDialog(context, S.of(context).deviceNameErrorTitle, S.of(context).deviceNotFoundDeviceName + "\n\n" + S.of(context).deviceNotFoundHint);
                                          } else if (response['result'] != "ok") {
                                            _errorDialog(context, S.of(context).deviceNameErrorTitle, S.of(context).deviceNameErrorBody);
                                          }

                                          _changeNameLoading = false;
                                        }
                                      }
                                    },
                                  ),
                                ),
                                onChanged: (value) => (_newName = value),
                                onEditingComplete: () async {
                                  if (_newName != hitDeviceName) {
                                    bool confResponse = await _confirmDialog(context, S.of(context).deviceNameDialogTitle, S.of(context).deviceNameDialogBody);
                                    if (confResponse) {
                                      _changeNameLoading = true;
                                      socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                      var response = await socket.myReceiveXML("SetAdapterNameStatus");
                                      if (response!['result'] == "ok") {
                                        hitDeviceName = _newName;
                                        await Future.delayed(const Duration(seconds: 1), () {});
                                        socket.sendXML('RefreshNetwork');

                                        //setState(() {
                                        //   socket.sendXML('RefreshNetwork');
                                        //});
                                      } else if (response['result'] == "timeout") {
                                        _errorDialog(context, S.of(context).deviceNameErrorTitle, S.of(context).deviceNameErrorBody);
                                      } else if (response['result'] == "device_not_found") {
                                        _errorDialog(context, S.of(context).deviceNameErrorTitle, S.of(context).deviceNotFoundDeviceName + "\n\n" + S.of(context).deviceNotFoundHint);
                                      }

                                      _changeNameLoading = false;
                                    }
                                  }
                                },
                                onTap: () {
                                  setState(() {
                                    myFocusNode.hasFocus;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
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
                                  mouseCursor: !hitDeviceWebinterface ? SystemMouseCursors.basic : SystemMouseCursors.click,
                                ),
                                Text(
                                  S.of(context).launchWebinterface,
                                  style: TextStyle(fontSize: 14, color: !hitDeviceWebinterface ? fontColorNotAvailable : fontColorLight),
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
                                  onPressed: !hitDeviceIdentify
                                      ? null
                                      : () async {
                                          socket.sendXML('IdentifyDevice', mac: hitDeviceMac);
                                          var response = await socket.myReceiveXML("IdentifyDeviceStatus");
                                          if (response!['result'] == "device_not_found") {
                                            _errorDialog(context, S.of(context).identifyDeviceErrorTitle, S.of(context).deviceNotFoundIdentifyDevice + "\n\n" + S.of(context).deviceNotFoundHint);
                                          }
                                        },

                                  mouseCursor: !hitDeviceIdentify ? SystemMouseCursors.basic : SystemMouseCursors.click,
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
                                      var response = await socket.myReceiveXML("GetManualResponse");
                                      if (response!['filename'] != "") {
                                        setState(() {
                                          openFile(response['filename']);
                                        });
                                      } else {
                                        _errorDialog(context, S.of(context).manualErrorTitle, S.of(context).manualErrorBody);
                                      }
                                    }),
                                Text(
                                  S.of(context).showManual,
                                  style: TextStyle(fontSize: 14, color: fontColorLight),
                                  textScaleFactor: fontSizeFactor,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            if (hitDeviceVDSLList != null)
                              Column(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.router_rounded,
                                        color: fontColorLight,
                                      ),
                                      //tooltip: S.of(context).showManual,
                                      hoverColor: fontColorLight.withAlpha(50),
                                      iconSize: 24.0 * fontSizeFactor,
                                      onPressed: () {
                                        _showVDSLDialog(socket, hitDeviceVDSLmode, hitDeviceVDSLList, hitDeviceVDSLprofile, hitDeviceMac);
                                      }),
                                  Text(
                                    S.of(context).setVdslCompatibility,
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
                                  onPressed: () async {
                                    bool confResponse = false;
                                    hitDevice.attachedToRouter ? confResponse = await _confirmDialog(context, S.of(context).resetDeviceConfirmTitle, S.of(context).resetDeviceConfirmBody + "\n" + S.of(context).confirmActionConnectedToRouterWarning) : confResponse = await _confirmDialog(context, S.of(context).resetDeviceConfirmTitle, S.of(context).resetDeviceConfirmBody);

                                    if (confResponse) {
                                      socket.sendXML("ResetAdapterToFactoryDefaults", mac: hitDevice.mac);

                                      var response = await socket.myReceiveXML("ResetAdapterToFactoryDefaultsStatus");
                                      if (response!['result'] == "device_not_found") {
                                        _errorDialog(context, S.of(context).resetDeviceErrorTitle, S.of(context).deviceNotFoundResetDevice + "\n\n" + S.of(context).deviceNotFoundHint);
                                      } else if (response['result'] != "ok") {
                                        _errorDialog(context, S.of(context).resetDeviceErrorTitle, S.of(context).resetDeviceErrorBody);
                                      }
                                    }
                                  },
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
                                  onPressed: () async {
                                    bool confResponse = false;
                                    hitDevice.attachedToRouter ? confResponse = await _confirmDialog(context, S.of(context).removeDeviceConfirmTitle, S.of(context).removeDeviceConfirmBody + "\n" + S.of(context).confirmActionConnectedToRouterWarning) : confResponse = await _confirmDialog(context, S.of(context).removeDeviceConfirmTitle, S.of(context).removeDeviceConfirmBody);

                                    if (confResponse) {
                                      socket.sendXML("RemoveAdapter", mac: hitDevice.mac);

                                      var response = await socket.myReceiveXML("RemoveAdapterStatus");
                                      if (response!['result'] == "device_not_found") {
                                        _errorDialog(context, S.of(context).removeDeviceErrorTitle, S.of(context).deviceNotFoundRemoveDevice + "\n\n" + S.of(context).deviceNotFoundHint);
                                      } else if (response['result'] != "ok") {
                                        _errorDialog(context, S.of(context).removeDeviceErrorTitle, S.of(context).removeDeviceErrorBody);
                                      }
                                    }
                                  },
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

  /*
  method no more needed

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
*/
  // Confirmation Dialog with 2 Buttons
  Future<bool> _confirmDialog(context, title, body) async {
    bool returnVal = await showDialog(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Text(
                  title,
                  style: TextStyle(color: fontColorLight),
                ),
              ],
            ),
            titlePadding: EdgeInsets.all(2),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18 * fontSizeFactor),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: fontColorLight,
                      size: 35 * fontSizeFactor,
                    ),
                    Text(
                      S.of(context).confirm,
                      style: TextStyle(color: fontColorLight),
                    ),
                  ],
                ),
                onPressed: () {
                  // Critical things happening here
                  Navigator.maybeOf(context)!.pop(true);
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
                      Text(
                        S.of(context).cancel,
                        style: TextStyle(color: fontColorLight),
                      ),
                    ],
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context)!.pop(false);
                    //return false; TODO nullsafety
                  }),
            ],
          );
        });

    if (returnVal == null) returnVal = false;

    return returnVal;
  }

  void _errorDialog(context, title, body) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Text(
                  title,
                  style: TextStyle(color: fontColorLight),
                ),
              ],
            ),
            titlePadding: EdgeInsets.all(2),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18 * fontSizeFactor),
            content: Text(body),
            actions: <Widget>[],
          );
        });
  }

  void _showVDSLDialog(socket, String hitDeviceVDSLmode, List<String> hitDeviceVDSLList, String _vdslProfile, hitDeviceMac) {
    bool _vdslModeAutomatic = false;
    if(hitDeviceVDSLmode == "2")
      _vdslModeAutomatic = true;

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 300),
            title: Text(S.of(context).vdslCompatibility),
            titleTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(hitDeviceVDSLmode != "0")
                  Column(children: [
                    SelectableText(S.of(context).vdslexplanation),
                    Row(
                      children: [
                        Theme(
                          data: ThemeData(
                            //here change to your color
                            unselectedWidgetColor: secondColor,
                          ),
                          child: Checkbox(
                              value: _vdslModeAutomatic,
                              activeColor: secondColor,
                              onChanged: (bool? newValue) async {
                                _vdslModeAutomatic = newValue!;
                                setState(() {
                                if (_vdslModeAutomatic == true) {
                                  hitDeviceVDSLmode = "2";
                                } else {
                                  hitDeviceVDSLmode = "1";
                                }
                                });
                              }),
                        ),
                        SelectableText(S.of(context).automaticCompatibilityMode),
                      ],
                    ),
                    SelectableText(S.of(context).vdslexplanation2),
                  ],),
                for (String vdsl_profile in hitDeviceVDSLList)
                  ListTile(
                    title: Text(
                      vdsl_profile,
                      style:  TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
                    ),
                    leading: Theme(
                      data: ThemeData(
                        //here change to your color
                        unselectedWidgetColor: secondColor,
                      ),
                      child: Radio(
                        value: vdsl_profile,
                        groupValue: _vdslProfile,
                        activeColor: secondColor,
                        onChanged: (String? value) {
                          setState(() {
                            _vdslProfile = value!;
                          });
                        },
                      ),
                    ),
                  ),
              ],
            );
        }),
            actions: <Widget>[
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: fontColorLight,
                      size: 35 * fontSizeFactor,
                    ),
                    Text(
                      S.of(context).confirm,
                      style: TextStyle(color: fontColorLight),
                    ),
                  ],
                ),
                onPressed: () async {
                  bool confResponse = false;
                 confResponse = await _confirmDialog(context, "Set VDSL Compatibility", "Neue VDSL Einstellungen ${_vdslProfile} übernehmen? ${hitDeviceVDSLmode}");

                  if (confResponse) {
                    socket.sendXML('SetVDSLCompatibility', newValue: _vdslProfile, valueType: 'profile', newValue2: hitDeviceVDSLmode, valueType2: 'mode', mac: hitDeviceMac);

                    showDialog<void>(
                    context: context,
                    barrierDismissible: true, // user doesn't need to tap button!
                    builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: Column(mainAxisSize: MainAxisSize.min ,
                          children: [
                        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(secondColor),)]
                      ),
                    );
                    });

                    var response = await socket.recieveXML(["SetVDSLCompatibilityStatus"]);
                    if (response['result'] == "failed") {
                      Navigator.maybeOf(context)!.pop(true);
                    _errorDialog(context, " ", S.of(context).vdslfailed);
                    } else if (response['result'] != "ok") {
                      Navigator.maybeOf(context)!.pop(true);
                      _errorDialog(context, "Done", S.of(context).resetDeviceErrorBody);
                    }
                    else {
                      Navigator.maybeOf(context)!.pop();
                    }
                  }
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
                      Text(
                        S.of(context).cancel,
                        style: TextStyle(color: fontColorLight),
                      ),
                    ],
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context)!.pop(false);
                  }),
            ],

          );
        });
  }
}
