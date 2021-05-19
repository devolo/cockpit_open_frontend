/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:async';
import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'dart:ui' as ui;

class UpdateScreen extends StatefulWidget {
  UpdateScreen({Key key, this.title, NetworkList deviceList}) : super(key: key);

  final String title;

  int networkIndex = 0;

  @override
  _UpdateScreenState createState() => _UpdateScreenState(title: title);
}

class _UpdateScreenState extends State<UpdateScreen> {
  _UpdateScreenState({this.title});

  /* =========== Styling =========== */

  double paddingContentTop = 10;

  /* ===========  =========== */

  final String title;

  bool _loading = false;
  bool _loadingSoftware = false;
  bool _loadingFW = false;
  DateTime _lastPoll = DateTime.now();

  bool _changeNameLoading = false;

  final _scrollController = ScrollController();
  FocusNode myFocusNode = new FocusNode();

  Future<void> updateCockpit(socket, _deviceList) async {
    setState(() {
      socket.sendXML('UpdateCheck');
      //_loading = socket.waitingResponse;
    });
    var response = await socket.recieveXML(["UpdateIndication", "FirmwareUpdateIndication"]);

    Timer(Duration(seconds: 4), () {
      setState(() {
        socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
        //_loadingFW = socket.waitingResponse;
        _loadingSoftware = false;
      });
    });

    _deviceList.CockpitUpdate = false;
  }

  Future<void> updateDevices(socket, _deviceList) async {
    setState(() {
      for (var mac in _deviceList.getUpdateList()) {
        socket.sendXML('FirmwareUpdateResponse', newValue: mac);
      }
      _loadingFW = socket.waitingResponse;
    });
    var response = await socket.recieveXML(List<String>());
    print('Response: ' + response.toString());
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    var _deviceList = Provider.of<NetworkList>(context);

    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Text(
              S.of(context).updates,
              style: TextStyle(fontSize: fontSizeAppBarTitle - 5 * fontSizeFactor, color: fontColorLight),
              textAlign: TextAlign.start,
            ),
            Divider(
              color: fontColorLight,
            ),
          ],
        ),
        //centerTitle: true,
        backgroundColor: mainColor,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: paddingContentTop, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text(
                //   'Letzte Suche: ${_lastPoll.toString().substring(0, _lastPoll.toString().indexOf("."))}   ',
                //   style: TextStyle(color: fontColorLight),
                // ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0), side: BorderSide(color: devoloGreen))),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 35, vertical: 18)),
                    backgroundColor: MaterialStateProperty.all<Color>(devoloGreen),
                    foregroundColor: MaterialStateProperty.all<Color>(fontColorLight),
                  ),
                  onPressed: () async {
                    // Warning! "UpdateCheck" and "RefreshNetwork" should only be triggered by a user interaction, not continously/automaticly
                    setState(() {
                      socket.sendXML('UpdateCheck');
                      _loading = socket.waitingResponse;
                    });
                    var response = await socket.recieveXML(["UpdateIndication", "FirmwareUpdateIndication"]);
                    setState(() {
                      _loading = socket.waitingResponse;
                      if (response["messageType"] != null) _lastPoll = DateTime.now();
                    });
                  },
                  child: Row(children: [
                    _loading
                        ? CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(fontColorLight),
                          )
                        : Icon(
                            Icons.refresh,
                            color: fontColorLight,
                            size: 24 * fontSizeFactor,
                          ),
                    Text(
                      S.of(context).checkUpdates,
                    ),
                  ]),
                ),
                SizedBox(
                  width: 20,
                ),
                ButtonTheme(
                  minWidth: 270.0,
                  height: 50.0,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0), side: BorderSide(color: fontColorLight, width: 1.5))),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 30, vertical: 18)),
                      //backgroundColor: MaterialStateProperty.all<Color>(),
                      foregroundColor: MaterialStateProperty.all<Color>(fontColorLight),
                    ),
                    onPressed: () async {
                      //print("Updating ${device.mac}");
                      await updateCockpit(socket, _deviceList);
                      Timer(Duration(seconds: 4), () {});
                      setState(() {
                        socket.sendXML('UpdateCheck');
                        //_loading = socket.waitingResponse;
                      });
                      var response = await socket.recieveXML(["UpdateIndication", "FirmwareUpdateIndication"]);

                      await updateDevices(socket, _deviceList);
                    },
                    child: Row(children: [
                      Icon(
                        Icons.download_rounded,
                        color: fontColorLight,
                        size: 24 * fontSizeFactor,
                      ),
                      Text(
                        " ${S.of(context).updateAll}",
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(5),
                3: FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).state,
                        style: TextStyle(color: fontColorLight),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: fontColorLight,
                      )
                    ],
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).name,
                      style: TextStyle(color: fontColorLight),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).currentVersion,
                      style: TextStyle(color: fontColorLight),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).state,
                      style: TextStyle(color: fontColorLight),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              ],
            ),
            Divider(
              color: fontColorLight,
            ),
            Container(
              alignment: Alignment.center,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(5),
                  3: FlexColumnWidth(6),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      child: _loading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(fontColorLight),
                                  strokeWidth: 3,
                                ),
                              ],
                            )
                          : _deviceList.CockpitUpdate == false
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: devoloGreen,
                                      ),
                                      iconSize: 24 * fontSizeFactor,
                                      onPressed: () {},
                                      // tooltip: "already uptodate",
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.download_rounded,
                                          color: mainColor,
                                        ),
                                        iconSize: 24 * fontSizeFactor,
                                        onPressed: () async {
                                          await updateCockpit(socket, _deviceList);
                                        }),
                                    if (_loadingSoftware)
                                      CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(fontColorLight),
                                        strokeWidth: 3,
                                      ),
                                  ],
                                ),
                    ),
                    TableCell(
                      child: ListTile(
                        horizontalTitleGap: 1,
                        leading: Icon(
                          Icons.speed_rounded,
                          color: Colors.white,
                          size: 24.0 * fontSizeFactor,
                        ),
                        title: Text(
                          "Cockpit Software",
                          style: TextStyle(color: fontColorLight),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "",
                        style: TextStyle(color: fontColorLight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: _loading
                          ? SelectableText(
                              " ${S.of(context).searching}",
                              style: TextStyle(color: fontColorLight),
                              textAlign: TextAlign.center,
                            )
                          : _deviceList.CockpitUpdate == false
                              ? Text(
                                  " ${S.of(context).upToDate}",
                                  style: TextStyle(color: fontColorLight),
                                  textAlign: TextAlign.center,
                                )
                              : Row(
                                  children: [
                                    FlatButton(
                                        child: Text(
                                          S.of(context).update2,
                                          style: TextStyle(color: fontColorLight, fontSize: 20 * fontSizeFactor),
                                          textAlign: TextAlign.center,
                                        ),
                                        onPressed: () async {
                                          await updateCockpit(socket, _deviceList);
                                        }),
                                  ],
                                ),
                    ),
                  ]),
                  for (int i = 0; i < _deviceList.getAllDevices().length; i++)
                    TableRow(decoration: BoxDecoration(color: i % 2 == 0 ? accentColor : mainColor), children: [
                      TableCell(
                        child: _loading
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(fontColorLight),
                                    strokeWidth: 3,
                                  ),
                                ],
                              )
                            : _deviceList.CockpitUpdate == false
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.check_circle,
                                          color: devoloGreen,
                                        ),
                                        iconSize: 24 * fontSizeFactor,
                                        onPressed: () {},
                                        // tooltip: "already uptodate",
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.download_rounded,
                                            color: mainColor,
                                          ),
                                          iconSize: 24 * fontSizeFactor,
                                          onPressed: () async {
                                            await updateCockpit(socket, _deviceList);
                                          }),
                                      if (_loadingSoftware)
                                        CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(fontColorLight),
                                        ),
                                    ],
                                  ),
                      ),
                      TableCell(
                        child: Container(
                          //alignment: Alignment.centerLeft,
                          child: ListTile(
                            //contentPadding: EdgeInsets.only(left:20),
                            horizontalTitleGap: 1,
                            minLeadingWidth: 1,
                            onTap: () => _handleTap(_deviceList.getAllDevices()[i]),
                            leading: RawImage(
                              image: getIconForDeviceType(_deviceList.getAllDevices()[i].typeEnum),
                              height: 35 * fontSizeFactor,
                            ),
                            //Icon(Icons.devices),
                            title: Text(
                              _deviceList.getAllDevices()[i].name,
                              style: TextStyle(fontWeight: FontWeight.bold, color: fontColorLight),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              '${_deviceList.getAllDevices()[i].type}',
                              style: TextStyle(color: fontColorLight),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          _deviceList.getAllDevices()[i].version,
                          style: TextStyle(color: fontColorLight),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TableCell(
                        child: _loading
                            ? SelectableText(
                                " ${S.of(context).searching}",
                                style: TextStyle(color: fontColorLight),
                                textAlign: TextAlign.center,
                              )
                            : _deviceList.CockpitUpdate == false
                                ? Text(
                                    " ${S.of(context).upToDate}",
                                    style: TextStyle(color: fontColorLight),
                                    textAlign: TextAlign.center,
                                  )
                                : Row(
                                    children: [
                                      FlatButton(
                                          child: Text(
                                            S.of(context).update2,
                                            style: TextStyle(color: fontColorLight, fontSize: 20 * fontSizeFactor),
                                            textAlign: TextAlign.center,
                                          ),
                                          onPressed: () async {
                                            await updateCockpit(socket, _deviceList);
                                          }),
                                    ],
                                  ),
                      ),
                    ]),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(Device dev) {
    print('entering dialog....');
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

    hitDevice = dev;
    hitDeviceName = dev.name;
    hitDeviceType = dev.type;
    hitDeviceSN = dev.serialno;
    hitDeviceMT = dev.MT;
    hitDeviceVersion = dev.version;
    hitDeviceVersionDate = dev.version_date;
    hitDeviceIp = dev.ip;
    hitDeviceMac = dev.mac;
    hitDeviceAtr = dev.attachedToRouter;
    hitDeviceisLocal = dev.isLocalDevice;
    hitDeviceWebinterface = dev.webinterfaceAvailable;
    hitDeviceIdentify = dev.identifyDeviceAvailable;

    String _newName = hitDeviceName;

    final socket = Provider.of<dataHand>(context, listen: false);

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
                                      if (response['result'] == "ok") {
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
                                  if (response['result'] == "ok") {
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
                                      if (response['result'] == "device_not_found") {
                                        _errorDialog(context, S.of(context).identifyDeviceErrorTitle, S.of(context).deviceNotFoundIdentifyDevice + "\n\n" + S.of(context).deviceNotFoundHint);
                                      }
                                    },
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
                                  var response = await socket.myReceiveXML("GetManualResponse");
                                  if (response['filename'] != "") {
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
                                  if (response['result'] == "device_not_found") {
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
                                  if (response['result'] == "device_not_found") {
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
    index++;
  }

  // Confirmation Dialog with 2 Buttons
  Future<bool> _confirmDialog(context, title, body) async {
    bool returnVal = await showDialog(
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
                      Navigator.of(context).pop(false);
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
                  Navigator.maybeOf(context).pop(true);
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
                    Navigator.maybeOf(context).pop(false);
                    return false;
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
            actions: <Widget>[],
          );
        });
  }
}
