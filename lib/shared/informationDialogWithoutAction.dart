import 'dart:async';

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/sizeModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';
import 'package:flutter/material.dart';

import 'alertDialogs.dart';
import 'app_colors.dart';
import 'app_fontSize.dart';
import 'buttons.dart';
import 'devolo_icons.dart';

// add closeButton manually
void deviceInformationDialogWithoutAction(context, Device hitDevice, FocusNode myFocusNode, DataHand socket, SizeModel fontSize) {

  String newName = hitDevice.name;
  bool changeNameLoading = false;
  bool dialogClosed = false;
  final textFieldController = TextEditingController(text: hitDevice.name);

  showDialog<void>(
    context: context,
    barrierDismissible: true, // user doesn't need to tap button!
    builder: (BuildContext context) {
      return  StatefulBuilder(
          builder: (context, setState)
          {
            return AlertDialog(
                title: Container(
                  color: devoloBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SelectableText(
                          S.of(context).deviceInfo,
                          style: TextStyle(color: fontColorOnMain),
                          textScaleFactor: fontSize.font_factor,
                        ),
                      ),
                      getCloseButton(context, fontSize, fontColorOnMain),
                    ],
                  ),
                ),
                titlePadding: EdgeInsets.all(0),
                titleTextStyle: TextStyle(
                  color: fontColorOnBackground,
                  fontSize: dialogTitleTextFontSize,
                ),
                contentTextStyle: TextStyle(color: fontColorOnBackground,
                    fontSize: dialogContentTextFontSize * fontSize.font_factor),
                content:  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: <Widget>[
                            SizedBox(
                              height: 15,
                              width: 600.0 * fontSize.font_factor,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SelectableText(
                                            "${S
                                                .of(context)
                                                .name}:   ",
                                          )),
                                    ),
                                    Container(
                                      width: 60, // doesn´t affect the width in the text field
                                      child: TextFormField(
                                        controller: textFieldController,
                                        focusNode: myFocusNode,
                                        style: TextStyle(color: fontColorOnBackground,
                                            fontSize: dialogContentTextFontSize *
                                                fontSize.font_factor),
                                        cursorColor: fontColorOnBackground,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hoverColor: fontColorOnBackground.withOpacity(0.2),
                                          contentPadding: new EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 10.0),
                                          filled: true,
                                          fillColor: fontColorOnBackground.withOpacity(0.2),
                                          //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
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
                                              color: fontColorOnBackground, //Colors.transparent,
                                              //width: 2.0,
                                            ),
                                          ),
                                          suffixIcon: (myFocusNode.hasPrimaryFocus && !changeNameLoading) ?
                                          Container(
                                            width: 100,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      DevoloIcons.devolo_UI_check_fill,
                                                      color: fontColorOnBackground,
                                                    ),
                                                    onPressed: () async {
                                                      if (newName != hitDevice.name) {
                                                        changeNameLoading = true;
                                                        AppBuilder.of(context)!.rebuild();
                                                        socket.sendXML(
                                                            'SetAdapterName', mac: hitDevice.mac,
                                                            newValue: newName,
                                                            valueType: 'name');
                                                        var response = await socket.receiveXML(
                                                            "SetAdapterNameStatus");
                                                        if (response!['result'] == "ok") {
                                                          hitDevice.name = newName;
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
                                                              .deviceNotFoundHint, fontSize);
                                                        } else if (response['result'] != "ok") {
                                                          errorDialog(context, S
                                                              .of(context)
                                                              .deviceNameErrorTitle, S
                                                              .of(context)
                                                              .deviceNameErrorBody, fontSize);
                                                        }

                                                        changeNameLoading = false;
                                                        myFocusNode.unfocus();
                                                      }
                                                    }
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    DevoloIcons.devolo_UI_cancel_fill,
                                                    color: fontColorOnBackground,
                                                  ),
                                                  onPressed: () async {
                                                    textFieldController.text = hitDevice.name;
                                                    myFocusNode.unfocus();
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
                                        onChanged: (value) => (newName = value),
                                        onEditingComplete: () async {
                                          if (newName != hitDevice.name) {
                                            bool confResponse = await confirmDialog(context, S
                                                .of(context)
                                                .deviceNameDialogTitle, S
                                                .of(context)
                                                .deviceNameDialogBody, fontSize);
                                            if (confResponse) {
                                              changeNameLoading = true;
                                              socket.sendXML('SetAdapterName', mac: hitDevice.mac,
                                                  newValue: newName,
                                                  valueType: 'name');
                                              var response = await socket.receiveXML(
                                                  "SetAdapterNameStatus");
                                              if (response!['result'] == "ok") {
                                                hitDevice.name = newName;
                                                await Future.delayed(
                                                    const Duration(seconds: 1), () {});
                                                socket.sendXML('RefreshNetwork');

                                                //setState(() {
                                                //   socket.sendXML('RefreshNetwork');
                                                //});
                                              } else if (response['result'] == "timeout") {
                                                errorDialog(context, S
                                                    .of(context)
                                                    .deviceNameErrorTitle, S
                                                    .of(context)
                                                    .deviceNameErrorBody, fontSize);
                                              } else if (response['result'] == "device_not_found") {
                                                errorDialog(context, S
                                                    .of(context)
                                                    .deviceNameErrorTitle, S
                                                    .of(context)
                                                    .deviceNotFoundDeviceName + "\n\n" + S
                                                    .of(context)
                                                    .deviceNotFoundHint, fontSize);
                                              }

                                              changeNameLoading = false;
                                            }
                                          }
                                        },
                                        onTap: () {
                                          myFocusNode.hasFocus;
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
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SelectableText(
                                            "${S
                                                .of(context)
                                                .type}:   ",
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: SelectableText(hitDevice.type),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SelectableText(
                                            "${S
                                                .of(context)
                                                .serialNumber}:   ",
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: SelectableText(hitDevice.serialno),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SelectableText(
                                          "${S
                                              .of(context)
                                              .mtNumber}:   ",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: SelectableText(hitDevice.MT.substring(2)),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SelectableText(
                                          "${S
                                              .of(context)
                                              .version}:   ",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: SelectableText(
                                          hitDevice.version + "(" + hitDevice.versionDate +
                                              ")"),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SelectableText(
                                          "${S
                                              .of(context)
                                              .ipAddress}:   ",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: SelectableText(hitDevice.ip),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SelectableText(
                                          "${S
                                              .of(context)
                                              .macAddress}:   ",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: SelectableText(hitDevice.mac),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
//Text('Rates: ' +hitDeviceRx),
                            Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
                          ],
                        ),
                      );
                    }));
          });
    },
  ).then((value) => dialogClosed = true);
}