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

  final String title;

  bool _loading = false;
  bool _loadingSoftware = false;
  bool _loadingFW = false;
  DateTime _lastPoll = DateTime.now();

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
      for(var mac in _deviceList.getUpdateList()) {
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
        title: new Text(
          S.of(context).updates,
          style: TextStyle(color: fontColorLight),
          textScaleFactor: fontSizeFactor,
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        shadowColor: Colors.transparent,
      ),
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Letzte Suche: ${_lastPoll.toString().substring(0, _lastPoll.toString().indexOf("."))}   ',
                  //   style: TextStyle(color: fontColorLight),
                  // ),
                  ButtonTheme(
                    minWidth: 270.0,
                    height: 50.0,
                    child: RaisedButton(
                      color: secondColor,
                      textColor: fontColorDark,
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
                                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                              )
                            : Icon(
                                Icons.refresh,
                                color: mainColor,
                                size: 24 * fontSizeFactor,
                              ),
                        Text(S.of(context).checkUpdates,),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ButtonTheme(
                    minWidth: 270.0,
                    height: 50.0,
                    child: RaisedButton(
                      color: secondColor,
                      textColor: fontColorDark,
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
                          color: mainColor,
                          size: 24 * fontSizeFactor,
                        ),
                        Text(" ${S.of(context).updateAll}",),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Text(""), //Placeholder
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        S.of(context).name,
                        style: TextStyle(fontWeight: FontWeight.bold, color: fontColorLight),
                        semanticsLabel: S.of(context).name,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        S.of(context).currentVersion,
                        style: TextStyle(color: fontColorLight),
                        semanticsLabel: S.of(context).currentVersion,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        S.of(context).state,
                        style: TextStyle(color: fontColorLight),
                        semanticsLabel: S.of(context).state,
                      ),
                    ),
                  ],
                ),
                // trailing: Text(
                //   S.of(context).state,
                //   style: TextStyle(color: fontColorLight),
                //   semanticsLabel: S.of(context).state,
                // ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.speed_rounded,
                  color: Colors.white,
                  size: 24.0 * fontSizeFactor,
                ),
                title: Row(
                  children: [
                    Expanded(flex: 2, child: Text("Cockpit Software")),
                    Expanded(
                        flex: 2,
                        child: Text(
                          " ",
                        )),
                    Expanded(
                      flex: 2,
                      child: _loading
                          ? Row(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                                ),
                                SelectableText(
                                  " ${S.of(context).searching}",
                                  style: TextStyle(color: fontColorDark),
                                ),
                              ],
                            )
                          : _deviceList.CockpitUpdate == false
                              ? Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                      iconSize: 24 * fontSizeFactor,
                                      onPressed: () {},
                                      // tooltip: "already uptodate",
                                    ),
                                    Text(
                                      " ${S.of(context).upToDate}",
                                      style: TextStyle(color: fontColorDark),
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
                                    FlatButton(
                                        child: Text(
                                          S.of(context).update2,
                                          style: TextStyle(color: fontColorDark, fontSize: 20 * fontSizeFactor),
                                        ),
                                        onPressed: () async {
                                          await updateCockpit(socket, _deviceList);
                                        }),
                                    if(_loadingSoftware)
                                      CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                                      ),
                                  ],
                                ),
                    ),
                  ],
                ),
                tileColor: secondColor,
              ),
              Divider(),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  //height: 350,
                  child: ListView.separated(
                    //padding: const EdgeInsets.all(8),
                    controller: _scrollController,
                    itemCount: _deviceList.getAllDevices().length, //_deviceList.getDeviceList().length,
                    itemBuilder: (BuildContext context, int index) {
                      var device = _deviceList.getAllDevices()[index];
                      return new Column(
                        children: [
                          ListTile(
                            onTap: () => _handleTap(device),
                            tileColor: secondColor,
                            leading: RawImage(
                              image: getIconForDeviceType(device.typeEnum),
                              height: 35 * fontSizeFactor,
                            ),
                            //Icon(Icons.devices),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      device.name,
                                      style: TextStyle(fontWeight: FontWeight.bold, color: fontColorDark),
                                    )),
                                //Spacer(flex: 1,),
                                Expanded(
                                  flex: 2,
                                  child: SelectableText(
                                    '${device.version}',
                                    style: TextStyle(color: fontColorDark),
                                  ),
                                ),
                                //Spacer(flex: 2,),
                                Expanded(
                                  flex: 2,
                                  child: _loading
                                      ? Row(
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                                            ),
                                            Text(
                                                " ${S.of(context).searching}",
                                              style: TextStyle(color: fontColorDark),
                                            ),
                                          ],
                                        )
                                      : device.updateStateInt != 0
                                          ? Text(
                                              "${S.of(context).updating} ${device.updateStateInt.toInt().toString()} % ",
                                              style: TextStyle(fontSize: 17 * fontSizeFactor, fontWeight: FontWeight.bold),
                                            )
                                          : _deviceList.getUpdateList().contains(device.mac)
                                              ? Row(
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.download_rounded,
                                                          color: mainColor,
                                                        ),
                                                        iconSize: 24 * fontSizeFactor,
                                                        onPressed: () {},
                                                        // onPressed: () async {
                                                        //   print("Updating ${device.mac}");
                                                        //   setState(() {
                                                        //     socket.sendXML('FirmwareUpdateResponse', newValue: device.mac);
                                                        //     _loadingFW = socket.waitingResponse;
                                                        //   });
                                                        //   var response = await socket.recieveXML([]);
                                                        //   print('Response: ' + response.toString());
                                                        // }
                                                        ),
                                                    FlatButton(
                                                        child: Text(
                                                          S.of(context).update2,
                                                          style: TextStyle(color: fontColorDark, fontSize: 20 * fontSizeFactor),
                                                        ),
                                                        onPressed: () {},
                                                        // onPressed: () async {
                                                        //   print("Updating ${device.mac}");
                                                        //   setState(() {
                                                        //     socket.sendXML('FirmwareUpdateResponse', newValue: device.mac);
                                                        //     _loadingFW = socket.waitingResponse;
                                                        //   });
                                                        //   var response = await socket.recieveXML([]);
                                                        //   print('Response: ' + response.toString());
                                                        // }
                                                        ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.check_circle_outline,
                                                        color: Colors.green,
                                                      ),
                                                      iconSize: 24 * fontSizeFactor,
                                                      // tooltip: "already Uptodate",
                                                      onPressed: () {},
                                                    ),
                                                    Text(
                                                      " ${S.of(context).upToDate}",
                                                      style: TextStyle(color: fontColorDark, fontSize: 20 * fontSizeFactor),
                                                    ),
                                                  ],
                                                ),
                                ), //ToDo somehow get new FW version
                                //Spacer(flex: 2,),
                              ],
                            ),
                            subtitle: Text(
                              '${device.type}',
                              style: TextStyle(color: fontColorDark),
                            ),
                            // trailing: device.updateStateInt != 0
                            //     ? Text(
                            //         device.updateStateInt.toInt().toString() + " %",
                            //         style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            //       )
                            //     : _deviceList.getUpdateList().contains(device.mac)
                            //         ? IconButton(
                            //             icon: Icon(
                            //               Icons.download_rounded,
                            //               color: mainColor,
                            //             ),
                            //             iconSize: 24 * fontSizeFactor,
                            //             onPressed: () async {
                            //               print("Updating ${device.mac}");
                            //               setState(() {
                            //                 socket.sendXML('FirmwareUpdateResponse', newValue: device.mac);
                            //                 _loadingFW = socket.waitingResponse;
                            //               });
                            //
                            //               var response = await socket.recieveXML([]);
                            //               print('Response: ' + response.toString());
                            //             })
                            //         : IconButton(
                            //             icon: Icon(
                            //               Icons.check_circle_outline,
                            //               color: Colors.green,
                            //             ),
                            //             iconSize: 24 * fontSizeFactor,
                            //             // tooltip: "already Uptodate",
                            //           ),
                          ),
                          device.updateStateInt != 0
                              ? LinearProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                                  minHeight: 7,
                                  backgroundColor: secondColor,
                                  value: device.updateStateInt * 0.01,
                                )
                              : LinearProgressIndicator(
                                  backgroundColor: secondColor,
                                  value: 0,
                                ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                ),
              ),
            ],
          ),
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
            fontSize: 23 * fontSizeFactor,
          ),
          content: StatefulBuilder(// You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
        return Stack(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Table(
                        defaultColumnWidth: FixedColumnWidth(300.0 * fontSizeFactor),
                        children: [
                          TableRow(children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SelectableText(
                                'Name:   ',
                                style: TextStyle(height: 2),
                              ),
                            ),
                            TextFormField(
                              initialValue: _newName,
                              focusNode: myFocusNode,
                              style: TextStyle(color: fontColorLight),
                              cursorColor: fontColorLight,
                              decoration: InputDecoration(
                                //labelText: 'Testing',
                                focusColor: Colors.green,
                                hoverColor: secondColor.withOpacity(0.2),
                                contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                filled: true,
                                fillColor: secondColor.withOpacity(0.2),//myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
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
                                    color: fontColorLight,//Colors.transparent,
                                    //width: 2.0,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.edit_outlined, color: fontColorLight,),
                                  onPressed: (){
                                    //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                    if(_newName != hitDeviceName)
                                      _showEditAlert(context, socket, hitDeviceMac, _newName);
                                  },
                                ),
                              ),
                              onChanged: (value) => (_newName = value),
                              onEditingComplete: () {
                                if(_newName != hitDeviceName)
                                  _showEditAlert(context, socket, hitDeviceMac, _newName);
                                //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                              },
                              onTap: (){
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
                                  onPressed: !hitDeviceIdentify ? null : () => socket.sendXML('IdentifyDevice', mac: hitDeviceMac),
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
                                    var response = await socket.recieveXML(["GetManualResponse"]);
                                    setState(() {
                                      openFile(response['filename']);
                                    });
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
                                onPressed: () => _handleCriticalActions(context, socket, 'ResetAdapterToFactoryDefaults', hitDevice),
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
                                onPressed: () => _handleCriticalActions(context, socket, 'RemoveAdapter', hitDevice),
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
            );
      },
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

  void _handleCriticalActions(context, socket, messageType, Device hitDevice) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              S.of(context).confirmAction,//messageType,
              style: TextStyle(color: fontColorLight),
            ),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18 * fontSizeFactor),
            content: hitDevice.attachedToRouter ? Text(S.of(context).pleaseConfirmActionAttentionYourRouterIsConnectedToThis) : Text(S.of(context).pleaseConfirmAction),
            actions: <Widget>[
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: fontColorLight,
                      size: 35 * fontSizeFactor,
                    ),
                    Text(S.of(context).confirm, style: TextStyle(color: fontColorLight),),
                  ],
                ),
                onPressed: () {
                  // Critical things happening here
                  socket.sendXML(messageType, mac: hitDevice.mac);
                  Navigator.maybeOf(context).pop();
                },
              ),
              Spacer(),
              FlatButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: fontColorLight,
                        size: 35 * fontSizeFactor,
                      ),
                      Text(S.of(context).cancel, style: TextStyle(color: fontColorLight),),
                    ],
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context).pop();
                  }),
            ],
          );
        });
  }

  void _showEditAlert(context, socket, hitDeviceMac, _newName) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Confirm",
              style: TextStyle(color: fontColorLight),
            ),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18 * fontSizeFactor),
            content: Stack(
              overflow: Overflow.visible,
              children: [
                Positioned(
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
                Text("Do you really want to rename this device?"),

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
                    Text(S.of(context).confirm, style: TextStyle(color: fontColorLight),),
                  ],
                ),
                autofocus: true,
                onPressed: () {
                  // Critical things happening here
                  socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                  Navigator.maybeOf(context).pop();
                  setState(() {
                    socket.sendXML('RefreshNetwork');
                  });
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
                      Text(S.of(context).cancel, style: TextStyle(color: fontColorLight),),
                    ],
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context).pop();
                  }),
            ],
          );
        });
  }
}
