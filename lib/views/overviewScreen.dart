/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:convert';

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/shared/informationDialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';

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
  List<int> pivotDeviceIndexList = [];

  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<DataHand>(context);
    final _deviceList = Provider.of<NetworkList>(context);
    socket.setNetworkList(_deviceList);
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
    else if(_deviceList.getNetworkListLength() != pivotDeviceIndexList.length){
      pivotDeviceIndexList.clear();
      for(int i = 0; i < _deviceList.getNetworkListLength(); i++)
        pivotDeviceIndexList.add(0);
      pivotDeviceIndex = pivotDeviceIndexList[_deviceList.selectedNetworkIndex];
    }
    else
      pivotDeviceIndex = pivotDeviceIndexList[_deviceList.selectedNetworkIndex];


    _Painter = DrawOverview(context, _deviceList, showingSpeeds, pivotDeviceIndex);

    logger.d("[overviewScreen] - widget build...");

    fontSize = context.watch<FontSize>();

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
          DevoloIcons.ic_refresh_24px,
          color: mainColor,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _handleTapDown(TapDownDetails details) {
    //logger.i('entering tabDown');
    _lastTapDownPosition = details.localPosition;
  }

  void _handleTap(TapUpDetails details) {
    //logger.i('entering dialog....');
    int index = 0;

    final socket = Provider.of<DataHand>(context, listen: false);
    final deviceList = Provider.of<NetworkList>(context, listen: false);

    networkOffsetList.asMap().forEach((i, networkIconOffset) {
      //for (Offset networkIconOffset in _Painter.networkOffsets) {
      //Offset absoluteOffset = Offset(networkIconOffset.dx + (_Painter.screenWidth / 2), networkIconOffset.dy + (_Painter.screenHeight / 2));
      //logger.i("NetworkIcon: " + networkIconOffset.toString());
      //logger.i("Local: " + details.localPosition.toString());
      //logger.i("absolute: " + absoluteOffset.toString());

      //test if network got hit
      if (_Painter.isPointInsideNetworkIcon(details.localPosition, networkIconOffset, _Painter.hn_circle_radius)) {
        logger.i("Hit Network #" + i.toString());
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
        logger.i("Hit icon #" + index.toString());

        Device hitDevice = deviceList.getDeviceList()[index];

        //openDialog
        deviceInformationDialog(context, hitDevice, myFocusNode, socket, fontSize);

      }
      index++;
    }
  }

  void _handleLongPressStart(context) {
    RenderBox renderBox = context.findRenderObject();

    int index = 0;
    String hitDeviceName;
    for (Offset deviceIconOffset in deviceIconOffsetList) {
      if (index > _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2), deviceIconOffset.dy + (_Painter.screenHeight / 2));

      if (_Painter.isPointInsideCircle(_lastTapDownPosition, absoluteOffset, _Painter.hn_circle_radius)) {
        logger.i("Long press on icon #" + index.toString());

        final deviceList = Provider.of<NetworkList>(context, listen: false);
        hitDeviceName = deviceList.getDeviceList()[index].name;

        setState(() {
          //if (_Painter.showSpeedsPermanently && index == _Painter.pivotDeviceIndex) {
          showingSpeeds = true;

          //_Painter.pivotDeviceIndex = index;
          pivotDeviceIndexList[deviceList.selectedNetworkIndex] = index;

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
    //logger.i("long press up");

    setState(() {
      if (!config["show_speeds_permanent"]) {
        showingSpeeds = false;
      } else {
        if (!showingSpeeds) _Painter.pivotDeviceIndex = 0;
      }
    });
  }
}
