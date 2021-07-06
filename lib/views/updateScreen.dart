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
import 'package:cockpit_devolo/shared/alertDialogs.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
import 'package:cockpit_devolo/shared/informationDialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';

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

  double splashRadius = 18;
  double opacity = 0.2;
  Color splashColor = fontColorOnBackground.withOpacity(0.2);

  /* ===========  =========== */

  final String title;

  bool _searchingDeviceUpdate = false;
  bool _searchingCockpitUpdate = false;
  List<String> _upgradingDevicesList = [];
  bool _upgradingCockpit = false;

  bool _changeNameLoading = false;

  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  Future<void> updateCockpit(socket, _deviceList) async {

    setState(() {
      socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
      _deviceList.cockpitUpdate = false;
      _upgradingCockpit = false;
    });
  }

  Future<void> updateAllDevices(DataHand socket, NetworkList _deviceList) async {

    socket.sendXML('FirmwareUpdateResponse', newValue: _deviceList.getUpdateList().toString());

    var response = await socket.receiveXML("FirmwareUpdateStatus");
    setState(() {
      _upgradingDevicesList = [];
    });

    if(response != null && response['failed'] != null){

      String macs = "\n";
      for(var mac in response['failed']){
        if(_deviceList.getDeviceByMac(mac.toString()) != null){
          macs = "\n- " + _deviceList.getDeviceByMac(mac.toString())!.name + " : " + mac.toString() + "\n";
        }
        else{
          macs = "\n- " + mac.toString() + "\n";
        }
      }

      errorDialog(context, S.of(context).UpdateDeviceFailedTitle, S.of(context).UpdateDeviceFailedBody + macs, fontSize);

    }
  }


  Future<void> updateDevice(socket, mac, NetworkList _deviceList ) async {

    socket.sendXML('FirmwareUpdateResponse', newValue: mac);

    var response = await socket.receiveXML("FirmwareUpdateStatus");
    setState(() {
      _upgradingDevicesList.remove(mac);
    });

    if(response != null && response['failed'] != null){

      String failedDevices;
      if(_deviceList.getDeviceByMac(mac) != null){
        failedDevices = "\n- " + _deviceList.getDeviceByMac(mac)!.name + " : " + response!['failed'].toString() + "\n";
      }
      else{
        failedDevices = "\n- " + mac.toString() + "\n";
      }

      errorDialog(context, S.of(context).UpdateDeviceFailedTitle, S.of(context).UpdateDeviceFailedBody + failedDevices, fontSize);

    }

  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<DataHand>(context);
    var _deviceList = Provider.of<NetworkList>(context);

    fontSize = context.watch<FontSize>();

    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(top: paddingBarTop, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  S.of(context).updates,
                  style: TextStyle(fontSize: (fontSizeAppBarTitle -5) * fontSize.factor, color: fontColorOnBackground),
                  textAlign: TextAlign.start,
                ),
                Divider(
                  color: fontColorOnBackground,
                ),
                SizedBox(height:paddingBarTop),
              ],
            ),
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
                        return (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true)? buttonDisabledBackground : devoloGreen;
                      },
                    ),
                    foregroundColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true)
                        ? MaterialStateProperty.all<Color>(buttonDisabledForeground)
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true)? null : () async {

                    // Warning! "UpdateCheck" and "RefreshNetwork" should only be triggered by a user interaction, not continously/automaticly
                    setState(() {
                      socket.sendXML('UpdateCheck');
                      _searchingDeviceUpdate = true;
                      _searchingCockpitUpdate = true;
                    });

                    var response1 = await socket.receiveXML("UpdateIndication");
                    setState(() {
                      _searchingCockpitUpdate = false;
                      //if (response!["messageType"] != null) _lastPoll = DateTime.now();
                    });
                    var response2 = await socket.receiveXML("FirmwareUpdateIndication");
                    setState(() {
                      _searchingDeviceUpdate = false;
                      //if (response!["messageType"] != null) _lastPoll = DateTime.now();
                    });
                  },
                  child: Row(children: [
                    Icon(
                      DevoloIcons.ic_refresh_24px,
                      color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true) ? buttonDisabledForeground : Colors.white,
                      size: 24 * fontSize.factor,
                    ),
                    Text(
                      S.of(context).checkUpdates, textScaleFactor: fontSize.factor,
                      style:TextStyle(color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true) ? buttonDisabledForeground : Colors.white)
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
                          return (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
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
                      foregroundColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
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
                    onPressed: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                        ? null
                        : () async {

                      if(_deviceList.getUpdateList().length != 0){

                        for(String mac in _deviceList.getUpdateList()) {
                          _upgradingDevicesList.add(mac);
                        }

                        await updateAllDevices(socket, _deviceList);
                      }

                      if(_deviceList.cockpitUpdate){

                        _upgradingCockpit = true;
                        await updateCockpit(socket, _deviceList); //update Cockpit as second as it requires the application to restart
                      }

                    },
                    child: Row(children: [
                      Icon(
                        DevoloIcons.ic_file_download_24px,
                        size: 24 * fontSize.factor,
                      ),
                      Text(
                        " ${S.of(context).updateAll}", textScaleFactor: fontSize.factor,
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
                        textScaleFactor: fontSize.factor,
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
                          textScaleFactor: fontSize.factor,
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
                          textScaleFactor: fontSize.factor,
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
                        textScaleFactor: fontSize.factor,
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
                      child: _searchingCockpitUpdate || _upgradingCockpit
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
                                    Icon(
                                      DevoloIcons.devolo_UI_check_fill,
                                      color: devoloGreen,
                                      size: 24 * fontSize.factor,
                                      ),
                                  ],
                                )
                              : new Material(
                                  type: MaterialType.transparency, // used to see the spash color over the background Color of the row
                                  child:
                                    IconButton(
                                        icon: Icon(
                                          DevoloIcons.ic_file_download_24px,
                                          color: fontColorOnBackground,
                                        ),
                                        iconSize: 24 * fontSize.factor,
                                        hoverColor: splashColor,
                                        splashColor: splashColor,
                                        splashRadius: splashRadius * fontSize.factor,
                                        disabledColor: fontColorOnBackground.withOpacity(opacity),
                                        onPressed: _upgradingDevicesList.isNotEmpty
                                            ? null
                                            : () async {
                                          _upgradingCockpit = true;
                                          await updateCockpit(socket, _deviceList);
                                        },
                                        mouseCursor: _upgradingDevicesList.isNotEmpty ? SystemMouseCursors.basic : SystemMouseCursors.click
                                    ),
                                ),
                    ),
                    TableCell(
                      child: ListTile(
                        minLeadingWidth: 1,
                        horizontalTitleGap: 1,
                        dense:true,
                        contentPadding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 15),
                        leading: Icon(
                          Icons.speed_rounded,
                          color: fontColorOnBackground,
                          size: 24.0 * fontSize.factor,
                          textDirection: TextDirection.ltr,
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
                    _searchingCockpitUpdate || _upgradingCockpit
                          ?  TableCell(
                        child: SelectableText(
                          _searchingCockpitUpdate ? " ${S.of(context).searching}" : " ${S.of(context).updating}",
                              style: TextStyle(color: fontColorOnBackground),
                              textAlign: TextAlign.center,
                        textScaleFactor: fontSize.factor,
                            ))
                          : _deviceList.cockpitUpdate == false
                              ?  TableCell(
                        child: Text(
                                  " ${S.of(context).upToDate}",
                                  style: TextStyle(color: fontColorOnBackground),
                                  textAlign: TextAlign.center,
                        textScaleFactor: fontSize.factor,
                                ))
                              :  TableCell(
                      verticalAlignment:TableCellVerticalAlignment.fill,
                      child:TextButton(
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color?>(fontColorOnBackground.withOpacity(opacity))),
                                  child: Text(
                                    S.of(context).update2,
                                    style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () async {
                                    _upgradingCockpit = true;
                                    await updateCockpit(socket, _deviceList);
                                      }),
                    )
                  ]),
                  for (int i = 0; i < _deviceList.getAllDevices().length; i++)
                    TableRow(decoration: BoxDecoration(color: i % 2 == 0 ? accentColor : Colors.transparent), children: [
                      TableCell(
                        child: _searchingDeviceUpdate || _upgradingDevicesList.contains(_deviceList.getAllDevices()[i].mac)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
                                    strokeWidth: 3,
                                  ),
                                ],
                              )
                            : _deviceList.getUpdateList().contains(_deviceList.getAllDevices()[i].mac) == false
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        DevoloIcons.devolo_UI_check_fill,
                                        color: devoloGreen,
                                        size: 24 * fontSize.factor,
                                      ),
                                    ],
                                  )
                                : new Material(
                                    type: MaterialType.transparency, // used to see the spash color over the background Color of the row
                                    child:
                                      IconButton(
                                          hoverColor: splashColor,
                                          splashRadius: splashRadius * fontSize.factor,
                                          splashColor: splashColor,
                                          color: fontColorOnBackground,
                                          icon: Icon(
                                            DevoloIcons.ic_file_download_24px,
                                          ),
                                          iconSize: 24 * fontSize.factor,
                                          onPressed: () async {
                                            _upgradingDevicesList.add(_deviceList.getAllDevices()[i].mac);
                                            await updateDevice(socket, _deviceList.getAllDevices()[i].mac, _deviceList);
                                          }),

                                  ),
                      ),
                      TableCell(
                        child: new Material(
                          type: MaterialType.transparency, // used to see the spash color over the background Color of the row
                          child:Container(
                            //alignment: Alignment.centerLeft,
                            child: ListTile(
                              hoverColor: fontColorOnBackground.withOpacity(opacity),
                              //contentPadding: EdgeInsets.only(left:20),
                              horizontalTitleGap: 1,
                              minLeadingWidth: 1,
                              onTap: () => _handleTap(_deviceList.getAllDevices()[i]),
                              leading: RawImage(
                                image: getIconForDeviceType(_deviceList.getAllDevices()[i].typeEnum),
                                scale: fontSize.factor,
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
                      ),
                      TableCell(
                        child: Text(
                          _deviceList.getAllDevices()[i].version,
                          style: TextStyle(color: fontColorOnBackground),
                          textAlign: TextAlign.center,
                          textScaleFactor: fontSize.factor,
                        ),
                      ),
                       _searchingDeviceUpdate || _upgradingDevicesList.contains(_deviceList.getAllDevices()[i].mac)
                            ? TableCell(
                            child:SelectableText(
                                _searchingDeviceUpdate
                                    ? " ${S.of(context).searching}"
                                    : _deviceList.getAllDevices()[i].updateState == "complete"
                                      ?" ${S.of(context).update} : ${S.of(context).complete}"
                                      : _deviceList.getAllDevices()[i].updateState == "pending"
                                        ?" ${S.of(context).update} : ${S.of(context).pending}"
                                        : _deviceList.getAllDevices()[i].updateState == "failed"
                                          ?" ${S.of(context).update} : ${S.of(context).failed}"
                                          :" ${S.of(context).update} : ${ _deviceList.getAllDevices()[i].updateState}%",
                                style: TextStyle(color: fontColorOnBackground),
                                textAlign: TextAlign.center,
                                textScaleFactor: fontSize.factor,
                              ))
                            : _deviceList.getUpdateList().contains(_deviceList.getAllDevices()[i].mac) == false
                                ? TableCell(
                         child:Text(
                                    " ${S.of(context).upToDate}",
                                    style: TextStyle(color: fontColorOnBackground),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: fontSize.factor,
                            textHeightBehavior:TextHeightBehavior()
                                  ))
                                : TableCell(
                                    verticalAlignment:TableCellVerticalAlignment.fill,
                                    child:TextButton(
                                    style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color?>(fontColorOnBackground.withOpacity(opacity))),
                                    child: Text(
                                      S.of(context).update2,
                                      style: TextStyle(color: fontColorOnBackground, fontSize: 14 * fontSize.factor),
                                    ),
                                    onPressed: () async {
                                      _upgradingDevicesList.add(_deviceList.getAllDevices()[i].mac);
                                      await updateDevice(socket, _deviceList.getAllDevices()[i].mac, _deviceList);
                                    }),
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
