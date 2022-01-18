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
import 'helpers.dart';

// add closeButton manually
void deviceInformationDialog(context, Device hitDevice, FocusNode myFocusNode, DataHand socket, SizeModel fontSize) {

  String newName = hitDevice.name;
  bool changeNameLoading = false;
  bool lightbulbOn = false;
  bool dialogClosed = false;
  bool identifyDeviceActionRunning = false;
  double maxWidthActions = 110;
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
                              child: (hitDevice.networkType == "wifi:other" && hitDevice.mac[0]=="0" && hitDevice.mac[1]=="1") ? null : SelectableText(hitDevice.mac),
                            ),
                          ]),
                        ],
                      ),
                    ),
//Text('Rates: ' +hitDeviceRx),
                    Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                DevoloIcons.devolo_UI_internet,
                              ),
//tooltip: S.of(context).launchWebinterface,
                              disabledColor: fontColorOnBackground.withOpacity(
                                  0.33),
                              color: fontColorOnBackground,
                              hoverColor: fontColorOnBackground.withAlpha(50),
                              iconSize: 24.0 * fontSize.font_factor,
                              onPressed: !hitDevice.webinterfaceAvailable
                                  ? null
                                  : () =>
                                  launchURL(hitDevice.webinterfaceURL),
                              mouseCursor: !hitDevice.webinterfaceAvailable
                                  ? SystemMouseCursors
                                  .basic
                                  : SystemMouseCursors.click,
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: maxWidthActions * fontSize.font_factor),
                              child: Text(
                                S.of(context).launchWebInterface,
                                style: TextStyle(fontSize: 14,
                                    color: !hitDevice.webinterfaceAvailable
                                        ? fontColorOnBackground.withOpacity(0.33)
                                        : fontColorOnBackground),
                                textScaleFactor: fontSize.font_factor,
                                textAlign: TextAlign.center,
                              )
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Tooltip(
                              preferBelow: false,
                              message: S
                                  .of(context)
                                  .identifyDeviceTooltip,
                              textStyle: TextStyle(color: backgroundColor),
                              decoration: BoxDecoration(
                                color: fontColorOnBackground.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              margin: EdgeInsets.only(),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child:
                              IconButton(
                                icon: Icon(
                                  lightbulbOn
                                      ? DevoloIcons.devolo_icon_ui_led_on
                                      : DevoloIcons
                                      .devolo_icon_ui_led,
                                ),
                                //tooltip: S.of(context).identifyDevice,
                                disabledColor: fontColorOnBackground.withOpacity(
                                    0.33),
                                color: fontColorOnBackground,
                                hoverColor: fontColorOnBackground.withAlpha(50),
                                iconSize: 24.0 * fontSize.font_factor,
                                onPressed: !hitDevice.identifyDeviceAvailable ||
                                    identifyDeviceActionRunning
                                    ? null
                                    : () async {
                                  identifyDeviceActionRunning = true;

                                  socket.sendXML(
                                      'IdentifyDevice', mac: hitDevice.mac);

                                  bool toggleLightbulb = true;
                                  Timer(
                                      Duration(seconds: 120),
                                          () {
                                        identifyDeviceActionRunning = false;
                                        toggleLightbulb = false;
                                      }
                                  );

                                  Timer.periodic(
                                      Duration(seconds: 1),
                                          (Timer t) {
                                        if (dialogClosed) {
                                          t.cancel();
                                        }
                                        else if (!toggleLightbulb) {
                                          setState(() {
                                            lightbulbOn = false;
                                            t.cancel();
                                          });
                                        }
                                        else {
                                          setState(() {
                                            lightbulbOn = !lightbulbOn;
                                          });
                                        }
                                      }
                                  );

                                  var response = await socket.receiveXML(
                                      "IdentifyDeviceStatus");
                                  if (response!['result'] == "device_not_found") {
                                    identifyDeviceActionRunning = false;
                                    toggleLightbulb = false;
                                    errorDialog(context, S
                                        .of(context)
                                        .identifyDeviceErrorTitle, S
                                        .of(context)
                                        .deviceNotFoundIdentifyDevice + "\n\n" + S
                                        .of(context)
                                        .deviceNotFoundHint, fontSize);
                                  }
                                  else if (response['result'] != "ok") {
                                    identifyDeviceActionRunning = false;
                                    toggleLightbulb = false;
                                    errorDialog(context, S
                                        .of(context)
                                        .identifyDeviceErrorTitle, S
                                        .of(context)
                                        .identifyDeviceErrorBody, fontSize);
                                  }
                                },

                                mouseCursor: !hitDevice.identifyDeviceAvailable ||
                                    identifyDeviceActionRunning ? SystemMouseCursors
                                    .basic : SystemMouseCursors.click,
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: maxWidthActions * fontSize.font_factor),
                              child: Text(
                                S.of(context).identifyDevice,
                                style: TextStyle(fontSize: 14,
                                    color: !hitDevice.identifyDeviceAvailable ||
                                        identifyDeviceActionRunning
                                        ? fontColorOnBackground.withOpacity(0.33)
                                        : fontColorOnBackground),
                                textScaleFactor: fontSize.font_factor,
                                textAlign: TextAlign.center,
                              )
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                                icon: Icon(
                                  DevoloIcons.ic_find_in_page_24px,
                                  color: fontColorOnBackground,
                                ),
//tooltip: S.of(context).showManual,
                                hoverColor: fontColorOnBackground.withAlpha(50),
                                iconSize: 24.0 * fontSize.font_factor,
                                onPressed: () async {
                                  socket.sendXML(
                                      'GetManual', newValue: hitDevice.MT,
                                      valueType: 'product',
                                      newValue2: config["language"],
                                      valueType2: 'language');
                                  var response = await socket.receiveXML(
                                      "GetManualResponse");
                                  if (response!['filename'] != "") {
                                    openFile(response['filename']);
                                  } else {
                                    errorDialog(context, S
                                        .of(context)
                                        .manualErrorTitle, S
                                        .of(context)
                                        .manualErrorBody, fontSize);
                                  }
                                }),
                            Container(
                                constraints: BoxConstraints(maxWidth: maxWidthActions * fontSize.font_factor),
                                child: Text(
                                  S.of(context).showManual,
                                style: TextStyle(
                                    fontSize: 14, color: fontColorOnBackground),
                                textScaleFactor: fontSize.font_factor,
                                textAlign: TextAlign.center,
                              )
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                DevoloIcons.ic_router_24px,
                              ),
//tooltip: S.of(context).showManual,
                          color: fontColorOnBackground,
                          hoverColor: fontColorOnBackground.withAlpha(50),
                          disabledColor: fontColorOnBackground.withOpacity(0.33),
                          iconSize: 24.0 * fontSize.font_factor,
                          onPressed: (hitDevice.supportedVDSL.isNotEmpty)
                              ? () {
                            setState(() {
                              showVDSLDialog(
                                  context,socket, hitDevice.modeVDSL, hitDevice.supportedVDSL,
                                  hitDevice.selectedVDSL, hitDevice.mac, fontSize);

                            });

                          }
                          : null,
                        mouseCursor: !hitDevice.supportedVDSL.isNotEmpty ? SystemMouseCursors
                            .basic : SystemMouseCursors.click,
                      ),
                            Container(
                              constraints: BoxConstraints(maxWidth: maxWidthActions * fontSize.font_factor),
                              child: Text(
                                S.of(context).setVdslCompatibility,
                                style: TextStyle(fontSize: 14, color: !hitDevice.supportedVDSL.isNotEmpty ? fontColorOnBackground.withOpacity(0.33) : fontColorOnBackground),                        textScaleFactor: fontSize.font_factor,
                                textAlign: TextAlign.center,
                              )
                            ),
                    ],
                  ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        DevoloIcons.ic_file_upload_24px,
                        color: fontColorOnBackground,
                        semanticLabel: "update",
                      ),
//tooltip: S.of(context).factoryReset,
                              hoverColor: fontColorOnBackground.withAlpha(50),
                              iconSize: 24.0 * fontSize.font_factor,
                              onPressed: () async {
                                bool confResponse = false;
                                hitDevice.attachedToRouter
                                    ? confResponse = await confirmDialog(context, S
                                    .of(context)
                                    .resetDeviceConfirmTitle, S
                                    .of(context)
                                    .resetDeviceConfirmBody + "\n" + S
                                    .of(context)
                                    .confirmActionConnectedToRouterWarning,
                                    fontSize)
                                    : confResponse = await confirmDialog(context, S
                                    .of(context)
                                    .resetDeviceConfirmTitle, S
                                    .of(context)
                                    .resetDeviceConfirmBody, fontSize);

                                if (confResponse) {
                                  socket.sendXML("ResetAdapterToFactoryDefaults",
                                      mac: hitDevice.mac);

                                  var response = await socket.receiveXML(
                                      "ResetAdapterToFactoryDefaultsStatus");
                                  if (response!['result'] == "device_not_found") {
                                    errorDialog(context, S
                                        .of(context)
                                        .resetDeviceErrorTitle, S
                                        .of(context)
                                        .deviceNotFoundResetDevice + "\n\n" + S
                                        .of(context)
                                        .deviceNotFoundHint, fontSize);
                                  } else if (response['result'] != "ok") {
                                    errorDialog(context, S
                                        .of(context)
                                        .resetDeviceErrorTitle, S
                                        .of(context)
                                        .resetDeviceErrorBody, fontSize);
                                  }
                                }
                              },
                            ),
                    Container(
                      constraints: BoxConstraints(maxWidth: maxWidthActions * fontSize.font_factor),
                      child: Text(
                        S.of(context).factoryReset,
                        style: TextStyle(
                            fontSize: 14, color: fontColorOnBackground),
                        textScaleFactor: fontSize.font_factor,
                        textAlign: TextAlign.center,
                      )
                    )
                  ],
                ),

                        Column(
                          children: [
                            IconButton(
                                icon: Icon(
                                  DevoloIcons.devolo_UI_delete,
                                  color: fontColorOnBackground,
                                ),
//tooltip: S.of(context).deleteDevice,
                                hoverColor: fontColorOnBackground.withAlpha(50),
                                iconSize: 24.0 * fontSize.font_factor,
                                onPressed: () async {
                                  bool confResponse = false;
                                  hitDevice.attachedToRouter
                                      ?
                                  confResponse = await confirmDialog(context, S
                                      .of(context)
                                      .removeDeviceConfirmTitle, S
                                      .of(context)
                                      .removeDeviceConfirmBody + "\n" + S
                                      .of(context)
                                      .confirmActionConnectedToRouterWarning,
                                      fontSize)
                                      : confResponse = await confirmDialog(
                                      context, S
                                      .of(context)
                                      .removeDeviceConfirmTitle, S
                                      .of(context)
                                      .removeDeviceConfirmBody, fontSize);

                                  if (confResponse) {
                                    socket.sendXML(
                                        "RemoveAdapter", mac: hitDevice.mac);

                                    var response = await socket.receiveXML(
                                        "RemoveAdapterStatus");
                                    if (response!['result'] == "device_not_found") {
                                      errorDialog(context, S
                                          .of(context)
                                          .removeDeviceErrorTitle, S
                                          .of(context)
                                          .deviceNotFoundRemoveDevice + "\n\n" + S
                                          .of(context)
                                          .deviceNotFoundHint, fontSize);
                                    } else if (response['result'] != "ok") {
                                      errorDialog(context, S
                                          .of(context)
                                          .removeDeviceErrorTitle, S
                                          .of(context)
                                          .removeDeviceErrorBody, fontSize);
                                    }
                                  }
                                }
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: maxWidthActions * fontSize.font_factor),
                              child: Text(
                                S.of(context).removeDevice,
                                style: TextStyle(
                                    fontSize: 14, color: fontColorOnBackground),
                                textScaleFactor: fontSize.font_factor,
                                textAlign: TextAlign.center,
                              )
                            ),
                          ],
                        ), //ToDo Delete Device see wiki
                        if (hitDevice.disableTraffic[0] == 1 ||
                            hitDevice.disableLeds[0] == 1 ||
                            hitDevice.disableStandby[0] == 1 ||
                            (hitDevice.ipConfigAddress.isNotEmpty ||
                                hitDevice.ipConfigMac.isNotEmpty ||
                                hitDevice.ipConfigNetmask.isNotEmpty))
                          Column(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    DevoloIcons.devolo_UI_more_horiz,
                                    color: fontColorOnBackground,
                                  ),
                                  hoverColor: fontColorOnBackground.withAlpha(50),
                                  iconSize: 24.0 * fontSize.font_factor,
                                  onPressed: () {
                                    moreSettings(
                                        context,
                                        socket,
                                        hitDevice.disableTraffic,
                                        hitDevice.disableLeds,
                                        hitDevice.disableStandby,
                                        hitDevice.mac,
                                        hitDevice.ipConfigMac,
                                        hitDevice.ipConfigAddress,
                                        hitDevice.ipConfigNetmask,
                                        fontSize);
                                  }),
                              Container(
                                constraints: BoxConstraints(maxWidth: maxWidthActions * fontSize.font_factor),
                                child: Text(
                                  S.of(context).additionalSettings,
                                  style: TextStyle(
                                      fontSize: 14, color: fontColorOnBackground),
                                  textScaleFactor: fontSize.font_factor,
                                  textAlign: TextAlign.center,
                                )
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }));
      });
    },
  ).then((value) => dialogClosed = true);
}


void showVDSLDialog(context, socket, String hitDeviceVDSLmode, List<String> hitDeviceVDSLList, String vdslProfile, hitDeviceMac, SizeModel fontSize) async {

  // ToDo remove translation dublicates ?
  Map<String, String> vdslNames = {'mimo_vdsl17a': S.of(context).mimoVdslProfil17a, 'siso_full': S.of(context).sisoFull, 'siso_vdsl35b': S.of(context).sisoVdslProfil35b, 'siso_vdsl17a': S.of(context).sisoVdslProfil17a, 'mimo_full': S.of(context).mimoFull, 'mimo_vdsl35b': S.of(context).mimoVdslProfil35a};

  bool vdslModeAutomatic = true;
  var isSelected = <bool>[true, false]; // [MIMO, SISO] for toggle button
  bool showMSButton = false;
  String? _dropVDSL = vdslProfile;
  List<String> mimoVDSLList = [];
  List<String> sisoVDSLList = [];
  List<String> otherProfilesList = [];
  List<String> selectedProfileList = mimoVDSLList;  // presents the the mimo or siso or other list based on selected mode in ToggleButton


  logger.d(hitDeviceVDSLList);
  logger.d(hitDeviceVDSLmode);
  logger.d(vdslProfile);

  // Test if automatic mode is selected
  if(hitDeviceVDSLmode == "2")
    vdslModeAutomatic = false;

  // Test which profile is selected so MIMO/SISO button is already selected the right mode
  if(vdslProfile.contains("siso")) {
    isSelected[1] = true;
    isSelected[0] = false;
    selectedProfileList = sisoVDSLList;
  }


  // divide hitDeviceVDSLList into mimo/siso/other Profile Lists
  for(var elem in hitDeviceVDSLList){
    if (elem.contains("mimo")) {
      mimoVDSLList.add(elem);
      showMSButton = true;  // If hitDeviceVDSLList contains mimo profiles toggle button to choose between SISO and MIMO is displayed
    }
    else if (elem.contains("siso")) {
      sisoVDSLList.add(elem);
    }
    else {
      otherProfilesList.add(elem);
    }
  }

  logger.d(mimoVDSLList);
  logger.d(sisoVDSLList);
  logger.d(otherProfilesList);


  if(vdslProfile.contains("siso")) {
    isSelected[1] = true;
    isSelected[0] = false;
  }

  if(hitDeviceVDSLList.any((String element) => !element.contains("mimo"))) {
    //isSelected[0] = null;
  }

  bool? returnVal = await showDialog(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 300),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          title: Column(
            children: [
              getCloseButton(context, fontSize),
              Center(
                  child: Text(
                    S.of(context).vdslCompatibility,
                    style: TextStyle(color: fontColorOnBackground),
                  )
              ),
            ],
          ),
          titleTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.font_factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.font_factor),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(hitDeviceVDSLmode != "0")
                        Column(children: [
                          SelectableText(S.of(context).vdslExplanation),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Theme(
                                  data: ThemeData(
                                    //here change to your color
                                    unselectedWidgetColor: fontColorOnBackground,
                                  ),
                                  child: Checkbox(
                                      value: vdslModeAutomatic,
                                      activeColor: mainColor,
                                      onChanged: (bool? newValue) async {
                                        vdslModeAutomatic = newValue!;
                                        setState(() {
                                          if (vdslModeAutomatic == true) {
                                            hitDeviceVDSLmode = "1";
                                          } else {
                                            hitDeviceVDSLmode = "2";
                                          }
                                        });
                                      }),
                                ),
                                SelectableText(S.of(context).automaticCompatibilityMode),
                              ],
                            ),
                          ),
                          SelectableText(S.of(context).vdslExplanation2),
                        ],),
                      Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:8.0),
                              child: Text("${S.of(context).currentCompatibility}: ${vdslNames[vdslProfile]}", ),
                            )
                          ]
                      )
                      Row(
                        children: [
                          if (showMSButton)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                        decoration: BoxDecoration(
                        color: secondColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                              child: ToggleButtons(
                                color: fontColorOnBackground,
                                selectedColor: fontColorOnMain,
                                fillColor: devoloGreen,
                                //selectedBorderColor: devoloGreen,
                                borderRadius: BorderRadius.circular(20.0),
                                constraints: BoxConstraints(minHeight: 40.0, minWidth: 60),
                                children: <Widget>[
                                  Text("MIMO"),
                                  Text("SISO"),
                                ],
                                onPressed: (int index) {
                                  setState(() {
                                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                                      if (buttonIndex == index) {
                                        isSelected[buttonIndex] = true;
                                        if (buttonIndex == 0)
                                          selectedProfileList = mimoVDSLList;
                                        else
                                          selectedProfileList = sisoVDSLList;
                                        _dropVDSL = null;
                                      } else {
                                        isSelected[buttonIndex] = false;
                                      }
                                    }
                                  });
                                },
                                isSelected: isSelected,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/ 3.5,
                              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: secondColor.withOpacity(0.2), border: Border.all(color: fontColorOnBackground)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    value: _dropVDSL == null? _dropVDSL=selectedProfileList[0]: _dropVDSL,
                                    dropdownColor: backgroundColor,
                                    hint: Text(S.of(context).selectProfile,style: TextStyle(color: fontColorOnMain),),
                                    style: TextStyle(fontSize: fontSizeListTileSubtitle * fontSize.font_factor, color: fontColorOnBackground),
                                    icon: Icon(
                                      DevoloIcons.ic_arrow_drop_down_24px,
                                      color: fontColorOnBackground,
                                    ),
                                    items: selectedProfileList.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            new Text(vdslNames[value] == null? value:vdslNames[value]!),
                                            new Text(value == hitDeviceVDSLList[0]? " ${S.of(context).standard}":""),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _dropVDSL = value!;
                                        logger.d("Dropdown: $value");
                                      });
                                    }
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                );
              }),
          actions: <Widget>[
            getConfirmButton(context, fontSize),
            getCancelButton(context, fontSize),

          ],

        );
      });

  if (returnVal == null) returnVal = false;

  if (returnVal == true) {

    socket.sendXML('SetVDSLCompatibility', newValue: _dropVDSL, valueType: 'profile', newValue2: hitDeviceVDSLmode, valueType2: 'mode', mac: hitDeviceMac);

    circularProgressIndicatorInMiddle(context);

    var response = await socket.receiveXML("SetVDSLCompatibilityStatus");
    logger.v(response);
    if (response['result'] == "failed" || response['result'] == "timeout") {
      Navigator.maybeOf(context)!.pop(true);
      errorDialog(context, "Error", S.of(context).vdslFailed, fontSize).then((val){Navigator.pop(context);});
    } else if (response['result'] == "ok") {
      Navigator.maybeOf(context)!.pop(true);
      errorDialog(context, S.of(context).success, S.of(context).vdslSuccessful, fontSize).then((val){Navigator.pop(context);});
      //TODO update device vdsl info
    }
    else {
      logger.w("[showVDSLDialog] - Unexpected response: " + response['result']);
      Navigator.maybeOf(context)!.pop();
    }
  }
  // else {//Navigator.maybeOf(context)!.pop(false);// }
}

// add confirm button manually
void moreSettings(BuildContext context, socket, List<int> disableTraffic,List<int> disableLeds, List<int> disableStandby, String mac, String ipConfigMac, String ipConfigAddress, String ipConfigNetmask, SizeModel size) {

  final _formKey = GlobalKey<FormState>();
  String formIpAdress = ipConfigAddress;
  String formNetmask = ipConfigNetmask;
  final formIpAdressController = TextEditingController(text: ipConfigAddress);
  final formNetmaskController = TextEditingController(text: ipConfigNetmask);

  // Styling
  Color switchActiveTrackColor = devoloGreen.withOpacity(0.4);
  Color switchActiveThumbColor = devoloGreen;
  Color switchInactiveThumbColor = Colors.white;
  Color switchInactiveTrackColor = Color(0x61000000);

  showDialog<void> (
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          titleTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogTitleTextFontSize * size.font_factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * size.font_factor),
          title: Column(
            children: [
              getCloseButton(context, size),
              Center(
                  child: Text(
                    S.of(context).additionalDialogTitle,
                    style: TextStyle(color: fontColorOnBackground),
                  )
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          content: StatefulBuilder( builder: (BuildContext context, StateSetter setState) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(disableLeds[0] == 1)
                    SwitchListTile(
                      title: Text(S
                          .of(context)
                          .activateLEDs, style: TextStyle(
                          color: fontColorOnBackground,
                          fontSize: dialogContentTextFontSize *
                              size.font_factor)),
                      value: disableLeds[1] == 0 ? true : false,
                      onChanged: (bool value) async {
                        String newStatus = value ? "0" : "1";
                        socket.sendXML('DisableLEDs', newValue: newStatus,
                            valueType: 'state',
                            mac: mac);
                        circularProgressIndicatorInMiddle(context);
                        var response = await socket.receiveXML(
                            "DisableLEDsStatus");
                        if (response['result'] == "ok") {
                          disableLeds[1] = value ? 0 : 1;
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
                      activeTrackColor: switchActiveTrackColor,
                      activeColor: switchActiveThumbColor,
                      inactiveThumbColor: switchInactiveThumbColor,
                      inactiveTrackColor: switchInactiveTrackColor,
                    ),
                  if(disableTraffic[0] == 1)
                    SwitchListTile(
                      title: Text(S
                          .of(context)
                          .activateTransmission, style: TextStyle(
                          color: fontColorOnBackground,
                          fontSize: dialogContentTextFontSize *
                              size.font_factor)),
                      value: disableTraffic[1] == 0 ? true : false,
                      onChanged: (bool value) async {
                        String newStatus = value ? "0" : "1";
                        socket.sendXML('DisableTraffic', newValue: newStatus,
                            valueType: 'state',
                            mac: mac);
                        circularProgressIndicatorInMiddle(context);
                        var response = await socket.receiveXML(
                            "DisableTrafficStatus");
                        if (response['result'] == "ok") {
                          disableTraffic[1] = value ? 0 : 1;
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
                      activeTrackColor: switchActiveTrackColor,
                      activeColor: switchActiveThumbColor,
                      inactiveThumbColor: switchInactiveThumbColor,
                      inactiveTrackColor: switchInactiveTrackColor,
                    ),
                  if(disableStandby[0] == 1)
                    SwitchListTile(
                      title: Text(S
                          .of(context)
                          .powerSavingMode, style: TextStyle(
                          color: fontColorOnBackground,
                          fontSize: dialogContentTextFontSize *
                              size.font_factor)),
                      value: disableStandby[1] == 0 ? true : false,
                      onChanged: (bool value) async {
                        String newStatus = value ? "0" : "1";
                        socket.sendXML('DisableStandby', newValue: newStatus,
                            valueType: 'state',
                            mac: mac);
                        circularProgressIndicatorInMiddle(context);
                        var response = await socket.receiveXML(
                            "DisableStandbyStatus");
                        if (response['result'] == "ok") {
                          disableStandby[1] = value ? 0 : 1;
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
                      activeTrackColor: switchActiveTrackColor,
                      activeColor: switchActiveThumbColor,
                      inactiveThumbColor: switchInactiveThumbColor,
                      inactiveTrackColor: switchInactiveTrackColor,
                    ),
                  if ((ipConfigAddress.isNotEmpty || ipConfigMac.isNotEmpty || ipConfigNetmask.isNotEmpty) && (disableLeds[0] == 1 || disableTraffic[0] == 1 || disableStandby[0] == 1))
                  SizedBox(height: 20,),
                  if ((ipConfigAddress.isNotEmpty || ipConfigMac.isNotEmpty || ipConfigNetmask.isNotEmpty) && (disableLeds[0] == 1 || disableTraffic[0] == 1 || disableStandby[0] == 1))
                  Divider(color: fontColorOnBackground),
                  if ((ipConfigAddress.isNotEmpty || ipConfigMac.isNotEmpty || ipConfigNetmask.isNotEmpty) && (disableLeds[0] == 1 || disableTraffic[0] == 1 || disableStandby[0] == 1))
                  SizedBox(height: 20,),
                  if (ipConfigAddress.isNotEmpty || ipConfigMac.isNotEmpty || ipConfigNetmask.isNotEmpty)
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: formIpAdressController,
                            style: TextStyle(color: fontColorOnBackground),
                            decoration: InputDecoration(
                              labelText: S
                                  .of(context)
                                  .ipAddress,
                              labelStyle: TextStyle(
                                  color: fontColorOnBackground,
                                  fontSize: dialogContentTextFontSize *
                                      size.font_factor),
                              hoverColor: fontColorOnBackground.withOpacity(
                                  0.2),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              filled: true,
                              fillColor: fontColorOnBackground.withOpacity(0.2),
                              errorStyle: TextStyle(color: devoloRed),
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
                              //labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.amberAccent : Colors.blue),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                formIpAdress = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S
                                    .of(context)
                                    .fillInIpAddress;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: formNetmaskController,
                            style: TextStyle(color: fontColorOnBackground),
                            decoration: InputDecoration(
                              labelText: S
                                  .of(context)
                                  .netmask,
                              labelStyle: TextStyle(
                                  color: fontColorOnBackground,
                                  fontSize: dialogContentTextFontSize *
                                      size.font_factor),
                              hoverColor: fontColorOnBackground.withOpacity(
                                  0.2),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              filled: true,
                              fillColor: fontColorOnBackground.withOpacity(0.2),
                              errorStyle: TextStyle(color: devoloRed),
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
                            ),
                            onChanged: (String value) {
                              setState(() {
                                formNetmask = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S
                                    .of(context)
                                    .fillInNetmask;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft, child:
                          TextButton(
                            child: Text(
                              S
                                  .of(context)
                                  .change,
                              style: TextStyle(
                                  fontSize: dialogContentTextFontSize,
                                  color: (formIpAdress != ipConfigAddress || formNetmask != ipConfigNetmask) ? Colors.white : buttonDisabledForeground),
                              textScaleFactor: size.font_factor,
                            ),
                            onPressed: (formIpAdress != ipConfigAddress ||
                                formNetmask != ipConfigNetmask)
                                ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    socket.sendXML('SetIpConfig',newValue2 : formIpAdress,valueType2 : 'address',newValue : formNetmask,valueType : 'netmask',mac : ipConfigMac);
                                    circularProgressIndicatorInMiddle(context);
                                    var response = await socket.receiveXML(
                                        "SetIpConfigStatus");
                                    if (response!['result'] == "ok") {
                                      ipConfigAddress = formIpAdress;
                                      ipConfigNetmask = formNetmask;
                                      AppBuilder.of(context)!.rebuild();
                                      Navigator.maybeOf(context)!.pop();
                                      await Future.delayed(
                                          const Duration(seconds: 1), () {});
                                      socket.sendXML('RefreshNetwork');

                                    } else
                                    if (response['result'] == "device_not_found") {
                                      formIpAdress = ipConfigAddress;
                                      formIpAdressController.text = ipConfigAddress;
                                      formNetmask = ipConfigNetmask;
                                      formNetmaskController.text = ipConfigNetmask;
                                      AppBuilder.of(context)!.rebuild();
                                      Navigator.maybeOf(context)!.pop();
                                      errorDialog(context, S
                                          .of(context)
                                          .setIpConfigErrorTitle, S
                                          .of(context)
                                          .deviceNotFoundSetIpConfig + "\n\n" + S
                                          .of(context)
                                          .deviceNotFoundHint, size);
                                    } else if (response['result'] != "ok") {
                                      formIpAdress = ipConfigAddress;
                                      formIpAdressController.text = ipConfigAddress;
                                      formNetmask = ipConfigNetmask;
                                      formNetmaskController.text = ipConfigNetmask;
                                      AppBuilder.of(context)!.rebuild();
                                      Navigator.maybeOf(context)!.pop();
                                      errorDialog(context, S
                                          .of(context)
                                          .setIpConfigErrorTitle, S
                                          .of(context)
                                          .setIpConfigErrorBody, size);
                                    }
                                  }
                                  else {

                                  }
                                }
                                : null,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .resolveWith<Color?>(
                                      (states) {
                                    if (states.contains(
                                        MaterialState.hovered)) {
                                      return devoloGreen.withOpacity(
                                          hoverOpacity);
                                    } else if (states.contains(
                                        MaterialState.pressed)) {
                                      return devoloGreen.withOpacity(
                                          activeOpacity);
                                    }
                                    return (formIpAdress != ipConfigAddress || formNetmask != ipConfigNetmask) ? devoloGreen : buttonDisabledBackground;
                                  },
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 32.0)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    )
                                )
                            ),
                          ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                  )
                ]);
          }),
        );
      });
}

void circularProgressIndicatorInMiddle(context){
  showDialog<void>(
      context: context,
      barrierDismissible: false, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Column(mainAxisSize: MainAxisSize.min ,
              children: [
                CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(fontColorOnBackground),)]
          ),
        );
      });
}
