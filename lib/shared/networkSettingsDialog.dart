import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:flutter/material.dart';

import 'alertDialogs.dart';
import 'app_colors.dart';
import 'app_fontSize.dart';
import 'buttons.dart';
import 'devolo_icons.dart';
import 'helpers.dart';

// add closeButton manually
void networkSettingsDialog(context, NetworkList _deviceList, FocusNode myFocusNode, DataHand socket, FontSize fontSize) {
  bool networkPasswordResponseTrue = false;
  bool networkPasswordResponseFalse = false;
  bool waitForNetworkPasswordResponse = false;

  String? _newPw;
  bool _hiddenPw = true;

  var maxLength = 12;
  var minLength = 8;
  var textLength = 0;

  var _formKey = GlobalKey<FormState>();

  showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentTextStyle: TextStyle(color: fontColorOnBackground,
                  fontSize: dialogContentTextFontSize * fontSize.factor),
              title: Column(
                children: [
                  getCloseButton(context),
                  SelectableText(
                    S.of(context).networkSettings,
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
              content: Row(
                children: [
                  Expanded(
                    flex: !waitForNetworkPasswordResponse ? 2 : 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        width: 250.0,
                        child: TextFormField(
                          focusNode: myFocusNode,
                          initialValue: _newPw,
                          obscureText: _hiddenPw,
                          maxLength: maxLength,
                          style: TextStyle(color: fontColorOnBackground,
                              fontSize: fontSizeListTileSubtitle *
                                  fontSize.factor),
                          cursorColor: fontColorOnBackground,
                          decoration: InputDecoration(
                            counterText: "",
                            suffixText: '${textLength.toString()}/${maxLength
                                .toString()}',
                            labelText: S
                                .of(context)
                                .changePlcNetworkPassword,
                            labelStyle: TextStyle(color: fontColorOnBackground,
                              fontSize: fontSizeListTileSubtitle *
                                  fontSize.factor,),
                            hoverColor: mainColor.withOpacity(0.2),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            filled: true,
                            fillColor: secondColor.withOpacity(0.2),
                            //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: fontColorOnBackground.withOpacity(0.2),
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
                            suffixIcon: _hiddenPw
                                ? IconButton(

                              icon: Icon(
                                DevoloIcons.devolo_UI_visibility_off,
                                color: fontColorOnBackground,
                              ),
                              onPressed: () {
                                //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                setState(() {
                                  _hiddenPw = !_hiddenPw;
                                });
                              },
                            )
                                : IconButton(
                              icon: Icon(
                                DevoloIcons.devolo_UI_visibility,
                                color: fontColorOnBackground,
                              ),
                              onPressed: () {
                                //socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                                setState(() {
                                  _hiddenPw = !_hiddenPw;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            _newPw = value;
                            setState(() {
                              textLength = value.length;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return S
                                  .of(context)
                                  .pleaseEnterPassword;
                            }
                            if (value.length < minLength) {
                              return S
                                  .of(context)
                                  .passwordMustBeGreaterThan8Characters;
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox( width: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0), child:
                  Row(
                    children: [
                      //if(waitForNetworkPasswordResponse || networkPasswordResponseTrue || networkPasswordResponseFalse)
                      //Spacer(),
                      if(waitForNetworkPasswordResponse)
                        CircularProgressIndicator(color: fontColorOnBackground,),
                      if(networkPasswordResponseTrue)
                        Icon(DevoloIcons.devolo_UI_check_fill,
                            color: devoloGreen),
                      if(networkPasswordResponseFalse)
                        Icon(DevoloIcons.devolo_UI_cancel_fill,
                            color: fontColorOnBackground),
                    ],),
                  ),

                  // buttonstyle is added manually
                  TextButton(
                    child: Text(
                      S.of(context).change,
                      style: TextStyle(fontSize: dialogContentTextFontSize,
                          color: waitForNetworkPasswordResponse ? buttonDisabledForeground  : fontColorOnMain),
                      textScaleFactor: fontSize.factor,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<
                            Color?>(
                              (states) {
                            if (states.contains(MaterialState.hovered)) {
                              return devoloGreen.withOpacity(hoverOpacity);
                            } else if (states.contains(MaterialState.pressed)) {
                              return devoloGreen.withOpacity(activeOpacity);
                            }
                            return waitForNetworkPasswordResponse ? buttonDisabledBackground : devoloGreen;
                          },
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 32.0)),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            )
                        )
                    ), onPressed:
                  waitForNetworkPasswordResponse
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      if (_deviceList.getNetworkListLength() == 0) {
                        waitForNetworkPasswordResponse = false;
                        networkPasswordResponseFalse = true;
                        errorDialog(context, S
                            .of(context)
                            .networkPasswordErrorTitle, S
                            .of(context)
                            .networkPasswordErrorBody + "\n\n" + S
                            .of(context)
                            .networkPasswordErrorHint, fontSize);
                      } else {
                        socket.sendXML('SetNetworkPassword', newValue: _newPw,
                            valueType: "password",
                            mac: _deviceList.getLocalDevice(
                                _deviceList.selectedNetworkIndex)!.mac);
                        setState(() {
                          networkPasswordResponseTrue = false;
                          networkPasswordResponseFalse = false;
                          waitForNetworkPasswordResponse = true;
                        });
                        var response = await socket.receiveXML(
                            "SetNetworkPasswordStatus");
                        if (response!['status'] == "complete" && int.parse(
                            response['total']) > 0 && int.parse(
                            response['failed']) == 0) {
                          setState(() {
                            waitForNetworkPasswordResponse = false;
                            networkPasswordResponseTrue = true;
                          });
                        } else {
                          errorDialog(context, S
                              .of(context)
                              .networkPasswordErrorTitle, S
                              .of(context)
                              .networkPasswordErrorBody + "\n\n" + S
                              .of(context)
                              .networkPasswordErrorHint, fontSize);
                          waitForNetworkPasswordResponse = false;
                          networkPasswordResponseFalse = true;
                        }
                      }
                    } else {
                      logger.d("validation failed");
                    }
                  },
                  ),
                ]),
            );
          },
        );
      });
}





