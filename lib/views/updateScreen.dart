/*
Copyright © 2021, devolo AG
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
import 'package:cockpit_devolo/shared/informationDialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';
import 'dart:ui' as ui;

class UpdateScreen extends StatefulWidget {
  UpdateScreen({Key? key, required this.title, NetworkList? deviceList}) : super(key: key);

  final String title;

  int networkIndex = 0;

  @override
  _UpdateScreenState createState() => _UpdateScreenState(title: title);
}

class _UpdateScreenState extends State<UpdateScreen> {
  _UpdateScreenState({required this.title});

  /* =========== Styling =========== */

  double paddingContentTop = 10;

  /* ===========  =========== */

  final String title;

  bool _loading = false;
  bool _loadingSoftware = false;
  DateTime _lastPoll = DateTime.now();

  bool _changeNameLoading = false;

  final _scrollController = ScrollController();
  FocusNode myFocusNode = new FocusNode();

  Future<void> updateCockpit(socket, _deviceList) async {
    setState(() {
      socket.sendXML('UpdateCheck');
      //_loading = socket.waitingResponse;
    });
    var responseUpdateIndication = await socket.receiveXML("UpdateIndication");
    var responseFirmwareUpdateIndication = await socket.receiveXML("FirmwareUpdateIndication");

    //logger.i(responseUpdateIndication);
    //logger.i(responseFirmwareUpdateIndication);

    Timer(Duration(seconds: 4), () {
      setState(() {
        socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
        //_loadingFW = socket.waitingResponse;
        _loadingSoftware = false;
      });
    });

    _deviceList.cockpitUpdate = false;
  }

  Future<void> updateDevices(socket, _deviceList) async {
    setState(() {
      for (var mac in _deviceList.getUpdateList()) {
        socket.sendXML('FirmwareUpdateResponse', newValue: mac);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<DataHand>(context);
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
                      _loading = true;
                    });
                    //var response = await socket.receiveXML(["UpdateIndication", "FirmwareUpdateIndication"]);// "UpdateIndication", "FirmwareUpdateIndication"
                    var response1 = await socket.receiveXML("UpdateIndication");
                    var response2 = await socket.receiveXML("FirmwareUpdateIndication");
                    setState(() {
                      _loading = false;
                      //if (response!["messageType"] != null) _lastPoll = DateTime.now();
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
                      //logger.i("Updating ${device.mac}");
                      await updateCockpit(socket, _deviceList);
                      Timer(Duration(seconds: 4), () {});
                      setState(() {
                        socket.sendXML('UpdateCheck');
                        //_loading = socket.waitingResponse;
                      });
                      var responseUpdateIndication = await socket.receiveXML("UpdateIndication");
                      var responseFirmwareUpdateIndication = await socket.receiveXML("FirmwareUpdateIndication");

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
              height: 35,
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
                          : _deviceList.cockpitUpdate == false
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
                          style: TextStyle(color: fontColorLight, fontSize: 18),
                          textAlign: TextAlign.center,
                          textScaleFactor: fontSizeFactor,
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
                          : _deviceList.cockpitUpdate == false
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
                            : _deviceList.cockpitUpdate == false
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
                              style: TextStyle(fontWeight: FontWeight.bold, color: fontColorLight, fontSize: 17,),
                              textAlign: TextAlign.center,
                              textScaleFactor: fontSizeFactor,
                            ),
                            subtitle: Text(
                              '${_deviceList.getAllDevices()[i].type}',
                              style: TextStyle(color: fontColorLight, fontSize: 17,),
                              textAlign: TextAlign.center,
                              textScaleFactor: fontSizeFactor,
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
                            : _deviceList.cockpitUpdate == false
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
    //logger.i('entering dialog....');

    final socket = Provider.of<DataHand>(context, listen: false);

    //openDialog
    deviceInformationDialog(context, dev, myFocusNode, socket);

  }
}
