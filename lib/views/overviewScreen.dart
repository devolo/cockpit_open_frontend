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
import 'package:cockpit_devolo/shared/helpers.dart';
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

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {

  late DataHand socket;
  late NetworkList _deviceList;
  late DrawOverview _painter;

  bool blockRefresh = false;

  FocusNode deviceNameFormFocusNode = new FocusNode();

  late SizeModel size;

  bool hoveredDevice = false;
  var selectedDeviceIndex = 999; //if no device is selected the index is set to 999
  late Device selectedDevice;
  bool changeNameLoading = false;
  String newName = "";
  bool floatingActionButtonHovered = false;
  static const networkNameTopPadding = 20.0;
  static const canvasTopPadding = 30.0;
  final textFieldController = TextEditingController();

  bool identifyDeviceActionRunning = false;
  bool sideInformationEnabled = false;

  @override
  void initState() {
    super.initState();

    // reset TextFormField when changes are not saved
    deviceNameFormFocusNode.addListener(() {

      if(!deviceNameFormFocusNode.hasFocus && !changeNameLoading){
        textFieldController.text = selectedDevice.name;
      }
      AppBuilder.of(context)!.rebuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    socket = Provider.of<DataHand>(context);
    _deviceList = Provider.of<NetworkList>(context);
    socket.setNetworkList(_deviceList);

    double deviceInfoActionsPadding = 20;
    double dividerHeight = 10;

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = (screenWidth/2.5) - 120;

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


    _painter = DrawOverview(context, _deviceList, pivotDeviceIndex, selectedDeviceIndex);

    logger.d("[overviewScreen] - widget build...");

    size = context.watch<SizeModel>();

    int _localIndex = _deviceList.getDeviceList().indexWhere((element) => element.isLocalDevice == true);

    if(selectedDeviceIndex != 999 && _deviceList.getDeviceByMac(selectedDevice.mac) == null) {
      selectedDeviceIndex = 999;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IgnorePointer(
        ignoring: socket.connected ? false: true,
        child: Stack(
          children: [
            Row(children: [
              Expanded(child: Column(
                mainAxisAlignment : MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 20), child:Row(
                      mainAxisAlignment : MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        if(_deviceList.getNetworkListLength() != 0)
                        Padding(                                      // needed to have network name centered
                            padding: EdgeInsets.only(right: 8),
                            child:Icon(
                                DevoloIcons.devolo_UI_more_horiz,
                                color: Colors.transparent,
                                size: 24 * size.icon_factor)
                        ),
                        Text(
                          _deviceList.getNetworkName(_deviceList.selectedNetworkIndex),
                          style: TextStyle(color: fontColorOnBackground, fontSize: 18 * size.font_factor, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        if(_deviceList.getNetworkListLength() != 0)
                        PopupMenuButton(
                          offset: Offset(_deviceList.getNetworkName(_deviceList.selectedNetworkIndex).length.toDouble() - 25, 40),
                          color: backgroundColor,
                          tooltip: S.of(context).networkSettings,
                          icon: Icon(DevoloIcons.devolo_UI_more_horiz, color: fontColorOnBackground),
                          iconSize: 24 * size.icon_factor,
                          onSelected: (dynamic value){
                            if(value == "networkSettings"){
                              networkSettingsDialog(context, _deviceList, socket, size);
                            }
                            else{
                              _deviceList.selectedNetworkIndex = value;
                              config["selected_network"] = value;
                              saveToSharedPrefs(config);
                              selectedDeviceIndex = 999;
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
                      ])),
                  Expanded(child:
                    LayoutBuilder(builder: (context, constraints) {
                      double height = constraints.maxHeight;
                      double width = constraints.maxWidth;

                      return Stack(children: [
                        CustomPaint(
                          painter: _painter,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapUp: (details) => _handleTap(details, _deviceList, width, height),
                            child: (_deviceList.getNetworkListLength() == 0) ? Container() : MouseRegion(       //Disable MouseRegion when no Device is found
                                cursor: (hoveredDevice) ? SystemMouseCursors.click : MouseCursor.defer,
                                onHover: (details) => _checkIfDeviceIsHovered(details, _deviceList, width, height)
                            ),
                          ),
                        ),
                        if(_deviceList.getNetworkListLength() == 0)
                          Positioned(
                            left: _painter.getCircularProgressIndicatorPosition(width, height).dx,
                            top: _painter.getCircularProgressIndicatorPosition(width, height).dy - (_painter.fontSizeDeviceInfo * size.icon_factor)/2,
                            child: SizedBox(
                                width: _painter.fontSizeDeviceInfo * size.icon_factor,
                                height: _painter.fontSizeDeviceInfo * size.icon_factor,
                                child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
                                    strokeWidth: _painter.getScaleSize(0.2, 1, 3, width) * size.icon_factor)
                            ),
                          ),
                        // hover tooltip area for laptop icon (local device)
                        if(_localIndex != -1)
                          Positioned(
                            left: _painter
                                .getLaptopIconOffset(_localIndex,
                                _painter.getDeviceIconOffsetList(_deviceList
                                    .getDeviceList()
                                    .length, width, height))
                                .dx,
                            top: _painter
                                .getLaptopIconOffset(_localIndex,
                                _painter.getDeviceIconOffsetList(_deviceList
                                    .getDeviceList()
                                    .length, width, height))
                                .dy,
                            child: Container(
                              height:_painter.laptopCircleRadius*2,
                              width:_painter.laptopCircleRadius*2,
                              child: Tooltip( message: S
                                   .of(context)
                                  .thisPc),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                            ),
                          ),
                      ],);
                    }),
                  ),
                ]),
              ),
              if(selectedDeviceIndex != 999)
                Container(
                  margin: EdgeInsets.only(right: 120),  // to avoid collision with refresh button
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),  // scrollbar padding
                  width: containerWidth,
                  constraints: BoxConstraints(maxHeight: screenHeight/1.2),
                  decoration: BoxDecoration(
                    border: Border.all(color: fontColorOnBackground),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Theme(
                    data:
                    Theme.of(context).copyWith(scrollbarTheme: ScrollbarThemeData().copyWith(
                      isAlwaysShown: true,
                      thumbColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return fontColorOnBackground.withOpacity(0.5);
                          }
                          return fontColorOnBackground.withOpacity(0.3);
                        },
                      ),
                    )),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child:
                          Padding(
                            padding: EdgeInsets.only(left: containerWidth/9, right:containerWidth/9, top: 50),
                            child:
                            Column(
                                children: [
                                  if(selectedDevice.incomplete) ...[
                                    Container(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[

                                              WidgetSpan(

                                                  child: Icon(Icons.warning, color: fontColorOnBackground)),
                                              TextSpan(text: " " + S.of(context).incompleteDeviceInfoText),
                                            ],
                                          ),

                                          style: TextStyle(
                                              color: fontColorOnBackground
                                          ),
                                        )
                                    ),
                                    //Divider(color: fontColorOnBackground, height: 30),
                                    Padding(padding: EdgeInsets.only(bottom: 30)),
                                  ],
                                  Table(
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                "${S.of(context).name}:",
                                                style: TextStyle(color: fontColorOnBackground),
                                              )),
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,//Normal textInputField will be displayed
                                          maxLines: 5,// when user presses enter it will adapt to it
                                          controller: textFieldController,
                                          focusNode: deviceNameFormFocusNode,
                                          style: TextStyle(color: fontColorOnBackground,
                                              fontSize: 14 *
                                                  size.font_factor),
                                          cursorColor: fontColorOnBackground,
                                          decoration: InputDecoration(
                                            isDense: deviceNameFormFocusNode.hasPrimaryFocus? false : true,
                                            hoverColor: fontColorOnBackground.withOpacity(0.2),
                                            contentPadding: new EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              borderSide: BorderSide(
                                                color: fontColorOnBackground,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              borderSide: BorderSide(
                                                color: fontColorOnBackground,
                                              ),
                                            ),
                                            suffixIcon: (deviceNameFormFocusNode.hasPrimaryFocus && !changeNameLoading) ?
                                            Container(
                                              width: 80,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      icon: Icon(
                                                        DevoloIcons.devolo_UI_check_fill,
                                                        color: fontColorOnBackground,
                                                      ),
                                                      onPressed: () async {
                                                        if (newName != selectedDevice.name) {
                                                          changeNameLoading = true;
                                                          AppBuilder.of(context)!.rebuild();
                                                          socket.sendXML(
                                                              'SetAdapterName', mac: selectedDevice.mac,
                                                              newValue: newName,
                                                              valueType: 'name');
                                                          var response = await socket.receiveXML(
                                                              "SetAdapterNameStatus");
                                                          if (response!['result'] == "ok") {
                                                            selectedDevice.name = newName;
                                                            await Future.delayed(
                                                                const Duration(seconds: 1), () {});
                                                            socket.sendXML('RefreshNetwork');
                                                          } else if (response['result'] == "device_not_found") {
                                                            errorDialog(context, S
                                                                .of(context)
                                                                .deviceNameErrorTitle, S
                                                                .of(context)
                                                                .deviceNotFoundDeviceName + "\n\n" + S
                                                                .of(context)
                                                                .deviceNotFoundHint, size);
                                                          } else if (response['result'] != "ok") {
                                                            errorDialog(context, S
                                                                .of(context)
                                                                .deviceNameErrorTitle, S
                                                                .of(context)
                                                                .deviceNameErrorBody, size);
                                                          }

                                                          changeNameLoading = false;
                                                          deviceNameFormFocusNode.unfocus();
                                                        }
                                                      }
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      DevoloIcons.devolo_UI_cancel_fill,
                                                      color: fontColorOnBackground,
                                                    ),
                                                    onPressed: () async {
                                                      textFieldController.text = selectedDevice.name;
                                                      deviceNameFormFocusNode.unfocus();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                                : changeNameLoading ?
                                            SizedBox(
                                                width: 0.5,
                                                height: 0.5,
                                                child: Padding(padding: const EdgeInsets.all(10.0), child: CircularProgressIndicator(
                                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                                      fontColorOnBackground),
                                                  strokeWidth: 3.0,
                                                )))
                                                : Icon(
                                              DevoloIcons.ic_edit_24px,
                                              color: fontColorOnBackground,
                                            ),
                                          ),
                                          onChanged: (value) {
                                            newName = value;
                                          },
                                          onEditingComplete: () async {
                                            if (newName != selectedDevice.name) {
                                              bool confResponse = await confirmDialog(context, S
                                                  .of(context)
                                                  .deviceNameDialogTitle, S
                                                  .of(context)
                                                  .deviceNameDialogBody, size);
                                              if (confResponse) {
                                                changeNameLoading = true;
                                                socket.sendXML('SetAdapterName', mac: selectedDevice.mac,
                                                    newValue: newName,
                                                    valueType: 'name');
                                                var response = await socket.receiveXML(
                                                    "SetAdapterNameStatus");
                                                if (response!['result'] == "ok") {
                                                  selectedDevice.name = newName;
                                                  await Future.delayed(
                                                      const Duration(seconds: 1), () {});
                                                  socket.sendXML('RefreshNetwork');
                                                } else if (response['result'] == "timeout") {
                                                  errorDialog(context, S
                                                      .of(context)
                                                      .deviceNameErrorTitle, S
                                                      .of(context)
                                                      .deviceNameErrorBody, size);
                                                } else if (response['result'] == "device_not_found") {
                                                  errorDialog(context, S
                                                      .of(context)
                                                      .deviceNameErrorTitle, S
                                                      .of(context)
                                                      .deviceNotFoundDeviceName + "\n\n" + S
                                                      .of(context)
                                                      .deviceNotFoundHint, size);
                                                }

                                                changeNameLoading = false;
                                              }
                                            }
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return S
                                                  .of(context)
                                                  .pleaseEnterDeviceName;
                                            }
                                            return null;
                                          },
                                        ),

                                      ]),
                                      if(selectedDevice.type != "")...[
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: SelectableText(
                                                  "${S.of(context).type}:",
                                                  style: TextStyle(color: fontColorOnBackground),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: SelectableText(
                                                selectedDevice.type,
                                                style: TextStyle(color: fontColorOnBackground)
                                            ),
                                          ),
                                        ]),
                                      ],
                                      if(selectedDevice.serialno != "")...[
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: SelectableText(
                                                  "${S.of(context).serialNumber}:",
                                                  style: TextStyle(color: fontColorOnBackground),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: SelectableText(selectedDevice.serialno,
                                                style: TextStyle(color: fontColorOnBackground)),
                                          ),
                                        ]),
                                      ],
                                      if(selectedDevice.version != "" || selectedDevice.versionDate != "")...[
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                "${S.of(context).version}:",
                                                style: TextStyle(color: fontColorOnBackground),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: SelectableText(
                                                selectedDevice.version + " (" + selectedDevice.versionDate +
                                                    ")",
                                                style: TextStyle(color: fontColorOnBackground)),
                                          ),
                                        ]),
                                      ],
                                      if(sideInformationEnabled && selectedDevice.ip != "")...[
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                "${S.of(context).ipAddress}:",
                                                style: TextStyle(color: fontColorOnBackground),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: SelectableText(selectedDevice.ip,
                                                style: TextStyle(color: fontColorOnBackground)),
                                          ),
                                        ]),
                                      ],
                                      if(sideInformationEnabled && selectedDevice.mac != "")...[
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                "${S.of(context).macAddress}:",
                                                style: TextStyle(color: fontColorOnBackground),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: (selectedDevice.networkType == "wifi:other" && selectedDevice.mac[0]=="0" && selectedDevice.mac[1]=="1") ? null : SelectableText(selectedDevice.mac,style: TextStyle(color: fontColorOnBackground)),  //don´t display multicast address
                                          ),
                                        ]),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: deviceInfoActionsPadding),

                                  if(selectedDevice.webinterfaceAvailable)...[
                                    ListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      leading: Icon(
                                        DevoloIcons.devolo_UI_internet,
                                        size: 24 * size.icon_factor,
                                      ),
                                      title: Text(
                                        S.of(context).launchWebInterface,
                                        textScaleFactor: size.font_factor,
                                      ),
                                      iconColor: fontColorOnBackground,
                                      textColor: fontColorOnBackground,
                                      onTap: () {
                                        launchURL(selectedDevice.webinterfaceURL);
                                      },
                                    ),
                                  ],
                                  if(selectedDevice.identifyDeviceAvailable)...[
                                    Divider(height: dividerHeight, color: fontColorOnBackground),
                                    ListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      leading: Icon(
                                        DevoloIcons.devolo_icon_ui_led,
                                        size: 24 * size.icon_factor,
                                      ),
                                      title: Text(
                                        S.of(context).identifyDevice,
                                        textScaleFactor: size.font_factor,
                                      ),
                                      iconColor: fontColorOnBackground,
                                      textColor: fontColorOnBackground,
                                      onTap: () async {

                                        identifyDeviceActionRunning = true;
                                        Timer(
                                            Duration(seconds: 120),
                                                () {
                                              identifyDeviceActionRunning = false;
                                            }
                                        );

                                        socket.sendXML('IdentifyDevice',
                                            mac: selectedDevice.mac);
                                        var response = await socket.receiveXML(
                                            "IdentifyDeviceStatus");
                                        if (response!['result'] ==
                                            "device_not_found") {
                                          identifyDeviceActionRunning = false;
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
                                          identifyDeviceActionRunning = false;
                                          errorDialog(context, S
                                              .of(context)
                                              .identifyDeviceErrorTitle, S
                                              .of(context)
                                              .identifyDeviceErrorBody, size);
                                        }
                                      },
                                    ),
                                  ],
                                  if(selectedDevice.supportedVDSL.isNotEmpty)...[
                                    Divider(height: dividerHeight, color: fontColorOnBackground),
                                    ListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      leading: Icon(
                                        DevoloIcons.ic_router_24px,
                                        size: 24 * size.icon_factor,
                                      ),
                                      title: Text(
                                        S.of(context).setVdslCompatibility,
                                        textScaleFactor: size.font_factor,
                                      ),
                                      iconColor: fontColorOnBackground,
                                      textColor: fontColorOnBackground,
                                      onTap: () {
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
                                      },
                                    ),
                                  ],
                                  Divider(height: dividerHeight, color: fontColorOnBackground),
                                  ListTile(
                                    hoverColor: Colors.white.withOpacity(0.2),
                                    leading: Icon(
                                      DevoloIcons.ic_find_in_page_24px,
                                      size: 24 * size.icon_factor,
                                    ),
                                    title: Text(
                                      S.of(context).showManual,
                                      textScaleFactor: size.font_factor,
                                    ),
                                    iconColor: fontColorOnBackground,
                                    textColor: fontColorOnBackground,
                                    onTap: () async {
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
                                        searchManualDialog(context, socket,selectedDevice.MT, size);
                                      }
                                    },
                                  ),
                                  if(sideInformationEnabled && selectedDevice.disableLeds[0] == 1)...[
                                    Divider(height: dividerHeight, color: fontColorOnBackground),
                                    SwitchListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      title: Text(S.of(context).activateLEDs,
                                        style: TextStyle(color: fontColorOnBackground),
                                        textScaleFactor: size.font_factor
                                      ),
                                      value: selectedDevice.disableLeds[1] == 0 ? true : false,
                                      onChanged: (bool value) async {
                                        String newStatus = value ? "0" : "1";
                                        socket.sendXML('DisableLEDs', newValue: newStatus,
                                            valueType: 'state',
                                            mac: selectedDevice.mac);
                                        circularProgressIndicatorInMiddle(context);
                                        var response = await socket.receiveXML(
                                            "DisableLEDsStatus");
                                        if (response!['result'] == "ok") {
                                          selectedDevice.disableLeds[1] = value ? 0 : 1;
                                          Navigator.maybeOf(context)!.pop();
                                        }
                                        else {
                                          Navigator.maybeOf(context)!.pop();
                                          errorDialog(context, S
                                              .of(context)
                                              .activateLEDsFailedTitle, S
                                              .of(context)
                                              .activateLEDsFailedBody, size);
                                        }
                                      },
                                      secondary: Icon(DevoloIcons.ic_lightbulb_outline_24px,
                                          color: fontColorOnBackground,
                                          size: 24 * size.font_factor),
                                      activeTrackColor: devoloGreen.withOpacity(0.4),
                                      activeColor: devoloGreen,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Color(0x61000000),
                                    ),
                                  ],
                                  if(sideInformationEnabled && selectedDevice.disableTraffic[0] == 1)...[
                                    Divider(height: dividerHeight, color: fontColorOnBackground),
                                    SwitchListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      title: Text(S.of(context).activateTransmission,
                                          style: TextStyle(color: fontColorOnBackground),
                                          textScaleFactor: size.font_factor
                                      ),
                                      value: selectedDevice.disableTraffic[1] == 0 ? true : false,
                                      onChanged: (bool value) async {
                                        String newStatus = value ? "0" : "1";
                                        socket.sendXML('DisableTraffic', newValue: newStatus,
                                            valueType: 'state',
                                            mac: selectedDevice.mac);
                                        circularProgressIndicatorInMiddle(context);
                                        var response = await socket.receiveXML(
                                            "DisableTrafficStatus");
                                        if (response!['result'] == "ok") {
                                          selectedDevice.disableTraffic[1] = value ? 0 : 1;
                                          Navigator.maybeOf(context)!.pop();
                                        }
                                        else {
                                          Navigator.maybeOf(context)!.pop();
                                          errorDialog(context, S
                                              .of(context)
                                              .activateTransmissionFailedTitle, S
                                              .of(context)
                                              .activateTransmissionFailedBody, size);
                                        }
                                      },
                                      secondary: Icon(DevoloIcons.ic_perm_data_setting_24px,
                                          color: fontColorOnBackground,
                                          size: 24 * size.font_factor),
                                      activeTrackColor: devoloGreen.withOpacity(0.4),
                                      activeColor: devoloGreen,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Color(0x61000000),
                                    ),
                                  ],
                                  if(sideInformationEnabled && selectedDevice.disableStandby[0] == 1)...[
                                    Divider(height: dividerHeight, color: fontColorOnBackground),
                                    SwitchListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      title: Text(S.of(context).powerSavingMode,
                                          style: TextStyle(color: fontColorOnBackground),
                                          textScaleFactor: size.font_factor
                                      ),
                                      value: selectedDevice.disableStandby[1] == 0 ? true : false,
                                      onChanged: (bool value) async {
                                        String newStatus = value ? "0" : "1";
                                        socket.sendXML('DisableStandby', newValue: newStatus,
                                            valueType: 'state',
                                            mac: selectedDevice.mac);
                                        circularProgressIndicatorInMiddle(context);
                                        var response = await socket.receiveXML(
                                            "DisableStandbyStatus");
                                        if (response!['result'] == "ok") {
                                          selectedDevice.disableStandby[1] = value ? 0 : 1;
                                          Navigator.maybeOf(context)!.pop();
                                        }
                                        else {
                                          Navigator.maybeOf(context)!.pop();
                                          errorDialog(context, S
                                              .of(context)
                                              .powerSavingModeFailedTitle, S
                                              .of(context)
                                              .powerSavingModeFailedBody, size);
                                        }
                                      },
                                      secondary: Icon(DevoloIcons.ic_battery_charging_full_24px,
                                          color: fontColorOnBackground,
                                          size: 24 * size.font_factor),
                                      activeTrackColor: devoloGreen.withOpacity(0.4),
                                      activeColor: devoloGreen,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Color(0x61000000),
                                    ),
                                  ],
                                  if(sideInformationEnabled)...[
                                    Divider(height: dividerHeight, color: fontColorOnBackground),
                                    ListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      leading: Icon(
                                        DevoloIcons.devolo_UI_delete,
                                        size: 24 * size.icon_factor,
                                      ),
                                      title: Text(
                                        S.of(context).removeDevice,
                                        textScaleFactor: size.font_factor,
                                      ),
                                      iconColor: fontColorOnBackground,
                                      textColor: fontColorOnBackground,
                                      onTap: () async {
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
                                      },
                                    ),
                                  ],
                                  if(sideInformationEnabled)...[
                                    Divider(height: dividerHeight, color: fontColorOnBackground),
                                    ListTile(
                                      hoverColor: Colors.white.withOpacity(0.2),
                                      leading: Icon(
                                        DevoloIcons.ic_file_upload_24px,
                                        size: 24 * size.icon_factor,
                                      ),
                                      title: Text(
                                        S.of(context).factoryReset,
                                        textScaleFactor: size.font_factor,
                                      ),
                                      iconColor: fontColorOnBackground,
                                      textColor: fontColorOnBackground,
                                      onTap: () async {
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
                                      },
                                    ),
                                  ],
                                  IconButton(
                                    icon: Icon(sideInformationEnabled ? DevoloIcons.devolo_UI_chevron_up : DevoloIcons.devolo_UI_chevron_down),
                                    color: fontColorOnBackground,
                                    onPressed: (){
                                      setState(() {
                                        sideInformationEnabled = !sideInformationEnabled;
                                      });
                                    },
                                  ),
                                ]),),),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child:
                          IconButton(
                            splashRadius: 15 * size.icon_factor,
                            iconSize: 24 * size.icon_factor,
                            color: fontColorOnBackground,
                            icon: Icon(DevoloIcons.devolo_UI_cancel_2),
                            onPressed: (){
                              setState(() {
                                selectedDeviceIndex = 999;
                                _deviceList.pivotDeviceIndexList[_deviceList.selectedNetworkIndex] = 0;
                              });
                            },

                          ),),
                      ],
                    ),
                  ),
                ),
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

  void searchManualDialog(context, DataHand socket, String mtNumber, SizeModel size) async {

    bool confResponse = await confirmDialog(context, S.of(context).manualErrorTitle, S.of(context).searchManualConfirmBody, size);
    if(confResponse) {
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              contentTextStyle: TextStyle(color: fontColorOnBackground,
                  decorationColor: fontColorOnBackground,
                  fontSize: dialogContentTextFontSize * size.font_factor),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: CircularProgressIndicator(
                        color: fontColorOnBackground),
                    height: 50.0,
                    width: 50.0,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    S
                        .of(context)
                        .searchManualAndUpdates,
                    style: TextStyle(color: fontColorOnBackground),
                  ),
                ],
              ),
              actions: <Widget>[],
            );
          });

      socket.sendXML('UpdateCheck');
      var response = await socket.receiveXML(
          "UpdateIndication && FirmwareUpdateIndication");

      if (response!["status"] != null &&
          response["status"] == "downloaded_other") {
        socket.sendXML('GetManual', newValue: mtNumber,
            valueType: 'product',
            newValue2: config["language"],
            valueType2: 'language');
        var response = await socket.receiveXML("GetManualResponse");

        if (response!['filename'] != "") {
          Navigator.pop(context, true);
          openFile(response['filename']);
        }
        else {
          Navigator.pop(context, true);
          errorDialog(context, S
              .of(context)
              .manualErrorTitle, S
              .of(context)
              .manualErrorBody, size);
        }
      }
      else {
        Navigator.pop(context, true);
        errorDialog(context, S
            .of(context)
            .manualErrorTitle, S
            .of(context)
            .manualErrorBody, size);
      }
    }
  }

  void _checkIfDeviceIsHovered(PointerEvent details, NetworkList _deviceList, double width, double height) {

    var index = 0;
    var deviceGotHovered = false;
    for (Offset deviceIconOffset in _painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length, width, height)) {
      if (index > _painter.numberFoundDevices) //do not check invisible circles
        break;

      //test if device got hovered
      if (_painter.isPointInsideCircle(details.localPosition, deviceIconOffset, _painter.deviceCircleRadius)){
        deviceGotHovered = true;
        if(!hoveredDevice){
          setState(() {
            hoveredDevice = true;
            return;
          });
        }
      }
      index++;
    }

    if(!deviceGotHovered && hoveredDevice){
      setState(() {
        hoveredDevice = false;
      });
    }


  }
  void _handleTap(TapUpDetails details, NetworkList _deviceList, width, height) {

    int index = 0;
    identifyDeviceActionRunning = false;

    for (Offset deviceIconOffset in _painter.getDeviceIconOffsetList(_deviceList.getDeviceList().length, width, height)) {
      if (index > _painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = deviceIconOffset;

      //test if device got clicked
      if (_painter.isPointInsideCircle(details.localPosition, absoluteOffset, _painter.deviceCircleRadius)) {

        logger.i("Clicked icon #" + index.toString());

        setState(() {
          selectedDevice = _deviceList.getDeviceList()[index];
          selectedDeviceIndex = index;
          textFieldController.text = selectedDevice.name;

          _deviceList.pivotDeviceIndexList[_deviceList.selectedNetworkIndex] = index;

        });
        break;
      }
      index++;
    }
  }
}
