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
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/alertDialogs.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/buttons.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/shared/informationDialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';

import 'appBuilder.dart';

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

  double leftPaddingName = (3/14)/4;
  double spacingIconText = 20;
  double paddingVerticalName = 5;
  double spacingTextType = 1;

  /* ===========  =========== */

  final String title;

  bool _searchingDeviceUpdate = false;
  bool _searchingCockpitUpdate = false;
  List<String> _upgradingDevicesList = [];
  List<String> _failedDevicesList = [];

  bool _upgradingCockpit = false;
  bool _checkedCockpit = true;

  bool _filterState = true;

  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {AppBuilder.of(context)!.rebuild();});
  }

  Future<void> updateCockpit(socket, _deviceList) async {

    setState(() {
      socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
      _deviceList.cockpitUpdate = false;
      _upgradingCockpit = false;
    });
  }

  Future<void> updateDevices(DataHand socket, NetworkList _deviceList, {Map<String,String>? pwProtectedDeviceMap}) async {

    if(pwProtectedDeviceMap == null){

      Map<String,String> updateDeviceMap = new Map<String,String>();

        for(String mac in _deviceList.getCheckedUpdateMacs()) {
          updateDeviceMap[mac] = "";
      }

      logger.d("update following Devices ->" + updateDeviceMap.toString());
      socket.sendXML('FirmwareUpdateResponse', updateDevices: updateDeviceMap);
    }
    else{
      logger.d("repeat updating following Devices ->" + pwProtectedDeviceMap.toString());
      socket.sendXML('FirmwareUpdateResponse', updateDevices: pwProtectedDeviceMap);
    }

    var response = await socket.receiveXML("FirmwareUpdateStatus");
    setState(() {
      _upgradingDevicesList = [];
    });

    _failedDevicesList.clear();

    if(response != null && (response['failed'] != null || response['password'] != null)){

      List<String> passwordSecuredMacs = [];

      if(response['failed'] != null){
        for(var mac in response['failed']){
          if(_deviceList.getDeviceByMac(mac.toString()) != null){
            _failedDevicesList.add(mac.toString());
          }
          else{
            _failedDevicesList.add(mac.toString());
          }
        }
      }

      if(response['password'] != null){
        for(var mac in response['password']){
          if(_deviceList.getDeviceByMac(mac.toString()) != null){
            passwordSecuredMacs.add(mac.toString());
          }
        }
      }

      if(response['password'] != null){
        passwordUpdateDialog(socket, context, fontSize, _deviceList, passwordSecuredMacs: passwordSecuredMacs);
      }
    }
  }

  // used to generate additional invisible text to left align the versions in column
  generateText(String longestDeviceVersion, String deviceVersion)  {

    int lengthDifference = longestDeviceVersion.length - (longestDeviceVersion.length - deviceVersion.length);
    String additionalText = longestDeviceVersion.substring(lengthDifference,longestDeviceVersion.length);

    return Text(additionalText, style: TextStyle(color: Colors.transparent),);
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<DataHand>(context);
    var _deviceList = Provider.of<NetworkList>(context);
    fontSize = context.watch<FontSize>();

    if(!socket.connected) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        while(Navigator.canPop(context)){ // Navigator.canPop return true if can pop
          Navigator.pop(context);
        }
        //Navigator.of(context).popUntil((route) => route.isActive);
      });
    }

    // needed as the backend is sending not automatically a UpdateIndication after a updateable device for example quits the network
    if(_deviceList.getUpdateList().length != 0){
      List<String> toRemove = [];
      for(String mac in _deviceList.getUpdateList()){
        if(_deviceList.getDeviceByMac(mac) == null){
          toRemove.add(mac);
        }
      }
      for(String mac in toRemove){
        _deviceList.getUpdateList().remove(mac);
        _deviceList.getCheckedUpdateMacs().remove(mac);
      }
    }

    var allDevices = _filterState ? _deviceList.getAllDevicesFilteredByState() : _deviceList.getAllDevices();

    String longestDeviceVersion = "";
    for(Device device in allDevices) {
      if(longestDeviceVersion.length < device.version.length) {
        longestDeviceVersion = device.version;
      }
    }

    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
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
                  //mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children:[
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
                              return (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.getCheckedUpdateMacs().isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))? buttonDisabledBackground : devoloGreen;
                            },
                          ),
                          foregroundColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.getCheckedUpdateMacs().isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                              ? MaterialStateProperty.all<Color>(buttonDisabledForeground)
                              : MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.getCheckedUpdateMacs().isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
                            ? null
                            : () async {

                          if(_deviceList.getUpdateList().isNotEmpty && _deviceList.getCheckedUpdateMacs().isNotEmpty){

                            if(_deviceList.getPrivacyWarningMacs().isNotEmpty){
                              privacyWarningDialog(socket, context, fontSize, _deviceList);
                            }
                            else{
                              for(String mac in _deviceList.getCheckedUpdateMacs()) {
                                _upgradingDevicesList.add(mac);
                              }

                              await updateDevices(socket, _deviceList);
                            }
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
                            color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.getCheckedUpdateMacs().isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty)) ? buttonDisabledForeground : Colors.white,
                          ),
                          Text(
                            S.of(context).updateSelected, textScaleFactor: fontSize.factor,
                              style:TextStyle(color: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.getCheckedUpdateMacs().isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty)) ? buttonDisabledForeground : Colors.white)
                          ),
                        ]),
                      ),
                    ),
                    ]),
                    Row(children: [
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
                        foregroundColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true ||_upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || ((_deviceList.cockpitUpdate == false || (_deviceList.cockpitUpdate == true && _checkedCockpit == false)) && _deviceList.getCheckedUpdateMacs().isEmpty) ||(_deviceList.cockpitUpdate == false && _deviceList.getUpdateList().isEmpty))
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

                        var response = await socket.receiveXML("UpdateIndication && FirmwareUpdateIndication");
                        setState(() {
                          _searchingCockpitUpdate = false;
                          _searchingDeviceUpdate = false;
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
                    SizedBox(
                      width: 20,
                    ),
                    ]),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(5),
                    2: FlexColumnWidth(4),
                    3: FlexColumnWidth(5),
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
                      TableCell(child: Transform.scale(
                        scale: fontSize.factor + checkboxScaleAddition,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                          fillColor: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.getUpdateList().isEmpty && _deviceList.cockpitUpdate == false)) ? MaterialStateProperty.all(disabledColor) : MaterialStateProperty.all(devoloGreen),
                          checkColor: Colors.white,
                          value: (_deviceList.getCheckedUpdateMacs().length != 0 && _deviceList.getUpdateList().length != 0) & (_deviceList.getCheckedUpdateMacs().length == _deviceList.getUpdateList().length) & _checkedCockpit,
                          onChanged: (_searchingDeviceUpdate == true || _searchingCockpitUpdate == true || _upgradingDevicesList.isNotEmpty || _upgradingCockpit == true || (_deviceList.getUpdateList().isEmpty && _deviceList.cockpitUpdate == false))
                              ? null
                              : (bool? value) {
                            setState(() {
                              if(value != null && value){
                                _deviceList.getCheckedUpdateMacs().clear();
                                for(String mac in _deviceList.getUpdateList()){
                                  _deviceList.getCheckedUpdateMacs().add(mac);
                                }
                                if(_deviceList.cockpitUpdate)
                                  _checkedCockpit = true;
                              }
                              else{
                                _deviceList.getCheckedUpdateMacs().clear();
                                if(_deviceList.cockpitUpdate)
                                  _checkedCockpit = false;
                              }
                            });
                          },
                        ),
                      ),),
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
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(5),
                      2: FlexColumnWidth(4),
                      3: FlexColumnWidth(5),
                    },
                    children: [
                      if(_deviceList.getUpdateList().isEmpty)
                      TableRow(decoration: BoxDecoration(color: _deviceList.cockpitUpdate ? updateableDevicesColor : Colors.transparent), children: [
                        TableCell(
                          child: Row( mainAxisAlignment : MainAxisAlignment.center, children: [
                            Material(
                              type: MaterialType.transparency, // used to see the splash color over the background Color of the row
                              child:
                              Transform.scale(
                                scale: fontSize.factor,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                                  checkColor: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false) ? Colors.transparent : Colors.white,
                                  fillColor: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false) ? MaterialStateProperty.all(disabledColor) : MaterialStateProperty.all(devoloGreen),
                                  value: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false) ? false : _checkedCockpit,
                                  onChanged: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false)
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
                          ]),
                        ),
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
                                      : Container(),

                                  _searchingCockpitUpdate || _upgradingCockpit
                                      ?  Container(
                                      child: SelectableText(
                                        _searchingCockpitUpdate ? " ${S.of(context).searching}" : " ${S.of(context).updating}",
                                        style: TextStyle(color: fontColorOnBackground),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: fontSize.factor,
                                      ))
                                      : _deviceList.cockpitUpdate == false
                                      ?  Container(
                                      child: Text(
                                        "${S.of(context).upToDate}",
                                        style: TextStyle(color: fontColorOnBackground),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: fontSize.factor,
                                      ))
                                      :  Container(
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
                          child: Padding(padding: EdgeInsets.symmetric(vertical: 18), child: Row(
                              mainAxisAlignment : MainAxisAlignment.start,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * leftPaddingName),
                                Column(mainAxisAlignment : MainAxisAlignment.center,
                                    children:[ SizedBox(width: 50,), Icon(
                                      Icons.speed_rounded,
                                      color: fontColorOnBackground,
                                      size: 24.0 * fontSize.factor,
                                    ),]),
                                SizedBox(width: spacingIconText * fontSize.factor),
                                Expanded( child:
                                    Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                                      Text(
                                        "Cockpit Software",
                                        style: TextStyle(color: fontColorOnBackground, fontSize: 18),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: fontSize.factor,
                                      ),
                                    ])
                                ),
                              ]
                          )),
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
                            child: Row (mainAxisAlignment: MainAxisAlignment.center, children:[
                              Material(
                                type: MaterialType.transparency, // used to see the spash color over the background Color of the row
                                child:
                                Transform.scale(
                                  scale: fontSize.factor + checkboxScaleAddition,
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                                    checkColor: Colors.white,
                                    fillColor: (_upgradingDevicesList.isNotEmpty || _upgradingCockpit || _deviceList.getUpdateList().contains(allDevices[i].mac) == false) ? MaterialStateProperty.all(disabledColor) : MaterialStateProperty.all(devoloGreen),
                                    value: _deviceList.getCheckedUpdateMacs().contains(allDevices[i].mac),
                                    onChanged: (_upgradingDevicesList.isNotEmpty || _upgradingCockpit || _deviceList.getUpdateList().contains(allDevices[i].mac) == false)
                                        ? null
                                        :(bool? value) {
                                      setState(() {
                                        if(value != null && value){
                                          _deviceList.getCheckedUpdateMacs().add(allDevices[i].mac);
                                        }
                                        else{
                                          _deviceList.getCheckedUpdateMacs().remove(allDevices[i].mac);
                                        }
                                      });
                                      setState((){});
                                    },
                                  ),
                                ),
                              ),
                            ]),
                          ),
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
                                : Container(),

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
                                      ? Text(
                                          "${S.of(context).upToDate}",
                                          style: TextStyle(color: fontColorOnBackground),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: fontSize.factor,
                                          textHeightBehavior:TextHeightBehavior()
                                        )
                                      : allDevices[i].updateState == "failed"
                                      ? Text(
                                          S.of(context).update + " " + S.of(context).failed,
                                          style: TextStyle(color: fontColorOnBackground),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: fontSize.factor,
                                          textHeightBehavior:TextHeightBehavior()
                                        )
                                      : Text(
                                          S.of(context).updateAvailable,
                                          style: TextStyle(color: fontColorOnBackground),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: fontSize.factor,
                                          textHeightBehavior:TextHeightBehavior()
                                  )
                                ]),

                          ),
                          TableCell(
                            child: InkWell(
                                hoverColor: fontColorOnBackground.withOpacity(opacity),
                                onTap: () => _handleTap(allDevices[i]),
                                child:Row(
                                mainAxisAlignment : MainAxisAlignment.start,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * leftPaddingName),
                                Column(mainAxisAlignment : MainAxisAlignment.center,
                                children:[ SizedBox(width: 50,), RawImage(
                                  image: getIconForDeviceType(allDevices[i].typeEnum),
                                  height: (getIconForDeviceType(allDevices[i].typeEnum)!.height).toDouble() * fontSize.factor * 0.5,
                                  width: (getIconForDeviceType(allDevices[i].typeEnum)!.width).toDouble() * fontSize.factor * 0.5,
                                ),]),
                                SizedBox(width: spacingIconText * fontSize.factor),
                                Expanded( child:
                                  Column(
                                    crossAxisAlignment : CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: paddingVerticalName * fontSize.factor),
                                      Text(
                                        allDevices[i].name,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: fontColorOnBackground, fontSize: 17,),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: fontSize.factor,
                                      ),
                                      SizedBox(height: spacingTextType * fontSize.factor),
                                      Text(
                                        '${allDevices[i].type}',
                                        style: TextStyle(color: fontColorOnBackground, fontSize: 17,),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: fontSize.factor,
                                      ),
                                      SizedBox(height: paddingVerticalName * fontSize.factor),
                                      ]
                                  ),
                                ),
                              ]
                            )
                          ),),
                          TableCell(
                            child: Row( mainAxisAlignment : MainAxisAlignment.center, children : [
                              Text(
                                allDevices[i].version,
                                style: TextStyle(color: fontColorOnBackground),
                                textAlign: TextAlign.left,
                                textScaleFactor: fontSize.factor,),
                                generateText(longestDeviceVersion, allDevices[i].version) // add invisible text for left aligning
                            ]
                            ),
                            ),
                        ]),
                      if(_deviceList.getUpdateList().isNotEmpty)
                        TableRow(
                            decoration: BoxDecoration(color: _deviceList.cockpitUpdate ? updateableDevicesColor : _deviceList.getAllDevices().length.isEven ? accentColor : Colors.transparent),
                            children: [
                            TableCell(
                              child: Row( mainAxisAlignment: MainAxisAlignment.center, children:[
                                Material(
                                  type: MaterialType.transparency, // used to see the splash color over the background Color of the row
                                  child:
                                  Transform.scale(
                                    scale: fontSize.factor,
                                    child: Checkbox(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                                      checkColor: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false) ? Colors.transparent : Colors.white,
                                      fillColor: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false) ? MaterialStateProperty.all(disabledColor) : MaterialStateProperty.all(devoloGreen),
                                      value: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false) ? false : _checkedCockpit,
                                      onChanged: (_upgradingDevicesList.isNotEmpty || _searchingDeviceUpdate || _deviceList.cockpitUpdate == false)
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
                              ]),
                            ),
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
                                        :  Container(),

                                    _searchingCockpitUpdate || _upgradingCockpit
                                        ?  Container(
                                        child: SelectableText(
                                          _searchingCockpitUpdate ? " ${S.of(context).searching}" : " ${S.of(context).updating}",
                                          style: TextStyle(color: fontColorOnBackground),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: fontSize.factor,
                                        ))
                                        : _deviceList.cockpitUpdate == false
                                        ? Text(
                                            "${S.of(context).upToDate}",
                                            style: TextStyle(color: fontColorOnBackground),
                                            textAlign: TextAlign.center,
                                            textScaleFactor: fontSize.factor,
                                          )
                                        :  Container(
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
                                child: Padding(padding: EdgeInsets.symmetric(vertical: 17), child: Row(
                                    mainAxisAlignment : MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width * leftPaddingName),
                                      Column(mainAxisAlignment : MainAxisAlignment.center,
                                        children:[ SizedBox(width: 50,), Icon(
                                          Icons.speed_rounded,
                                          color: fontColorOnBackground,
                                          size: 24.0 * fontSize.factor,
                                      ),]),
                                      SizedBox(width: spacingIconText * fontSize.factor),
                                      Expanded( child:
                                      Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                                        Text(
                                          "Cockpit Software",
                                          style: TextStyle(color: fontColorOnBackground, fontSize: 18),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: fontSize.factor,
                                        ),
                                      ])
                                      ),
                                    ]
                                )),
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
    );
  }

  void _handleTap(Device dev) {
    //logger.i('entering dialog....');

    final socket = Provider.of<DataHand>(context, listen: false);

    //openDialog
    deviceInformationDialog(context, dev, myFocusNode, socket, fontSize);

  }

  void privacyWarningDialog(socket, context, FontSize fontSize, NetworkList _deviceList) {

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Text(
                  S.of(context).privacyWarningDialogTitle,
                  style: TextStyle(color: fontColorOnBackground),
                ),
              ],
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 4),
            titlePadding: EdgeInsets.all(dialogTitlePadding),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
            contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: StatefulBuilder( builder: (BuildContext context, StateSetter setState) {
              return
                Text("${S.of(context).privacyWarningDialogBody}", textScaleFactor: fontSize.factor);

            }),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S.of(context).update,
                  style: TextStyle(
                      fontSize: dialogContentTextFontSize,
                      color: Colors.white),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: () async {

                  for(String mac in _deviceList.getCheckedUpdateMacs()) {
                    _upgradingDevicesList.add(mac);
                  }

                  updateDevices(socket,_deviceList);
                  Navigator.pop(context);

                  },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return devoloGreen.withOpacity(hoverOpacity);
                        } else if (states.contains(MaterialState.pressed)) {
                          return devoloGreen.withOpacity(activeOpacity);
                        }
                        return devoloGreen;
                      },
                    ),
                    padding: MaterialStateProperty.all<
                        EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),))
                ),
              ),
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(fontSize: dialogContentTextFontSize),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
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
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return drawingColor.withOpacity(hoverOpacity);
                      } else if (states.contains(MaterialState.pressed)) {
                        return drawingColor;
                      }
                      return drawingColor;
                    },
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return BorderSide(color: drawingColor.withOpacity(hoverOpacity), width: 2.0);
                      } else if (states.contains(MaterialState.pressed)) {
                        return BorderSide(color: drawingColor.withOpacity(activeOpacity), width: 2.0);
                      }
                      return BorderSide(color: drawingColor, width: 2.0);
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }

  void passwordUpdateDialog(socket, context, FontSize fontSize, NetworkList _deviceList, {List<String>? passwordSecuredMacs}) {

    double spacingBetweenFormFields = 20;
    double spacingFormFieldButton = 30;
    double spacingDivider = 10;

    bool sharedPasswordBool = false;
    String sharedPassword = "";

    Map<String, bool> hiddenPwMap = new Map<String, bool>();
    bool hiddenPw = true;
    Map<String, String> updateDevicesMap = new Map<String, String>();

    if(passwordSecuredMacs != null){
      for(String mac in passwordSecuredMacs) {
        updateDevicesMap[mac] = "";
        hiddenPwMap[mac] = true;
      }
    }
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Text(
                  S.of(context).updateDevicePasswordNeededTitle,
                  style: TextStyle(color: fontColorOnBackground),
                ),
              ],
            ),
            titlePadding: EdgeInsets.all(dialogTitlePadding),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
            contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: StatefulBuilder( builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                if(passwordSecuredMacs != null)
                Column(children:[
                  (passwordSecuredMacs.length > 1)
                      ? Text(S.of(context).updateDevicePasswordNeededBody2)
                      : Text(S.of(context).updateDevicePasswordNeededBody1),
                  if(passwordSecuredMacs.length > 1)
                  SizedBox(height: spacingFormFieldButton),
                  if(passwordSecuredMacs.length > 1)
                    Row(children: [
                      Transform.scale(
                        scale: fontSize.factor + checkboxScaleAddition,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusCheckbox)),
                          fillColor: MaterialStateProperty.all(devoloGreen),
                          checkColor: Colors.white,
                          value: sharedPasswordBool,
                          onChanged: (bool? value) {
                            setState(() {
                              sharedPasswordBool = !sharedPasswordBool;
                            });
                          },
                        ),
                      ),
                      Text(S.of(context).samePasswordForAll)
                    ]),
                  SizedBox(height: spacingFormFieldButton),
                  if(!sharedPasswordBool)
                  Form(
                      key: _formKey,
                      child: Column(
                      children: <Widget>[
                        for ( var mac in passwordSecuredMacs)
                          Column(children: [
                              TextFormField(
                              obscureText: hiddenPwMap[mac]!,
                                style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                              decoration: InputDecoration(
                                labelText: _deviceList.getDeviceByMac(mac)!.name + " (" + mac + ")",
                                labelStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                                hoverColor: fontColorOnBackground.withOpacity(0.2),
                                contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                filled: true,
                                fillColor: fontColorOnBackground.withOpacity(0.2),
                                errorStyle: TextStyle(color: devoloRed),
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
                                suffixIcon: hiddenPwMap[mac]!
                                    ? IconButton(

                                  icon: Icon(
                                    DevoloIcons.devolo_UI_visibility_off,
                                    color: fontColorOnBackground,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hiddenPwMap[mac] = !(hiddenPwMap[mac]!);
                                    });
                                  },
                                )
                                    : IconButton(
                                  icon: Icon(
                                    DevoloIcons.devolo_UI_visibility,
                                    color: fontColorOnBackground,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hiddenPwMap[mac] = !(hiddenPwMap[mac]!);
                                    });
                                  },
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  updateDevicesMap[mac] = value;
                                });
                                },
                              validator: (value) {
                                return null;
                                },
                            ),
                            SizedBox(
                              height: spacingBetweenFormFields,
                            )
                          ]),
                      ],
                      )
                  ),
                  if(sharedPasswordBool)
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Column(children: [
                              TextFormField(
                                //obscureText: hiddenPwMap[mac]!,
                                style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                                decoration: InputDecoration(
                                  labelText: S.of(context).pleaseEnterPassword,
                                  labelStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                                  hoverColor: fontColorOnBackground.withOpacity(0.2),
                                  contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: fontColorOnBackground.withOpacity(0.2),
                                  errorStyle: TextStyle(color: devoloRed),
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
                                  suffixIcon: hiddenPw
                                      ? IconButton(

                                    icon: Icon(
                                      DevoloIcons.devolo_UI_visibility_off,
                                      color: fontColorOnBackground,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        hiddenPw = !hiddenPw;
                                      });
                                    },
                                  )
                                      : IconButton(
                                    icon: Icon(
                                      DevoloIcons.devolo_UI_visibility,
                                      color: fontColorOnBackground,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        hiddenPw = !hiddenPw;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    sharedPassword = value;
                                  });
                                },
                                validator: (value) {
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: spacingBetweenFormFields,
                              )
                            ]),
                        ],
                      )
                    ),
                    Container(
                    alignment: Alignment.centerRight, child:
                  TextButton(
                    child: Text(
                      S.of(context).update,
                      style: TextStyle(
                      fontSize: dialogContentTextFontSize,
                      color: Colors.white,),
                      textScaleFactor: fontSize.factor,
                    ),
                    onPressed:  () async {
                      if (_formKey.currentState!.validate()) {

                        for(String mac in passwordSecuredMacs) {
                          _upgradingDevicesList.add(mac);
                        }

                        if(sharedPasswordBool){
                          for(String mac in passwordSecuredMacs){
                            updateDevicesMap[mac] = sharedPassword;
                          }
                        }

                        updateDevices(socket, _deviceList, pwProtectedDeviceMap : updateDevicesMap);
                        Navigator.pop(context);

                      }
                      else {

                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return devoloGreen.withOpacity(hoverOpacity);
                                } else if (states.contains(MaterialState.pressed)) {
                                  return devoloGreen.withOpacity(activeOpacity);
                                }
                                return devoloGreen;
                                },
                        ),
                        padding: MaterialStateProperty.all<
                        EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),))
                    ),
                  ),
                  ),
                ]),
                SizedBox(height: spacingDivider),
              ]);
            }),
            actions: <Widget>[],
          );
        });
  }
}
