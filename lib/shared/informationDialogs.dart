import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';
import 'package:flutter/material.dart';

import 'alertDialogs.dart';
import 'app_colors.dart';
import 'app_fontSize.dart';
import 'buttons.dart';
import 'devolo_icons_icons.dart';
import 'helpers.dart';

void deviceInformationDialog(context, Device hitDevice, FocusNode myFocusNode, DataHand socket, FontSize fontSize) {

  String newName = hitDevice.name;
  bool changeNameLoading = false;

  showDialog<void>(

    context: context,
    barrierDismissible: true, // user doesn't need to tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentTextStyle: TextStyle(color: fontColorOnBackground,
            fontSize: dialogContentTextFontSize * fontSize.factor),
        title: Column(
          children: [
            getCloseButton(context),
            SelectableText(
              S
                  .of(context)
                  .deviceinfo,
              style: TextStyle(color: fontColorOnBackground),
              textScaleFactor: fontSize.factor,
            ),
          ],
        ),
        titlePadding: EdgeInsets.all(dialogTitlePadding),
        titleTextStyle: TextStyle(
          color: fontColorOnBackground,
          fontSize: dialogTitleTextFontSize,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
            SizedBox(
              height: 15,
              width: 800.0 * fontSize.factor,
          ),
          Table(
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: SelectableText(
                        'Name:   ',
                      )),
                ),
                Container (
                  width: 60, // doesn´t affect the width in the text field
                  child: TextFormField(
                    initialValue: newName,
                    focusNode: myFocusNode,
                    style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize* fontSize.factor),
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
                      suffixIcon: changeNameLoading
                        ? SizedBox(
                          width: 0.5,
                          height: 0.5,
                          child: Padding(padding: const EdgeInsets.all(10.0), child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                fontColorOnBackground),
                            strokeWidth: 3.0,
                          )))
                      : IconButton(
                        icon: Icon(
                          DevoloIcons.ic_edit_24px,
                          color: fontColorOnBackground,
                        ),
                        onPressed: () async {
                          if (newName != hitDevice.name) {
                            bool confResponse = await confirmDialog(context, S
                                .of(context)
                                .deviceNameDialogTitle, S
                                .of(context)
                                .deviceNameDialogBody, fontSize);
                            if (confResponse) {
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

  //setState(() {
  //   socket.sendXML('RefreshNetwork');
  //});
                              } else
                              if (response['result'] == "device_not_found") {
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
                            }
                          }
                        },
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
                          } else
                          if (response['result'] == "device_not_found") {
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
                      alignment: Alignment.centerRight,
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
                      alignment: Alignment.centerRight,
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
                    alignment: Alignment.centerRight,
                    child: SelectableText(
                      "${S
                          .of(context)
                          .mtnumber}:   ",
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
                    alignment: Alignment.centerRight,
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
                      hitDevice.version + "(" + hitDevice.versionDate + ")"),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SelectableText(
                      "${S
                          .of(context)
                          .ipaddress}:   ",
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
                    alignment: Alignment.centerRight,
                    child: SelectableText(
                      "${S
                          .of(context)
                          .macaddress}:   ",
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
//Text('Rates: ' +hitDeviceRx),
          Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
          Wrap(
            spacing: 20,
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
                      disabledColor: fontColorOnBackground.withOpacity(0.33),
                      color: fontColorOnBackground,
                      hoverColor: fontColorOnBackground.withAlpha(50),
                      iconSize: 24.0 * fontSize.factor,
                      onPressed: !hitDevice.webinterfaceAvailable ? null : () =>
                          launchURL(hitDevice.ip),
                      mouseCursor: !hitDevice.webinterfaceAvailable ? SystemMouseCursors
                          .basic : SystemMouseCursors.click,
                    ),
                    Text(
                      S
                          .of(context)
                          .launchWebinterface,
                      style: TextStyle(fontSize: 14,
                          color: !hitDevice.webinterfaceAvailable
                              ? fontColorOnBackground.withOpacity(0.33)
                              : fontColorOnBackground),
                      textScaleFactor: fontSize.factor,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        DevoloIcons.ic_lightbulb_outline_24px,
                      ),
//tooltip: S.of(context).identifyDevice,
                      disabledColor: fontColorOnBackground.withOpacity(0.33),
                      color: fontColorOnBackground,
                      hoverColor: fontColorOnBackground.withAlpha(50),
                      iconSize: 24.0 * fontSize.factor,
                      onPressed: !hitDevice.identifyDeviceAvailable
                          ? null
                          : () async {
                        socket.sendXML('IdentifyDevice', mac: hitDevice.mac);
                        var response = await socket.receiveXML(
                            "IdentifyDeviceStatus");
                        if (response!['result'] == "device_not_found") {
                          errorDialog(context, S
                              .of(context)
                              .identifyDeviceErrorTitle, S
                              .of(context)
                              .deviceNotFoundIdentifyDevice + "\n\n" + S
                              .of(context)
                              .deviceNotFoundHint, fontSize);
                        }
                        else if(response['result'] != "ok"){
                          errorDialog(context, S
                              .of(context)
                              .identifyDeviceErrorTitle, S
                              .of(context)
                              .identifyDeviceErrorBody, fontSize);
                        }
                      },

                      mouseCursor: !hitDevice.identifyDeviceAvailable ? SystemMouseCursors
                          .basic : SystemMouseCursors.click,
                    ),
                    Text(
                      S
                          .of(context)
                          .identifyDevice,
                      style: TextStyle(fontSize: 14,
                          color: !hitDevice.identifyDeviceAvailable
                              ? fontColorOnBackground.withOpacity(0.33)
                              : fontColorOnBackground),
                      textScaleFactor: fontSize.factor,
                      textAlign: TextAlign.center,
                    )
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
                          iconSize: 24.0 * fontSize.factor,
                          onPressed: () async {
                            socket.sendXML('GetManual', newValue: hitDevice.MT,
                                valueType: 'product',
                                newValue2: 'de',
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
                      Text(
                        S
                            .of(context)
                            .showManual,
                        style: TextStyle(fontSize: 14, color: fontColorOnBackground),
                        textScaleFactor: fontSize.factor,
                        textAlign: TextAlign.center,
                      )
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
                          iconSize: 24.0 * fontSize.factor,
                          onPressed: (hitDevice.supportedVDSL.isNotEmpty)
                              ? () { showVDSLDialog(
                              context,socket, hitDevice.modeVDSL, hitDevice.supportedVDSL,
                              hitDevice.selectedVDSL, hitDevice.mac, fontSize);
                          }
                          : null,
                        mouseCursor: !hitDevice.supportedVDSL.isNotEmpty ? SystemMouseCursors
                            .basic : SystemMouseCursors.click,
                      ),
                      Text(
                        S
                            .of(context)
                            .setVdslCompatibility,
                        style: TextStyle(fontSize: 14, color: !hitDevice.supportedVDSL.isNotEmpty ? fontColorOnBackground.withOpacity(0.33) : fontColorOnBackground),                        textScaleFactor: fontSize.factor,
                        textAlign: TextAlign.center,
                      )
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
                      iconSize: 24.0 * fontSize.factor,
                      onPressed: () async {
                        bool confResponse = false;
                        hitDevice.attachedToRouter
                            ? confResponse = await confirmDialog(context, S
                            .of(context)
                            .resetDeviceConfirmTitle, S
                            .of(context)
                            .resetDeviceConfirmBody + "\n" + S
                            .of(context)
                            .confirmActionConnectedToRouterWarning, fontSize)
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
                    Text(
                      S
                          .of(context)
                          .factoryReset,
                      style: TextStyle(fontSize: 14, color: fontColorOnBackground),
                      textScaleFactor: fontSize.factor,
                      textAlign: TextAlign.center,
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
                      iconSize: 24.0 * fontSize.factor,
                      onPressed: () async {
                        bool confResponse = false;
                        hitDevice.attachedToRouter
                            ? confResponse = await confirmDialog(context, S
                            .of(context)
                            .removeDeviceConfirmTitle, S
                            .of(context)
                            .removeDeviceConfirmBody + "\n" + S
                            .of(context)
                            .confirmActionConnectedToRouterWarning, fontSize)
                            : confResponse = await confirmDialog(context, S
                            .of(context)
                            .removeDeviceConfirmTitle, S
                            .of(context)
                            .removeDeviceConfirmBody, fontSize);

                        if (confResponse) {
                          socket.sendXML("RemoveAdapter", mac: hitDevice.mac);

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
                    Text(
                      S
                          .of(context)
                          .deleteDevice,
                      style: TextStyle(fontSize: 14, color: fontColorOnBackground),
                      textScaleFactor: fontSize.factor,
                      textAlign: TextAlign.center,
                    )
                  ],
                ), //ToDo Delete Device see wiki
              if (hitDevice.disableTraffic[0] == 1 || hitDevice.disableLeds[0] == 1 || hitDevice.disableStandby[0] == 1)
                Column(
                  children: [
                    IconButton(
                        icon: Icon(
                          DevoloIcons.devolo_UI_more_horiz,
                          color: fontColorOnBackground,
                        ),
                        hoverColor: fontColorOnBackground.withAlpha(50),
                        iconSize: 24.0 * fontSize.factor,
                        onPressed: () {
                          moreSettings(context,socket,hitDevice.disableTraffic,hitDevice.disableLeds, hitDevice.disableStandby, hitDevice.mac, fontSize);
                        }),
                    Text(
                      S.of(context).additionalSettings,
                      style: TextStyle(fontSize: 14, color: fontColorOnBackground),
                      textScaleFactor: fontSize.factor,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
            ],
          ),
            ],
          ),
        ),
      );
    },
  );
}


void showVDSLDialog(context, socket, String hitDeviceVDSLmode, List<String> hitDeviceVDSLList, String vdslProfile, hitDeviceMac, FontSize fontSize) async {

  bool vdslModeAutomatic = false;
  if(hitDeviceVDSLmode == "2")
    vdslModeAutomatic = true;

  bool? returnVal = await showDialog(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 300),
          title: Text(S.of(context).vdslCompatibility),
          titleTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(hitDeviceVDSLmode != "0")
                        Column(children: [
                          SelectableText(S.of(context).vdslexplanation),
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
                                      activeColor: fontColorOnBackground,
                                      onChanged: (bool? newValue) async {
                                        vdslModeAutomatic = newValue!;
                                        setState(() {
                                          if (vdslModeAutomatic == true) {
                                            hitDeviceVDSLmode = "2";
                                          } else {
                                            hitDeviceVDSLmode = "1";
                                          }
                                        });
                                      }),
                                ),
                                SelectableText(S.of(context).automaticCompatibilityMode),
                              ],
                            ),
                          ),
                          SelectableText(S.of(context).vdslexplanation2),
                        ],),
                      for (String vdsl_profile in hitDeviceVDSLList)
                        ListTile(
                          title: Text(
                            vdsl_profile,
                            style:  TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                          ),
                          leading: Theme(
                            data: ThemeData(
                              //here change to your color
                              unselectedWidgetColor: fontColorOnBackground,
                            ),
                            child: Radio(
                              value: vdsl_profile,
                              groupValue: vdslProfile,
                              activeColor: fontColorOnBackground,
                              onChanged: (String? value) {
                                setState(() {
                                  vdslProfile = value!;
                                });
                              },
                            ),
                          ),
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

    socket.sendXML('SetVDSLCompatibility', newValue: vdslProfile, valueType: 'profile', newValue2: hitDeviceVDSLmode, valueType2: 'mode', mac: hitDeviceMac);

      circularProgressIndicatorInMiddle(context);

    var response = await socket.receiveXML("SetVDSLCompatibilityStatus");
    if (response['result'] == "failed") {
      Navigator.maybeOf(context)!.pop(true);
      errorDialog(context, "Error", S.of(context).vdslfailed, fontSize);
    } else if (response['result'] == "ok") {
      Navigator.maybeOf(context)!.pop(true);
      errorDialog(context, "Done", S.of(context).vdslsuccessful, fontSize);
    }
    else {
      logger.w("[showVDSLDialog] - Unexpected response: " + response['result']);
      Navigator.maybeOf(context)!.pop();
    }
  }
  else {
    Navigator.maybeOf(context)!.pop(false);
  }
}

void moreSettings(BuildContext context, socket, List<int> disableTraffic,List<int> disableLeds, List<int> disableStandby, String mac, FontSize fontSize) {

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
          titleTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
          title: Column(
            children: [
              getCloseButton(context),
              Center(
                  child: Text(
                    S.of(context).additionalDialogTitle,
                    style: TextStyle(color: fontColorOnBackground),
                  )
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          content: Column(
            mainAxisSize: MainAxisSize.min,
              children: [
                if(disableLeds[0] == 1)
                  SwitchListTile(
                    title:  Text(S.of(context).activateLEDs, style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor )),
                    value: disableLeds[1] == 0 ? true : false,
                    onChanged: (bool value) async {
                      String newStatus =  value? "0" : "1";
                      socket.sendXML('DisableLEDs', newValue: newStatus, valueType: 'state', mac: mac);
                      circularProgressIndicatorInMiddle(context);
                      var response = await socket.receiveXML("DisableLEDsStatus");
                      if(response['result'] == "ok") {
                        disableLeds[1] = value ? 0 : 1;
                        Navigator.maybeOf(context)!.pop();
                      }
                      else{
                        Navigator.maybeOf(context)!.pop();
                        errorDialog(context, S.of(context).activateLEDsFailedTitle, S.of(context).activateLEDsFailedBody, fontSize);
                      }

                      },
                    secondary: Icon(DevoloIcons.ic_lightbulb_outline_24px, color: fontColorOnBackground, size: 24 * fontSize.factor),
                    activeTrackColor: switchActiveTrackColor,
                    activeColor: switchActiveThumbColor,
                    inactiveThumbColor: switchInactiveThumbColor,
                    inactiveTrackColor: switchInactiveTrackColor,
                  ),
                if(disableTraffic[0] == 1)
                  SwitchListTile(
                    title: Text(S.of(context).activateTransmission, style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor )),
                    value: disableTraffic[1] == 0 ? true : false,
                    onChanged: (bool value) async {
                      String newStatus =  value? "0" : "1";
                      socket.sendXML('DisableTraffic', newValue: newStatus, valueType: 'state', mac: mac);
                      circularProgressIndicatorInMiddle(context);
                      var response = await socket.receiveXML("DisableTrafficStatus");
                      if(response['result'] == "ok"){
                        disableTraffic[1] = value ? 0 : 1;
                        Navigator.maybeOf(context)!.pop();
                      }
                      else{
                        Navigator.maybeOf(context)!.pop();
                        errorDialog(context, S.of(context).activateTransmissionFailedTitle, S.of(context).activateTransmissionFailedBody, fontSize);
                      }


                    },
                    secondary: Icon(DevoloIcons.ic_perm_data_setting_24px, color: fontColorOnBackground, size: 24 * fontSize.factor),
                    activeTrackColor: switchActiveTrackColor,
                    activeColor: switchActiveThumbColor,
                    inactiveThumbColor: switchInactiveThumbColor,
                    inactiveTrackColor: switchInactiveTrackColor,
                  ),
                if(disableStandby[0] == 1)
                  SwitchListTile(
                    title: Text(S.of(context).powerSavingMode, style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor )),
                    value: disableStandby[1] == 0 ? true : false,
                    onChanged: (bool value) async {
                      String newStatus =  value? "0" : "1";
                      socket.sendXML('DisableStandby', newValue: newStatus, valueType: 'state', mac: mac);
                      circularProgressIndicatorInMiddle(context);
                      var response = await socket.receiveXML("DisableStandbyStatus");
                      if(response['result'] == "ok"){
                        disableStandby[1] = value ? 0 : 1;
                        Navigator.maybeOf(context)!.pop();
                      }
                      else{
                        Navigator.maybeOf(context)!.pop();
                        errorDialog(context, S.of(context).powerSavingModeFailedTitle, S.of(context).powerSavingModeFailedBody, fontSize);
                      }
                    },
                    secondary: Icon(DevoloIcons.ic_battery_charging_full_24px, color: fontColorOnBackground, size: 24 * fontSize.factor),
                    activeTrackColor: switchActiveTrackColor,
                    activeColor: switchActiveThumbColor,
                    inactiveThumbColor: switchInactiveThumbColor,
                    inactiveTrackColor: switchInactiveTrackColor,
                  )
              ]),
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
