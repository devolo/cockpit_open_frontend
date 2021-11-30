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
import 'package:cockpit_devolo/models/sizeModel.dart';
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

  late SizeModel size;

  var hoveredDevice = 999; //displays wich device index is hovered, if no device is hovered the index is set to 999

  bool floatingActionButtonHovered = false;
  static const networkNameTopPadding = 20.0;
  static const canvasTopPadding = 30.0;

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

    //saveWindowSize();

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

    size = context.watch<SizeModel>();

    int _localIndex = _deviceList.getDeviceList().indexWhere((element) => element.isLocalDevice == true);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IgnorePointer(
        ignoring: socket.connected ? false: true,
        child: Stack(
          children: [
            Row(children: [     //TODO For later when we need a info box on the side
              Expanded(child: Column(
                mainAxisAlignment : MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment : MainAxisAlignment.center,
                      children:[
                        Text(
                          _deviceList.getNetworkName(_deviceList.selectedNetworkIndex),
                          style: TextStyle(color: fontColorOnBackground, fontSize: 18 * size.font_factor, fontWeight: FontWeight.w600),
                        ),
                        PopupMenuButton(
                          offset: Offset(_deviceList.getNetworkName(_deviceList.selectedNetworkIndex).length.toDouble() - 25, 40),
                          color: backgroundColor,
                          tooltip: S.of(context).networkSettings,
                          icon: Icon(DevoloIcons.devolo_UI_more_horiz, color: fontColorOnBackground),
                          iconSize: 24 * size.icon_factor,
                          onSelected: (dynamic value){
                            if(value == "networkSettings"){
                              networkSettingsDialog(context, _deviceList, myFocusNode, socket, size);
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
                                width: 200,
                                child: Text(S.of(context).changePlcNetworkPassword, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * size.font_factor),),
                              ),
                            ),
                            if(_deviceList.getNetworkListLength() > 1) ...[
                              PopupMenuDivider(),
                              PopupMenuItem(
                                enabled: false,
                                child: Text(S.of(context).switchNetwork, style: TextStyle(color: fontColorOnBackground, fontSize: 14 * size.font_factor)),
                              ),
                              for(int i = 0; i < _deviceList.getNetworkListLength(); i++) ...[
                                PopupMenuItem(
                                  enabled: _deviceList.selectedNetworkIndex == i ? false : true,
                                  value: i,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 50, right: 10), //Needs to be done here as the parent padding gets ignored when the item is disabled
                                      child: Text(_deviceList.getNetworkName(i), style: TextStyle(color: fontColorOnBackground, fontSize: 14 * size.font_factor, fontWeight: _deviceList.selectedNetworkIndex == i ? FontWeight.w600 : null))),
                                ),
                              ]
                            ]
                          ],
                        )
                      ]),
                  Expanded(child:
                    LayoutBuilder(builder: (context, constraints) {
                      double height = constraints.maxHeight;
                      double width = constraints.maxWidth;

                      return Stack(children: [
                        CustomPaint(
                          painter: _Painter,
                          child: MouseRegion(
                            //cursor: (hoveredDevice != 999) ? SystemMouseCursors.click : MouseCursor.defer,
                            onHover: (details) =>
                            {
                              _handleHover(details, _deviceList, width, height)
                            },
                          ),
                        ),
                        for(var i = 0; i < _deviceList
                            .getDeviceList()
                            .length; i++) ...[
                          Positioned(
                              left: _Painter.getDeviceIconOffsetList(_deviceList
                                  .getDeviceList()
                                  .length, width, height)[i].dx +
                                  _Painter.getNameWidth(_deviceList
                                      .getDeviceList()
                                      .elementAt(i)
                                      .type, _deviceList
                                      .getDeviceList()
                                      .elementAt(i)
                                      .name) / 2,
                              top: _Painter.getDeviceIconOffsetList(_deviceList
                                  .getDeviceList()
                                  .length, width, height)[i].dy +
                                  _Painter.hnCircleRadius +
                                  _Painter.userNameTopPadding,
                              child: PopupMenuButton(
                                offset: Offset(0, 40),
                                color: backgroundColor,
                                tooltip: S
                                    .of(context)
                                    .deviceSettings,
                                icon: Icon(DevoloIcons.devolo_UI_more_horiz,
                                    color: fontColorOnBackground),
                                iconSize: 24 * size.icon_factor,
                                onSelected: (dynamic value) async {
                                  Device selectedDevice = _deviceList
                                      .getDeviceList().elementAt(i);

                                  if (value == "deviceSettings") {
                                    deviceInformationDialogWithoutAction(
                                        context, selectedDevice, myFocusNode,
                                        socket, size);
                                  }
                                  else if (value == "webInterface") {
                                    launchURL(selectedDevice.webinterfaceURL);
                                  }
                                  else if (value == "identifyDevice") {
                                    socket.sendXML('IdentifyDevice',
                                        mac: selectedDevice.mac);
                                    var response = await socket.receiveXML(
                                        "IdentifyDeviceStatus");
                                    if (response!['result'] ==
                                        "device_not_found") {
                                      errorDialog(context, S
                                          .of(context)
                                          .identifyDeviceErrorTitle, S
                                          .of(context)
                                          .deviceNotFoundIdentifyDevice +
                                          "\n\n" + S
                                          .of(context)
                                          .deviceNotFoundHint, size);
                                    }
                                    else if (response['result'] != "ok") {
                                      errorDialog(context, S
                                          .of(context)
                                          .identifyDeviceErrorTitle, S
                                          .of(context)
                                          .identifyDeviceErrorBody, size);
                                    }
                                  }
                                  else if (value == "showManual") {
                                    socket.sendXML(
                                        'GetManual',
                                        newValue: selectedDevice.MT,
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
                                          .manualErrorBody, size);
                                    }
                                  }
                                  else if (value == "factoryReset") {
                                    bool confResponse = false;
                                    selectedDevice.attachedToRouter
                                        ? confResponse =
                                    await confirmDialog(context, S
                                        .of(context)
                                        .resetDeviceConfirmTitle, S
                                        .of(context)
                                        .resetDeviceConfirmBody + "\n" + S
                                        .of(context)
                                        .confirmActionConnectedToRouterWarning,
                                        size)
                                        : confResponse =
                                    await confirmDialog(context, S
                                        .of(context)
                                        .resetDeviceConfirmTitle, S
                                        .of(context)
                                        .resetDeviceConfirmBody, size);

                                    if (confResponse) {
                                      socket.sendXML(
                                          "ResetAdapterToFactoryDefaults",
                                          mac: selectedDevice.mac);

                                      var response = await socket.receiveXML(
                                          "ResetAdapterToFactoryDefaultsStatus");
                                      if (response!['result'] ==
                                          "device_not_found") {
                                        errorDialog(context, S
                                            .of(context)
                                            .resetDeviceErrorTitle, S
                                            .of(context)
                                            .deviceNotFoundResetDevice +
                                            "\n\n" + S
                                            .of(context)
                                            .deviceNotFoundHint, size);
                                      } else if (response['result'] != "ok") {
                                        errorDialog(context, S
                                            .of(context)
                                            .resetDeviceErrorTitle, S
                                            .of(context)
                                            .resetDeviceErrorBody, size);
                                      }
                                    }
                                  }
                                  else if (value == "deleteDevice") {
                                    bool confResponse = false;
                                    selectedDevice.attachedToRouter
                                        ?
                                    confResponse =
                                    await confirmDialog(context, S
                                        .of(context)
                                        .removeDeviceConfirmTitle, S
                                        .of(context)
                                        .removeDeviceConfirmBody + "\n" + S
                                        .of(context)
                                        .confirmActionConnectedToRouterWarning,
                                        size)
                                        : confResponse = await confirmDialog(
                                        context, S
                                        .of(context)
                                        .removeDeviceConfirmTitle, S
                                        .of(context)
                                        .removeDeviceConfirmBody, size);

                                    if (confResponse) {
                                      socket.sendXML(
                                          "RemoveAdapter",
                                          mac: selectedDevice.mac);

                                      var response = await socket.receiveXML(
                                          "RemoveAdapterStatus");
                                      if (response!['result'] ==
                                          "device_not_found") {
                                        errorDialog(context, S
                                            .of(context)
                                            .removeDeviceErrorTitle, S
                                            .of(context)
                                            .deviceNotFoundRemoveDevice +
                                            "\n\n" + S
                                            .of(context)
                                            .deviceNotFoundHint, size);
                                      } else if (response['result'] != "ok") {
                                        errorDialog(context, S
                                            .of(context)
                                            .removeDeviceErrorTitle, S
                                            .of(context)
                                            .removeDeviceErrorBody, size);
                                      }
                                    }
                                  }
                                  else if (value == "setVDSL") {
                                    setState(() {
                                      showVDSLDialog(
                                          context,
                                          socket,
                                          selectedDevice.modeVDSL,
                                          selectedDevice.supportedVDSL,
                                          selectedDevice.selectedVDSL,
                                          selectedDevice.mac,
                                          size);
                                    });
                                  }
                                  else if (value == "additionalSettings") {
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
                                        size);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: "deviceSettings",
                                    child: SizedBox( // needed as different languages have different length which influences the offset
                                      child: Text(S
                                          .of(context)
                                          .deviceInfo, style: TextStyle(
                                          color: fontColorOnBackground,
                                          fontSize: 14 * size.font_factor),),
                                    ),
                                  ),
                                  PopupMenuDivider(),
                                  if(_deviceList
                                      .getDeviceList()
                                      .elementAt(i)
                                      .webinterfaceAvailable)
                                    PopupMenuItem(
                                      value: "webInterface",
                                      child: Text(S
                                          .of(context)
                                          .launchWebInterface, style: TextStyle(
                                          color: fontColorOnBackground,
                                          fontSize: 14 * size.font_factor)),
                                    ),
                                  if(_deviceList
                                      .getDeviceList()
                                      .elementAt(i)
                                      .identifyDeviceAvailable)
                                    PopupMenuItem(
                                      value: "identifyDevice",
                                      child: Text(S
                                          .of(context)
                                          .identifyDevice, style: TextStyle(
                                          color: fontColorOnBackground,
                                          fontSize: 14 * size.font_factor)),
                                    ),
                                  PopupMenuItem(
                                    value: "showManual",
                                    child: Text(S
                                        .of(context)
                                        .showManual, style: TextStyle(
                                        color: fontColorOnBackground,
                                        fontSize: 14 * size.font_factor)),
                                  ),
                                  PopupMenuDivider(),
                                  if(_deviceList
                                      .getDeviceList()
                                      .elementAt(i)
                                      .supportedVDSL
                                      .isNotEmpty)
                                    PopupMenuItem(
                                      value: "setVDSL",
                                      child: Text(S
                                          .of(context)
                                          .setVdslCompatibility,
                                          style: TextStyle(
                                              color: fontColorOnBackground,
                                              fontSize: 14 * size.font_factor)),
                                    ),
                                  PopupMenuItem(
                                    value: "deleteDevice",
                                    child: Text(S
                                        .of(context)
                                        .deleteDevice, style: TextStyle(
                                        color: fontColorOnBackground,
                                        fontSize: 14 * size.font_factor)),
                                  ),
                                  PopupMenuItem(
                                    value: "factoryReset",
                                    child: Text(S
                                        .of(context)
                                        .factoryReset, style: TextStyle(
                                        color: fontColorOnBackground,
                                        fontSize: 14 * size.font_factor)),
                                  ),
                                  if (_deviceList
                                      .getDeviceList()
                                      .elementAt(i)
                                      .disableTraffic[0] == 1 ||
                                      _deviceList
                                          .getDeviceList()
                                          .elementAt(i)
                                          .disableLeds[0] == 1 ||
                                      _deviceList
                                          .getDeviceList()
                                          .elementAt(i)
                                          .disableStandby[0] == 1 ||
                                      (_deviceList
                                          .getDeviceList()
                                          .elementAt(i)
                                          .ipConfigAddress
                                          .isNotEmpty ||
                                          _deviceList
                                              .getDeviceList()
                                              .elementAt(i)
                                              .ipConfigMac
                                              .isNotEmpty ||
                                          _deviceList
                                              .getDeviceList()
                                              .elementAt(i)
                                              .ipConfigNetmask
                                              .isNotEmpty)
                                  ) ...[
                                    PopupMenuDivider(),
                                    PopupMenuItem(
                                      value: "additionalSettings",
                                      child: Text(S
                                          .of(context)
                                          .additionalSettings, style: TextStyle(
                                          color: fontColorOnBackground,
                                          fontSize: 14 * size.font_factor)),
                                    ),
                                  ],
                                ],
                              )
                          ),
                        ],
                        // hover tooltip area for laptop icon (local device)
                        if(_localIndex != -1)
                          Positioned(
                            left: _Painter
                                .getLaptopIconOffset(_localIndex,
                                _Painter.getDeviceIconOffsetList(_deviceList
                                    .getDeviceList()
                                    .length, width, height))
                                .dx,
                            top: _Painter
                                .getLaptopIconOffset(_localIndex,
                                _Painter.getDeviceIconOffsetList(_deviceList
                                    .getDeviceList()
                                    .length, width, height))
                                .dy,
                            child: IconButton(
                              tooltip: S
                                  .of(context)
                                  .thisPc,
                              iconSize: _Painter.laptopCircleRadius,
                              icon: Icon(null),
                              onPressed: null,
                              mouseCursor: MouseCursor.defer,
                            ),
                          ),
                      ],);
                    }),
                  ),
                ]),
              ),
              //Container(width: screenWidth/2),  //TODO Place here the side information
            ]),
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
                titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * size.font_factor),
                contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * size.font_factor),
                title: Text(S.of(context).noconnection),
                content:  Text(S.of(context).noconnectionbody),
                ),
          ],
        ),
      ),
      floatingActionButton: IgnorePointer(
        ignoring: socket.connected ? false: true,
        child: Padding(
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
                  size: 24 * size.icon_factor
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _handleHover(PointerEvent details, NetworkList _deviceList, double width, double height) {

    var index = 0;
    for (Offset deviceIconOffset in _Painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length, width, height)) {
      if (index > _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = deviceIconOffset;

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
