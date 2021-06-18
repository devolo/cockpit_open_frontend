import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:flutter/material.dart';

import 'alertDialogs.dart';
import 'app_colors.dart';
import 'buttons.dart';
import 'helpers.dart';

void deviceInformationDialog(context, Device hitDevice, FocusNode myFocusNode, DataHand socket) {

  String newName = hitDevice.name;
  bool changeNameLoading = false;

  showDialog<void>(
    context: context,
    barrierDismissible: true, // user doesn't need to tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor.withOpacity(0.9),
        contentTextStyle: TextStyle(color: Colors.white,
            decorationColor: Colors.white,
            fontSize: 17 * fontSizeFactor),
        title: Column(
          children: [
            getCloseButton(context),
            SelectableText(
              S
                  .of(context)
                  .deviceinfo,
              style: TextStyle(color: Colors.white),
              textScaleFactor: fontSizeFactor,
            ),
          ],
        ),
        titlePadding: EdgeInsets.all(2),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
        content: SingleChildScrollView(
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
                      if (changeNameLoading)
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              secondColor),
                          strokeWidth: 2.0,
                        ),
                      SizedBox(width: 25),
                      SelectableText(
                        'Name:   ',
                        style: TextStyle(height: 2),
                      ),
                    ]),
                    TextFormField(
                      initialValue: newName,
                      focusNode: myFocusNode,
                      style: TextStyle(color: fontColorLight),
                      cursorColor: fontColorLight,
                      decoration: InputDecoration(
                        hoverColor: secondColor.withOpacity(0.2),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
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
                            if (newName != hitDevice.name) {
                              bool confResponse = await confirmDialog(context, S
                                  .of(context)
                                  .deviceNameDialogTitle, S
                                  .of(context)
                                  .deviceNameDialogBody);
                              if (confResponse) {
                                changeNameLoading = true;
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
                                      .deviceNotFoundHint);
                                } else if (response['result'] != "ok") {
                                  errorDialog(context, S
                                      .of(context)
                                      .deviceNameErrorTitle, S
                                      .of(context)
                                      .deviceNameErrorBody);
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
                              .deviceNameDialogBody);
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
                                  .deviceNameErrorBody);
                            } else
                            if (response['result'] == "device_not_found") {
                              errorDialog(context, S
                                  .of(context)
                                  .deviceNameErrorTitle, S
                                  .of(context)
                                  .deviceNotFoundDeviceName + "\n\n" + S
                                  .of(context)
                                  .deviceNotFoundHint);
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
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: SelectableText(
                            "${S
                                .of(context)
                                .type}   ",
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
                                .serialNumber}   ",
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
                              .mtnumber}   ",
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
                              .version}   ",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: SelectableText(
                          hitDevice.version + "(" + hitDevice.version_date + ")"),
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
                              .ipaddress}   ",
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
                              .macaddress}   ",
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
                                ? fontColorNotAvailable
                                : fontColorLight),
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
                                .deviceNotFoundHint);
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
                                ? fontColorNotAvailable
                                : fontColorLight),
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
                                  .manualErrorBody);
                            }
                          }),
                      Text(
                        S
                            .of(context)
                            .showManual,
                        style: TextStyle(fontSize: 14, color: fontColorLight),
                        textScaleFactor: fontSizeFactor,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  if (hitDevice.supported_vdsl != null)
                    Column(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.router_rounded,
                              color: fontColorLight,
                            ),
//tooltip: S.of(context).showManual,
                            hoverColor: fontColorLight.withAlpha(50),
                            iconSize: 24.0 * fontSizeFactor,
                            onPressed: () {
                              showVDSLDialog(
                                  context,socket, hitDevice.mode_vdsl, hitDevice.supported_vdsl,
                                  hitDevice.selected_vdsl, hitDevice.mac);
                            }),
                        Text(
                          S
                              .of(context)
                              .setVdslCompatibility,
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
                          hitDevice.attachedToRouter
                              ? confResponse = await confirmDialog(context, S
                              .of(context)
                              .resetDeviceConfirmTitle, S
                              .of(context)
                              .resetDeviceConfirmBody + "\n" + S
                              .of(context)
                              .confirmActionConnectedToRouterWarning)
                              : confResponse = await confirmDialog(context, S
                              .of(context)
                              .resetDeviceConfirmTitle, S
                              .of(context)
                              .resetDeviceConfirmBody);

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
                                  .deviceNotFoundHint);
                            } else if (response['result'] != "ok") {
                              errorDialog(context, S
                                  .of(context)
                                  .resetDeviceErrorTitle, S
                                  .of(context)
                                  .resetDeviceErrorBody);
                            }
                          }
                        },
                      ),
                      Text(
                        S
                            .of(context)
                            .factoryReset,
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
                          hitDevice.attachedToRouter
                              ? confResponse = await confirmDialog(context, S
                              .of(context)
                              .removeDeviceConfirmTitle, S
                              .of(context)
                              .removeDeviceConfirmBody + "\n" + S
                              .of(context)
                              .confirmActionConnectedToRouterWarning)
                              : confResponse = await confirmDialog(context, S
                              .of(context)
                              .removeDeviceConfirmTitle, S
                              .of(context)
                              .removeDeviceConfirmBody);

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
                                  .deviceNotFoundHint);
                            } else if (response['result'] != "ok") {
                              errorDialog(context, S
                                  .of(context)
                                  .removeDeviceErrorTitle, S
                                  .of(context)
                                  .removeDeviceErrorBody);
                            }
                          }
                        },
                      ),
                      Text(
                        S
                            .of(context)
                            .deleteDevice,
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
      );
    },
  );
}

void showVDSLDialog(context, socket, String hitDeviceVDSLmode, List<String> hitDeviceVDSLList, String vdslProfile, hitDeviceMac) {
  bool vdslModeAutomatic = false;
  if(hitDeviceVDSLmode == "2")
    vdslModeAutomatic = true;

  showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 300),
          title: Text(S.of(context).vdslCompatibility),
          titleTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
          backgroundColor: backgroundColor.withOpacity(0.9),
          contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(hitDeviceVDSLmode != "0")
                      Column(children: [
                        SelectableText(S.of(context).vdslexplanation),
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: secondColor,
                              ),
                              child: Checkbox(
                                  value: vdslModeAutomatic,
                                  activeColor: secondColor,
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
                        SelectableText(S.of(context).vdslexplanation2),
                      ],),
                    for (String vdsl_profile in hitDeviceVDSLList)
                      ListTile(
                        title: Text(
                          vdsl_profile,
                          style:  TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
                        ),
                        leading: Theme(
                          data: ThemeData(
                            //here change to your color
                            unselectedWidgetColor: secondColor,
                          ),
                          child: Radio(
                            value: vdsl_profile,
                            groupValue: vdslProfile,
                            activeColor: secondColor,
                            onChanged: (String? value) {
                              setState(() {
                                vdslProfile = value!;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                );
              }),
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
              onPressed: () async {
                bool confResponse = false;
                confResponse = await confirmDialog(context, "Set VDSL Compatibility", "Neue VDSL Einstellungen ${vdslProfile} übernehmen? ${hitDeviceVDSLmode}");

                if (confResponse) {
                  socket.sendXML('SetVDSLCompatibility', newValue: vdslProfile, valueType: 'profile', newValue2: hitDeviceVDSLmode, valueType2: 'mode', mac: hitDeviceMac);

                  showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user doesn't need to tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: Column(mainAxisSize: MainAxisSize.min ,
                              children: [
                                CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(secondColor),)]
                          ),
                        );
                      });

                  var response = await socket.receiveXML("SetVDSLCompatibilityStatus");
                  if (response['result'] == "failed") {
                    Navigator.maybeOf(context)!.pop(true);
                    errorDialog(context, " ", S.of(context).vdslfailed);
                  } else if (response['result'] != "ok") {
                    Navigator.maybeOf(context)!.pop(true);
                    errorDialog(context, "Done", S.of(context).resetDeviceErrorBody);
                  }
                  else {
                    Navigator.maybeOf(context)!.pop();
                  }
                }
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
                  Navigator.maybeOf(context)!.pop(false);
                }),
          ],

        );
      });
}