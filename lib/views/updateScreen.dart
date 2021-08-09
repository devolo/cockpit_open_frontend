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
import 'package:cockpit_devolo/shared/helpers.dart';
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
  double verticalPaddingCockpitSoftware = 7;
  double textSpacingUpdateStatus = 5;
  double borderRadiusCheckbox = 3;
  double checkboxScaleAddition = 0;
  Color updateableDevicesColor = devoloOrange.withOpacity(0.6);

  /* ===========  =========== */

  final String title;

  bool _searchingDeviceUpdate = false;
  bool _searchingCockpitUpdate = false;
  List<String> _upgradingDevicesList = [];

  bool _upgradingCockpit = false;
  bool _checkedCockpit = true;

  bool _filterState = true;

  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  Future<void> updateCockpit(socket, _deviceList) async {

    setState(() {
      socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
      _deviceList.cockpitUpdate = false;
      _upgradingCockpit = false;
    });
  }

  Future<void> updateDevices(DataHand socket, NetworkList _deviceList) async {

    logger.d("update following Devices ->" + _deviceList.checkedUpdateMacs.toString());
    socket.sendXML('FirmwareUpdateResponse', newValue: _deviceList.checkedUpdateMacs.toString());

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

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<DataHand>(context);
    var _deviceList = Provider.of<NetworkList>(context);
    fontSize = context.watch<FontSize>();

    logger.i(_deviceList.getUpdateList());

    var allDevices = _filterState ? _deviceList.getAllDevicesFilteredByState() : _deviceList.getAllDevices();

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
                SizedBox(
                  width: 20,
                ),
                Row(
                    children: [
                      Transform.scale(
                        scale: fontSize.factor + checkboxScaleAddition,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                          fillColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.getUpdateList().isEmpty && _deviceList.cockpitUpdate == false)) ? MaterialStateProperty.all(devoloLighterGray) : MaterialStateProperty.all(devoloGreen),
                          checkColor: Colors.white,
                          value: (_deviceList.checkedUpdateMacs.length == _deviceList.getUpdateList().length) & _checkedCockpit,
                          onChanged: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.getUpdateList().isEmpty && _deviceList.cockpitUpdate == false))
                              ? null
                              : (bool? value) {
                            setState(() {
                              if(value != null && value){
                                _deviceList.checkedUpdateMacs.clear();
                                for(String mac in _deviceList.getUpdateList()){
                                  _deviceList.checkedUpdateMacs.add(mac);
                                }
                                if(_deviceList.cockpitUpdate)
                                  _checkedCockpit = true;
                              }
                              else{
                                _deviceList.checkedUpdateMacs.clear();
                                if(_deviceList.cockpitUpdate)
                                  _checkedCockpit = false;
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 2 * fontSize.factor),
                      Text(S.of(context).selectAll,textScaleFactor: fontSize.factor, style: TextStyle(color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.getUpdateList().isEmpty && _deviceList.cockpitUpdate == false)) ? devoloLighterGray : fontColorOnBackground),),
                    ]
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return devoloGreen.withOpacity(hoverOpacity);
                          } else if (states.contains(MaterialState.pressed)) {
                            return devoloGreen.withOpacity(activeOpacity);
                          }
                          return (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.checkedUpdateMacs.isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))? buttonDisabledBackground : devoloGreen;
                        },
                      ),
                      foregroundColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.checkedUpdateMacs.isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                          ? MaterialStateProperty.all<Color>(buttonDisabledForeground)
                          : MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.checkedUpdateMacs.isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                        ? null
                        : () async {

                      if(_deviceList.getUpdateList().isNotEmpty && _deviceList.checkedUpdateMacs.isNotEmpty){

                        for(String mac in _deviceList.checkedUpdateMacs) {
                          _upgradingDevicesList.add(mac);
                        }

                        await updateDevices(socket, _deviceList);
                      }

                      if(_deviceList.cockpitUpdate && _checkedCockpit){

                        _upgradingCockpit = true;
                        await updateCockpit(socket, _deviceList); //update Cockpit as second as it requires the application to restart
                      }

                    },
                    child: Row(children: [
                      Icon(
                        DevoloIcons.ic_file_download_24px,
                        size: 24 * fontSize.factor,
                        color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.checkedUpdateMacs.isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty)) ? buttonDisabledForeground : Colors.white,
                      ),
                      Text(
                        S.of(context).updateSelected, textScaleFactor: fontSize.factor,
                          style:TextStyle(color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.checkedUpdateMacs.isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty)) ? buttonDisabledForeground : Colors.white)
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0))),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 35, vertical: 18)),
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return BorderSide(color: drawingColor.withOpacity(hoverOpacity), width: 2.0);
                        } else if (states.contains(MaterialState.pressed)) {
                          return BorderSide(color: drawingColor.withOpacity(activeOpacity), width: 2.0);
                        }
                        return (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true)
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
                    foregroundColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.checkedUpdateMacs.isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
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
                      size: 24 * fontSize.factor,
                      color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true) ? buttonDisabledForeground : drawingColor,

                    ),
                    Text(
                        S.of(context).checkUpdates, textScaleFactor: fontSize.factor,
                        style:TextStyle(color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true) ? buttonDisabledForeground : drawingColor)
                    ),
                  ]),
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(5),
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
                  TableCell(child: Text(
                    S.of(context).state,
                    textScaleFactor: fontSize.factor,
                    style: TextStyle(color: fontColorOnMain),
                    textAlign: TextAlign.center,
                  ),),
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
                ]),
              ],
            ),
            Expanded(
              child: SingleChildScrollView (
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(5),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(5),
                },
                children: [
                  if(_deviceList.getUpdateList().isEmpty)
                  TableRow(decoration: BoxDecoration(color: _deviceList.cockpitUpdate ? updateableDevicesColor : Colors.transparent), children: [
                    TableCell(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                              _searchingCockpitUpdate || _upgradingCockpit
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Transform.scale(
                                          scale: fontSize.factor - 0.4,
                                          child: CircularProgressIndicator(
                                            valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
                                            strokeWidth: 3,
                                          ),
                                        ),
                                        SizedBox(width: textSpacingUpdateStatus * fontSize.factor),
                                      ],
                                    )
                                  : _deviceList.cockpitUpdate == false
                                      ? Container()
                                      : Row( children: [
                                        Material(
                                          type: MaterialType.transparency, // used to see the splash color over the background Color of the row
                                          child:
                                          Transform.scale(
                                            scale: fontSize.factor,
                                            child: Checkbox(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                                              checkColor: Colors.white,
                                              fillColor: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate) ? MaterialStateProperty.all(devoloLighterGray) : MaterialStateProperty.all(devoloGreen),
                                              value: _checkedCockpit,
                                              onChanged: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate)
                                                  ? null
                                                  : (bool? value) {
                                                    setState(() {
                                                      if(value != null && value){
                                                        _checkedCockpit = true;
                                                      }
                                                      else{
                                                        _checkedCockpit = false;
                                                      }
                                                    });
                                                    },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: textSpacingUpdateStatus * fontSize.factor)
                                        ]),

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
                                    "${S.of(context).upToDate}",
                                    style: TextStyle(color: fontColorOnBackground),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: fontSize.factor,
                                  ))
                                  :  TableCell(
                                child: Text(
                                  S.of(context).updateAvailable,
                                  style: TextStyle(color: fontColorOnBackground),
                                  textAlign: TextAlign.center,
                                  textScaleFactor: fontSize.factor,
                                ),
                              )
                    ]),
                    ),
                    TableCell(

                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: verticalPaddingCockpitSoftware),
                        child:ListTile(

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
                    ),
                    TableCell(
                      child: Text(
                        "",
                        style: TextStyle(color: fontColorOnBackground),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
                  for (int i = 0; i < allDevices.length; i++)
                    TableRow(decoration: BoxDecoration(color: _deviceList.getUpdateList().contains(allDevices[i].mac) ? updateableDevicesColor : i % 2 == 0 ? accentColor : Colors.transparent), children: [
                      TableCell(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center ,
                            children: [ _searchingDeviceUpdate || _upgradingDevicesList.contains(allDevices[i].mac)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: fontSize.factor - 0.4,
                                    child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  SizedBox(width: textSpacingUpdateStatus * fontSize.factor),
                                ],)
                            : _deviceList.getUpdateList().contains(allDevices[i].mac) == false
                                ? Container()
                                : Row (children:[
                                    Material(
                                      type: MaterialType.transparency, // used to see the spash color over the background Color of the row
                                      child:
                                      Transform.scale(
                                        scale: fontSize.factor + checkboxScaleAddition,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                                          checkColor: Colors.white,
                                          fillColor: (_upgradingDevicesList.isNotEmpty || _upgradingCockpit) ? MaterialStateProperty.all(devoloLighterGray) : MaterialStateProperty.all(devoloGreen),
                                          value: _deviceList.checkedUpdateMacs.contains(allDevices[i].mac),
                                          onChanged: (_upgradingDevicesList.isNotEmpty || _upgradingCockpit)
                                              ? null
                                              :(bool? value) {
                                                setState(() {
                                                  if(value != null && value){
                                                    _deviceList.checkedUpdateMacs.add(allDevices[i].mac);
                                                  }
                                                  else{
                                                    _deviceList.checkedUpdateMacs.remove(allDevices[i].mac);
                                                  }
                                                });
      setState((){});
                                                },
                                          ),
                                      ),
                                    ),
                                    SizedBox(width: textSpacingUpdateStatus * fontSize.factor),
                                  ]),

                              _searchingDeviceUpdate || _upgradingDevicesList.contains(allDevices[i].mac)
                                  ?
                                  SelectableText(
                                    _searchingDeviceUpdate
                                        ? " ${S.of(context).searching}"
                                        : allDevices[i].updateState == "complete"
                                        ?" ${S.of(context).update} : ${S.of(context).complete}"
                                        : allDevices[i].updateState == "pending"
                                        ?" ${S.of(context).update} : ${S.of(context).pending}"
                                        : allDevices[i].updateState == "failed"
                                        ?" ${S.of(context).update} : ${S.of(context).failed}"
                                        :" ${S.of(context).update} : ${ allDevices[i].updateState}%",
                                    style: TextStyle(color: fontColorOnBackground),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: fontSize.factor,
                                  )
                                  : _deviceList.getUpdateList().contains(allDevices[i].mac) == false
                                  ? Row( children: [
                                    if(_deviceList.getUpdateList().isNotEmpty || _deviceList.cockpitUpdate) // used to have CellContent in Column aligned
                                      Transform.scale(
                                        scale: fontSize.factor + checkboxScaleAddition,
                                        child: Container(width: 29),
                                      ),
                                    if(_deviceList.getUpdateList().isNotEmpty || _deviceList.cockpitUpdate) // used to have CellContent in Column aligned
                                      SizedBox(width: textSpacingUpdateStatus * fontSize.factor),
                                      Text(
                                        "${S.of(context).upToDate}",
                                        style: TextStyle(color: fontColorOnBackground),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: fontSize.factor,
                                        textHeightBehavior:TextHeightBehavior()
                                      ),
                                    if(_deviceList.getUpdateList().isNotEmpty || _deviceList.cockpitUpdate) // used to have CellContent in Column aligned
                                        Text(
                                          "${S.of(context).upToDatePlaceholder}",
                                          style: TextStyle(color: Colors.transparent),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: fontSize.factor,
                                          textHeightBehavior:TextHeightBehavior()
                                        )
                                    ])
                                  : Text(
                                    S.of(context).updateAvailable,
                                    style: TextStyle(color: fontColorOnBackground),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: fontSize.factor,
                                    textHeightBehavior:TextHeightBehavior()
                                ),
                            ]),

                      ),
                      TableCell(
                        child: new Material(
                          type: MaterialType.transparency, // used to see the spash color over the background Color of the row
                          child: ListTile(
                            leading: RawImage(
                              image: getIconForDeviceType(allDevices[i].typeEnum),
                              height: (getIconForDeviceType(allDevices[i].typeEnum)!.height).toDouble() * fontSize.factor * 0.5,
                              width: (getIconForDeviceType(allDevices[i].typeEnum)!.width).toDouble() * fontSize.factor * 0.5,
                            ),
                            hoverColor: fontColorOnBackground.withOpacity(opacity),
                            onTap: () => _handleTap(allDevices[i]),
                            title: Text(
                              allDevices[i].name,
                              style: TextStyle(fontWeight: FontWeight.bold, color: fontColorOnBackground, fontSize: 17,),
                              textAlign: TextAlign.center,
                              textScaleFactor: fontSize.factor,
                            ),
                            subtitle: Text(
                              '${allDevices[i].type}',
                              style: TextStyle(color: fontColorOnBackground, fontSize: 17,),
                              textAlign: TextAlign.center,
                              textScaleFactor: fontSize.factor,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Align(alignment: Alignment.center, child: Text(
                          allDevices[i].version,
                          style: TextStyle(color: fontColorOnBackground),
                          textAlign: TextAlign.left,
                          textScaleFactor: fontSize.factor,
                        ),),
                      ),
                    ]),
                  if(_deviceList.getUpdateList().isNotEmpty)
                    TableRow(
                        decoration: BoxDecoration(color: _deviceList.cockpitUpdate ? updateableDevicesColor : _deviceList.getAllDevices().length.isEven ? accentColor : Colors.transparent),
                        children: [
                        TableCell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                _searchingCockpitUpdate || _upgradingCockpit
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: fontSize.factor - 0.4,
                                      child: CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    SizedBox(width: textSpacingUpdateStatus * fontSize.factor),
                                  ],
                                )
                                    : _deviceList.cockpitUpdate == false
                                    ? Container()
                                    : Row( children:[
                                      Material(
                                        type: MaterialType.transparency, // used to see the splash color over the background Color of the row
                                        child:
                                        Transform.scale(
                                          scale: fontSize.factor,
                                          child: Checkbox(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                                            checkColor: Colors.white,
                                            fillColor: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate) ? MaterialStateProperty.all(devoloLighterGray) : MaterialStateProperty.all(devoloGreen),
                                            value: _checkedCockpit,
                                            onChanged: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate)
                                                ? null
                                                : (bool? value) {
                                              setState(() {
                                                if(value != null && value){
                                                  _checkedCockpit = true;
                                                }
                                                else{
                                                  _checkedCockpit = false;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: textSpacingUpdateStatus * fontSize.factor),
                                    ]),
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
                                    child: Row( children: [
                                      if(_deviceList.getUpdateList().isNotEmpty) // used to have CellContent in Column aligned
                                        Transform.scale(
                                          scale: fontSize.factor + checkboxScaleAddition,
                                          child: Container(width: 29),
                                        ),
                                      if(_deviceList.getUpdateList().isNotEmpty) // used to have CellContent in Column aligned
                                        SizedBox(width: textSpacingUpdateStatus * fontSize.factor),
                                      Text(
                                        "${S.of(context).upToDate}",
                                        style: TextStyle(color: fontColorOnBackground),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: fontSize.factor,
                                      ),
                                      if(_deviceList.getUpdateList().isNotEmpty) // used to have CellContent in Column aligned
                                        Text(
                                            "${S.of(context).upToDatePlaceholder}",
                                            style: TextStyle(color: Colors.transparent),
                                            textAlign: TextAlign.center,
                                            textScaleFactor: fontSize.factor,
                                            textHeightBehavior:TextHeightBehavior()
                                      )
                                    ])
                                    )
                                    :  TableCell(
                                  child: Text(
                                    S.of(context).updateAvailable,
                                    style: TextStyle(color: fontColorOnBackground),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: fontSize.factor,
                                  ),
                                )
                              ]),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: verticalPaddingCockpitSoftware),
                            child:ListTile(
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
                        ),
                        TableCell(
                          child: Text(
                            "",
                            style: TextStyle(color: fontColorOnBackground),
                            textAlign: TextAlign.center,
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
