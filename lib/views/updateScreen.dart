/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:async';
import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
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
  bool _loadingCockpit = false;
  bool _loadingSoftware = false;
  DateTime _lastPoll = DateTime.now();

  bool _changeNameLoading = false;

  final _scrollController = ScrollController();
  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  Future<void> updateCockpit(socket, _deviceList) async {

    setState(() {
      socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
      _deviceList.cockpitUpdate = false;

    });
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

    fontSize = context.watch<FontSize>();

    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Text(
              S.of(context).updates,
              style: TextStyle(fontSize: fontSizeAppBarTitle - 5 * fontSize.factor, color: fontColorOnBackground),
              textAlign: TextAlign.start,
            ),
            Divider(
              color: fontColorOnBackground,
            ),
          ],
        ),
        //centerTitle: true,
        backgroundColor: backgroundColor,
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
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0))),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 35, vertical: 18)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return devoloGreen.withOpacity(hoverOpacity);
                        } else if (states.contains(MaterialState.pressed)) {
                          return devoloGreen.withOpacity(activeOpacity);
                        }
                        return (_loading == true || _loadingCockpit == true || _loadingSoftware == true)? buttonDisabledBackground : devoloGreen;
                      },
                    ),
                    foregroundColor: (_loading == true || _loadingCockpit == true || _loadingSoftware == true)
                        ? MaterialStateProperty.all<Color>(buttonDisabledForeground)
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: (_loading == true || _loadingCockpit == true || _loadingSoftware == true)? null : () async {

                    // Warning! "UpdateCheck" and "RefreshNetwork" should only be triggered by a user interaction, not continously/automaticly
                    setState(() {
                      socket.sendXML('UpdateCheck');
                      _loading = true;
                      _loadingCockpit = true;
                    });

                    var response1 = await socket.receiveXML("UpdateIndication");
                    setState(() {
                      _loadingCockpit = false;
                      //if (response!["messageType"] != null) _lastPoll = DateTime.now();
                    });
                    var response2 = await socket.receiveXML("FirmwareUpdateIndication");
                    setState(() {
                      _loading = false;
                      //if (response!["messageType"] != null) _lastPoll = DateTime.now();
                    });
                  },
                  child: Row(children: [
                    Icon(
                      DevoloIcons.ic_refresh_24px,
                      color: fontColorOnMain,
                      size: 24 * fontSize.factor,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0))),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 30, vertical: 18)),
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return BorderSide(color: drawingColor.withOpacity(hoverOpacity), width: 2.0);
                          } else if (states.contains(MaterialState.pressed)) {
                            return BorderSide(color: drawingColor.withOpacity(activeOpacity), width: 2.0);
                          }
                          return (_loading == true || _loadingCockpit == true || _loadingSoftware == true || (_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                          ? BorderSide(color: buttonDisabledForeground2, width: 2.0)
                          : BorderSide(color: drawingColor, width: 2.0);
                        },
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.transparent;
                          } else if (states.contains(MaterialState.pressed)) {
                            return drawingColor;
                          }
                          return Colors.transparent;
                        },
                      ),
                      foregroundColor: (_loading == true || _loadingCockpit == true || _loadingSoftware == true || (_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                          ? MaterialStateProperty.all<Color?>(buttonDisabledForeground2)
                          : MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return drawingColor.withOpacity(hoverOpacity);
                          } else if (states.contains(MaterialState.pressed)) {
                            return drawingColor;
                          }
                          return drawingColor;
                        },
                      ),
                    ),
                    onPressed: (_loading == true || _loadingCockpit == true || _loadingSoftware == true || (_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                        ? null
                        : () async {
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
                        DevoloIcons.ic_file_download_24px,
                        size: 24 * fontSize.factor,
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
                TableRow(
                    decoration: BoxDecoration(
                        color: mainColor,
                        border: Border(
                          bottom: BorderSide(color: fontColorOnMain),
                        )
                    ),
                    children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).state,
                        style: TextStyle(color: fontColorOnMain),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        DevoloIcons.devolo_UI_chevron_down,
                        color: fontColorOnMain,
                      )
                    ],
                  ),
                  TableCell(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 1.0),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1.0, color: backgroundColor),
                          ),
                        ),
                        child: Text(
                          S.of(context).name,
                          style: TextStyle(color: fontColorOnMain),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  TableCell(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 1.0),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1.0, color: backgroundColor),
                          ),
                        ),
                        child: Text(
                          S.of(context).currentVersion,
                          style: TextStyle(color: fontColorOnMain),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  TableCell(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 1.0, color: backgroundColor),
                        ),
                      ),
                      child: Text(
                        S.of(context).state,
                        style: TextStyle(color: fontColorOnMain),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                ]),
              ],
            ),
            Expanded(
              child: SingleChildScrollView (
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
                      child: _loadingCockpit
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
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
                                        DevoloIcons.devolo_UI_check_fill,
                                        color: devoloGreen,
                                      ),
                                      iconSize: 24 * fontSize.factor,
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
                                          DevoloIcons.ic_file_download_24px,
                                          color: fontColorOnBackground,
                                        ),
                                        iconSize: 24 * fontSize.factor,
                                        onPressed: () async {
                                          await updateCockpit(socket, _deviceList);
                                        }),
                                  ],
                                ),
                    ),
                    TableCell(
                      child: ListTile(
                        horizontalTitleGap: 1,
                        leading: Icon(
                          Icons.speed_rounded,
                          color: fontColorOnBackground,
                          size: 24.0 * fontSize.factor,
                        ),
                        title: Text(
                          "Cockpit Software",
                          style: TextStyle(color: fontColorOnBackground, fontSize: 18),
                          textAlign: TextAlign.center,
                          textScaleFactor: fontSize.factor,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "",
                        style: TextStyle(color: fontColorOnBackground),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: _loadingCockpit
                          ? SelectableText(
                              " ${S.of(context).searching}",
                              style: TextStyle(color: fontColorOnBackground),
                              textAlign: TextAlign.center,
                            )
                          : _deviceList.cockpitUpdate == false
                              ? Text(
                                  " ${S.of(context).upToDate}",
                                  style: TextStyle(color: fontColorOnBackground),
                                  textAlign: TextAlign.center,
                                )
                              : Row(
                                  children: [
                                    FlatButton(
                                        child: Text(
                                          S.of(context).update2,
                                          style: TextStyle(color: fontColorOnBackground, fontSize: 20 * fontSize.factor),
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
                    TableRow(decoration: BoxDecoration(color: i % 2 == 0 ? accentColor : Colors.transparent), children: [
                      TableCell(
                        child: _loading
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
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
                                          DevoloIcons.devolo_UI_check_fill,
                                          color: devoloGreen,
                                        ),
                                        iconSize: 24 * fontSize.factor,
                                        onPressed: () {},
                                        // tooltip: "already uptodate",
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            DevoloIcons.ic_file_download_24px,
                                            color: fontColorOnBackground,
                                          ),
                                          iconSize: 24 * fontSize.factor,
                                          onPressed: () async {
                                            await updateCockpit(socket, _deviceList);
                                          }),
                                      if (_loadingSoftware)
                                        CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
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
                              height: 35 * fontSize.factor,
                            ),
                            title: Text(
                              _deviceList.getAllDevices()[i].name,
                              style: TextStyle(fontWeight: FontWeight.bold, color: fontColorOnBackground, fontSize: 17,),
                              textAlign: TextAlign.center,
                              textScaleFactor: fontSize.factor,
                            ),
                            subtitle: Text(
                              '${_deviceList.getAllDevices()[i].type}',
                              style: TextStyle(color: fontColorOnBackground, fontSize: 17,),
                              textAlign: TextAlign.center,
                              textScaleFactor: fontSize.factor,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          _deviceList.getAllDevices()[i].version,
                          style: TextStyle(color: fontColorOnBackground),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TableCell(
                        child: _loading
                            ? SelectableText(
                                " ${S.of(context).searching}",
                                style: TextStyle(color: fontColorOnBackground),
                                textAlign: TextAlign.center,
                              )
                            : _deviceList.cockpitUpdate == false
                                ? Text(
                                    " ${S.of(context).upToDate}",
                                    style: TextStyle(color: fontColorOnBackground),
                                    textAlign: TextAlign.center,
                                  )
                                : Row(
                                    children: [
                                      FlatButton(
                                          child: Text(
                                            S.of(context).update2,
                                            style: TextStyle(color: fontColorOnBackground, fontSize: 20 * fontSize.factor),
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
    deviceInformationDialog(context, dev, myFocusNode, socket, fontSize);

  }
}
