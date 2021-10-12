/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:async';
import 'dart:ui';

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/alertDialogs.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/devolo_icons.dart';
import 'package:cockpit_devolo/shared/globals.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/shared/informationDialogWithoutAction.dart';
import 'package:cockpit_devolo/shared/informationDialogs.dart';
import 'package:cockpit_devolo/shared/networkSettingsDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';

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

  late var socket;
  late NetworkList _deviceList;
  int numDevices = 0;
  late Offset _lastTapDownPosition;
  late DrawOverview _Painter;
  bool blockRefresh = false;

  bool showingSpeeds = false;

  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  var hoveredDevice = 999; //displays wich device index is hovered, if no device is hovered the index is set to 999

  bool floatingActionButtonHovered = false;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {AppBuilder.of(context)!.rebuild();});
  }

  @override
  Widget build(BuildContext context) {
    socket = Provider.of<DataHand>(context);
    _deviceList = Provider.of<NetworkList>(context);
    socket.setNetworkList(_deviceList);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    if(_deviceList.getNetworkListLength() - 1 >= config["selected_network"]){
      _deviceList.selectedNetworkIndex = config["selected_network"];
    }
    else{
      config["selected_network"] = 0;
      _deviceList.selectedNetworkIndex = 0;
    }

    // reset pivotDeviceIndex when a new Network is added or a Network is removed
    int pivotDeviceIndex;
    if(_deviceList.getNetworkListLength() == 0){
      pivotDeviceIndex = 0;
    }
    else if(_deviceList.getNetworkListLength() != _deviceList.pivotDeviceIndexList.length){
      _deviceList.pivotDeviceIndexList.clear();
      for(int i = 0; i < _deviceList.getNetworkListLength(); i++)
        _deviceList.pivotDeviceIndexList.add(0);
      pivotDeviceIndex = _deviceList.pivotDeviceIndexList[_deviceList.selectedNetworkIndex];
    }
    else
      pivotDeviceIndex = _deviceList.pivotDeviceIndexList[_deviceList.selectedNetworkIndex];


    _Painter = DrawOverview(context, _deviceList, showingSpeeds, pivotDeviceIndex, hoveredDevice);

    logger.d("[overviewScreen] - widget build...");

    fontSize = context.watch<FontSize>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IgnorePointer(
        ignoring: socket.connected ? false: true,
        child: Container(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: _handleTap,
            onTapDown: _handleTapDown,
            onLongPress: () => _handleLongPressStart(context,_deviceList),
            onLongPressUp: _handleLongPressEnd,
            child:  Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: CustomPaint(
                      painter: _Painter,
                      child: MouseRegion(
                      cursor: (hoveredDevice != 999) ? SystemMouseCursors.click : MouseCursor.defer,
                      onHover: (details) => {
                        _handleHover(details,_deviceList)
                      },
                      child:Container(
                      ),
                    ),
                  ),
                ),),
                for(var i = 0; i < _deviceList.getDeviceList().length; i++) ...[
                  Positioned(
                      left: (screenWidth/2) + _Painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length)[i].dx + _Painter.getNameWidth(_deviceList.getDeviceList().elementAt(i).type, _deviceList.getDeviceList().elementAt(i).name)/2,
                      top: (screenHeight/2) + _Painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length)[i].dy + _Painter.hnCircleRadius + (_Painter.userNameTopPadding + _Painter.productNameTopPadding)/2,
                      child: PopupMenuButton(
                        offset: Offset(0, 40),
                        color: backgroundColor,
                        tooltip: S.of(context).deviceSettings,
                        icon: Icon(DevoloIcons.devolo_UI_more_horiz, color: fontColorOnBackground, size: 24 * fontSize.factor),
                        onSelected: (dynamic value) async {
                          Device selectedDevice = _deviceList.getDeviceList().elementAt(i);

                          if(value == "deviceSettings"){
                            deviceInformationDialogWithoutAction(context, selectedDevice, myFocusNode, socket, fontSize);
                          }
                          else if(value == "webInterface"){
                            launchURL(selectedDevice.webinterfaceURL);
                          }
                          else if(value == "identifyDevice"){
                            socket.sendXML('IdentifyDevice', mac: selectedDevice.mac);
                            var response = await socket.receiveXML(
                                "IdentifyDeviceStatus");
                            if (response!['result'] == "device_not_found") {
                              errorDialog(context, S
                                  .of(context)
                                  .identifyDeviceErrorTitle, S
                                  .of(context)
                                  .deviceNotFoundIdentifyDevice + "\n\n" + S
                                  .of(context)
                                  .deviceNotFoundHint, fontSize);
                            }
                            else if (response['result'] != "ok") {
                              errorDialog(context, S
                                  .of(context)
                                  .identifyDeviceErrorTitle, S
                                  .of(context)
                                  .identifyDeviceErrorBody, fontSize);
                            }
                          }
                          else if(value == "showManual"){
                            socket.sendXML(
                                'GetManual', newValue: selectedDevice.MT,
                                valueType: 'product',
                                newValue2: config["language"],
                                valueType2: 'language');
                            var response = await socket.receiveXML(
                                "GetManualResponse");
                            if (response!['filename'] != "") {
                              openFile(response['filename']);
                            } else {
                              errorDialog(context, S
                                  .of(context)
                                  .manualErrorTitle, S
                                  .of(context)
                                  .manualErrorBody, fontSize);
                            }
                          }
                          else if(value == "factoryReset"){
                            bool confResponse = false;
                            selectedDevice.attachedToRouter
                                ? confResponse = await confirmDialog(context, S
                                .of(context)
                                .resetDeviceConfirmTitle, S
                                .of(context)
                                .resetDeviceConfirmBody + "\n" + S
                                .of(context)
                                .confirmActionConnectedToRouterWarning,
                                fontSize)
                                : confResponse = await confirmDialog(context, S
                                .of(context)
                                .resetDeviceConfirmTitle, S
                                .of(context)
                                .resetDeviceConfirmBody, fontSize);

                            if (confResponse) {
                              socket.sendXML("ResetAdapterToFactoryDefaults",
                                  mac: selectedDevice.mac);

                              var response = await socket.receiveXML(
                                  "ResetAdapterToFactoryDefaultsStatus");
                              if (response!['result'] == "device_not_found") {
                                errorDialog(context, S
                                    .of(context)
                                    .resetDeviceErrorTitle, S
                                    .of(context)
                                    .deviceNotFoundResetDevice + "\n\n" + S
                                    .of(context)
                                    .deviceNotFoundHint, fontSize);
                              } else if (response['result'] != "ok") {
                                errorDialog(context, S
                                    .of(context)
                                    .resetDeviceErrorTitle, S
                                    .of(context)
                                    .resetDeviceErrorBody, fontSize);
                              }
                            }
                          }
                          else if(value == "deleteDevice"){
                            bool confResponse = false;
                            selectedDevice.attachedToRouter
                                ?
                            confResponse = await confirmDialog(context, S
                                .of(context)
                                .removeDeviceConfirmTitle, S
                                .of(context)
                                .removeDeviceConfirmBody + "\n" + S
                                .of(context)
                                .confirmActionConnectedToRouterWarning,
                                fontSize)
                                : confResponse = await confirmDialog(
                                context, S
                                .of(context)
                                .removeDeviceConfirmTitle, S
                                .of(context)
                                .removeDeviceConfirmBody, fontSize);

                            if (confResponse) {
                              socket.sendXML(
                                  "RemoveAdapter", mac: selectedDevice.mac);

                              var response = await socket.receiveXML(
                                  "RemoveAdapterStatus");
                              if (response!['result'] == "device_not_found") {
                                errorDialog(context, S
                                    .of(context)
                                    .removeDeviceErrorTitle, S
                                    .of(context)
                                    .deviceNotFoundRemoveDevice + "\n\n" + S
                                    .of(context)
                                    .deviceNotFoundHint, fontSize);
                              } else if (response['result'] != "ok") {
                                errorDialog(context, S
                                    .of(context)
                                    .removeDeviceErrorTitle, S
                                    .of(context)
                                    .removeDeviceErrorBody, fontSize);
                              }
                            }
                          }
                          else if(value == "setVDSL"){
                            setState(() {
                              showVDSLDialog(
                                  context,socket, selectedDevice.modeVDSL, selectedDevice.supportedVDSL,
                                  selectedDevice.selectedVDSL, selectedDevice.mac, fontSize);

                            });
                          }
                          else if(value == "additionalSettings"){
                            moreSettings(
                                context,
                                socket,
                                selectedDevice.disableTraffic,
                                selectedDevice.disableLeds,
                                selectedDevice.disableStandby,
                                selectedDevice.mac,
                                selectedDevice.ipConfigMac,
                                selectedDevice.ipConfigAddress,
                                selectedDevice.ipConfigNetmask,
                                fontSize);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            value: "deviceSettings",
                            child: SizedBox(    // needed as different languages have different length which influences the offset
                              child: Text(S.of(context).deviceInfo, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor),),
                            ),
                          ),
                          PopupMenuDivider(),
                          if(_deviceList.getDeviceList().elementAt(i).webinterfaceAvailable)
                            PopupMenuItem(
                              value: "webInterface",
                              child: Text(S.of(context).launchWebInterface, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                            ),
                          if(_deviceList.getDeviceList().elementAt(i).identifyDeviceAvailable)
                            PopupMenuItem(
                              value: "identifyDevice",
                              child: Text(S.of(context).identifyDevice, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                            ),
                          PopupMenuItem(
                            value: "showManual",
                            child: Text(S.of(context).showManual, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem(
                            value: "factoryReset",
                            child: Text(S.of(context).factoryReset, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                          ),
                          PopupMenuItem(
                            value: "deleteDevice",
                            child: Text(S.of(context).deleteDevice, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                          ),
                          if(_deviceList.getDeviceList().elementAt(i).supportedVDSL.isNotEmpty)
                            PopupMenuItem(
                              value: "setVDSL",
                              child: Text(S.of(context).setVdslCompatibility, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                            ),
                          if (_deviceList.getDeviceList().elementAt(i).disableTraffic[0] == 1 ||
                              _deviceList.getDeviceList().elementAt(i).disableLeds[0] == 1 ||
                              _deviceList.getDeviceList().elementAt(i).disableStandby[0] == 1 ||
                              (_deviceList.getDeviceList().elementAt(i).ipConfigAddress.isNotEmpty ||
                                  _deviceList.getDeviceList().elementAt(i).ipConfigMac.isNotEmpty ||
                                  _deviceList.getDeviceList().elementAt(i).ipConfigNetmask.isNotEmpty)
                          ) ...[
                            PopupMenuDivider(),
                            PopupMenuItem(
                              value: "additionalSettings",
                              child: Text(S.of(context).additionalSettings, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                            ),
                          ],
                        ],
                      )
                  ),
                ],
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                      mainAxisAlignment : MainAxisAlignment.center,
                      children:[
                        Text(
                          _deviceList.getNetworkName(_deviceList.selectedNetworkIndex),
                          style: TextStyle(color: fontColorOnBackground, fontSize: 18 * fontSize.factor, fontWeight: FontWeight.w600),
                        ),
                        PopupMenuButton(
                            offset: Offset(_deviceList.getNetworkName(_deviceList.selectedNetworkIndex).length.toDouble() - 25, 40),
                            color: backgroundColor,
                            tooltip: S.of(context).networkSettings,
                            icon: Icon(DevoloIcons.devolo_UI_more_horiz, color: fontColorOnBackground, size: 24 * fontSize.factor),
                            onSelected: (dynamic value){
                              if(value == "networkSettings"){
                                networkSettingsDialog(context, _deviceList, myFocusNode, socket, fontSize);
                              }
                              else{
                                _deviceList.selectedNetworkIndex = value;
                                config["selected_network"] = value;
                                saveToSharedPrefs(config);
                                AppBuilder.of(context)!.rebuild();
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                value: "networkSettings",
                                child: SizedBox(    // needed as different languages have different length which influences the offset
                                  width: 180,
                                  child: Text(S.of(context).networkSettings, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor),),
                                ),
                              ),
                              if(_deviceList.getNetworkListLength() > 1) ...[
                                PopupMenuDivider(),
                                PopupMenuItem(
                                  enabled: false,
                                  child: Text(S.of(context).switchNetwork, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor)),
                                  ),
                                for(int i = 0; i < _deviceList.getNetworkListLength(); i++) ...[
                                  PopupMenuItem(
                                    enabled: _deviceList.selectedNetworkIndex == i ? false : true,
                                    value: i,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 50, right: 10), //Needs to be done here as the parent padding gets ignored when the item is disabled
                                        child: Text(_deviceList.getNetworkName(i), style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor, fontWeight: _deviceList.selectedNetworkIndex == i ? FontWeight.w600 : null))),
                                  ),
                                ]
                              ]
                            ],
                          )
                      ]),
                ),
                if(!socket.connected)
                new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: new Container(
                    decoration: new BoxDecoration(color: Colors.grey[200]!.withOpacity(0.1)),
                  ),
                ),
                if(!socket.connected)
                  AlertDialog(
                      backgroundColor: backgroundColor,
                      //titleTextStyle: TextStyle(color: fontColorOnMain),
                      //contentTextStyle: TextStyle(color: fontColorOnMain),
                    titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
                    contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                    title: Text(S.of(context).noconnection),
                    content:  Text(S.of(context).noconnectionbody),
                    ),
              ],
            ),
          ),
        ),

      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: 20, bottom: 10),
        child: MouseRegion(
          onEnter: (pointerEnterEvent){
            setState(() {
              floatingActionButtonHovered = true;
            });
          },
          onExit: (pointerExitEvent){
            setState(() {
              floatingActionButtonHovered = false;
            });
          },
          child: FloatingActionButton(
            onPressed: () {
              // Warning! "UpdateCheck" and "RefreshNetwork" should only be triggered by a user interaction, not continously/automaticly
              if(!blockRefresh){
                blockRefresh = true;
                setState(() {
                  socket.sendXML('RefreshNetwork');
                  AppBuilder.of(context)!.rebuild();
                });
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    blockRefresh = false;
                  });
                });
              }
            },
            elevation: 0,
            hoverElevation: 0,
            shape: CircleBorder(
              side: BorderSide(color: fontColorOnBackground, width: 2)
                //borderRadius: BorderRadius.zero
            ),
            tooltip: S.of(context).refresh,
            backgroundColor: backgroundColor,
            foregroundColor: floatingActionButtonHovered ? backgroundColor : fontColorOnBackground,
            hoverColor: fontColorOnBackground,
            child: Icon(
              DevoloIcons.ic_refresh_24px,
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _handleTapDown(TapDownDetails details) {
    _lastTapDownPosition = details.localPosition;
  }

  void _handleTap(TapUpDetails details) {
    int index = 0;

    final socket = Provider.of<DataHand>(context, listen: false);
    final deviceList = Provider.of<NetworkList>(context, listen: false);

    for (Offset deviceIconOffset in _Painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length)) {
      if (index > _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2), deviceIconOffset.dy + (_Painter.screenHeight / 2));

      //test if device got hit
      if (_Painter.isPointInsideCircle(details.localPosition, absoluteOffset, _Painter.hnCircleRadius)) {
        logger.i("Hit icon #" + index.toString());

        Device hitDevice = deviceList.getDeviceList()[index];

        //openDialog
        deviceInformationDialog(context, hitDevice, myFocusNode, socket, fontSize);

      }
      index++;
    }
  }

  void _handleLongPressStart(context, NetworkList _deviceList) {

    int index = 0;

    for (Offset deviceIconOffset in _Painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length)) {
      if (index > _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2), deviceIconOffset.dy + (_Painter.screenHeight / 2));

      if (_Painter.isPointInsideCircle(_lastTapDownPosition, absoluteOffset, _Painter.hnCircleRadius)) {
        logger.i("Long press on icon #" + index.toString());

        final deviceList = Provider.of<NetworkList>(context, listen: false);

        setState(() {
          //if (_Painter.showSpeedsPermanently && index == _Painter.pivotDeviceIndex) {
          showingSpeeds = true;

          _deviceList.pivotDeviceIndexList[deviceList.selectedNetworkIndex] = index;

          //do not update pivot device when the "router device" is long pressed
          logger.i('Pivot on longPress:' + _Painter.pivotDeviceIndex.toString());
          logger.i('sowingSpeed on longPress:' + showingSpeeds.toString());
        });
        return;
      }
      index++;
    }
  }

  void _handleLongPressEnd() {

    setState(() {
      if (!config["show_speeds_permanent"]) {
        showingSpeeds = false;
      } else {
        if (!showingSpeeds) _Painter.pivotDeviceIndex = 0;
      }
    });
  }

  void _handleHover(PointerEvent details, NetworkList _deviceList) {

    var index = 0;
    for (Offset deviceIconOffset in _Painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length)) {
      if (index > _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(
          deviceIconOffset.dx + (_Painter.screenWidth / 2),
          deviceIconOffset.dy + (_Painter.screenHeight / 2));

      //test if device got hovered
      if (_Painter.isPointInsideCircle(details.localPosition, absoluteOffset, _Painter.hnCircleRadius)) {

        // ignore when item is already hovered.
        if (!(hoveredDevice == index)) {
          logger.i("Hovered icon #" + index.toString());

          Timer(Duration(milliseconds: 10), (){
            //only execute action when device is still hovered
            if(hoveredDevice == index){
              final deviceList = Provider.of<NetworkList>(context, listen: false);

              setState(() {
                showingSpeeds = true;
                _deviceList.pivotDeviceIndexList[deviceList.selectedNetworkIndex] = index;
              });
            }
          });

          setState(() {
            hoveredDevice = index;
          });
          break;
        }

      }

      // when device is no more hovered
      else if(hoveredDevice == index){

        logger.i("Left Hovered icon #" + index.toString());
        final deviceList = Provider.of<NetworkList>(context, listen: false);

        setState(() {
          hoveredDevice = 999;

          _deviceList.pivotDeviceIndexList[deviceList.selectedNetworkIndex] = 0;
          if (!config["show_speeds_permanent"]) {
            showingSpeeds = false;
          } else {
            if (!showingSpeeds) _Painter.pivotDeviceIndex = 0;
          }
        });
        break;
      }

      index++;
    }
  }
}
