/*
Copyright © 2023, devolo GmbH
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/sizeModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:flutter/material.dart';

import '../../shared/alertDialogs.dart';
import '../../shared/app_colors.dart';
import '../../shared/app_fontSize.dart';
import '../../shared/buttons.dart';
import '../../shared/devolo_icons.dart';
import '../../shared/helpers.dart';

void _contactInfoAlert(context, DataHand socket, SizeModel size) {
  String _processNr = "";
  String _name = "";
  String _email = "";
  final _formKey = GlobalKey<FormState>();

  showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            S
                .of(context)
                .contactInfo,
          ),
          titleTextStyle: TextStyle(color: fontColorOnBackground,
              fontSize: dialogTitleTextFontSize * size.font_factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground,
              fontSize: dialogContentTextFontSize * size.font_factor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(S
                  .of(context)
                  .theCreatedSupportInformationCanNowBeSentToDevolo,
                textScaleFactor: size.font_factor,),
              SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: fontColorOnBackground),
                        decoration: InputDecoration(
                          labelText: S
                              .of(context)
                              .processNumber,
                          labelStyle: TextStyle(color: fontColorOnBackground,
                              fontSize: dialogContentTextFontSize *
                                  size.font_factor),
                          hoverColor: fontColorOnBackground.withOpacity(0.2),
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
                        onChanged: (value) => (_processNr = value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S
                                .of(context)
                                .pleaseEnterProcessingNumber;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: fontColorOnBackground),
                        decoration: InputDecoration(
                          labelText: S
                              .of(context)
                              .yourName,
                          labelStyle: TextStyle(color: fontColorOnBackground,
                              fontSize: dialogContentTextFontSize *
                                  size.font_factor),
                          hoverColor: fontColorOnBackground.withOpacity(0.2),
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
                        onChanged: (value) => (_name = value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S
                                .of(context)
                                .pleaseFillInYourName;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        //initialValue: _newPw,
                        style: TextStyle(color: fontColorOnBackground),
                        decoration: InputDecoration(
                          labelText: S
                              .of(context)
                              .yourEmailAddress,
                          labelStyle: TextStyle(color: fontColorOnBackground,
                              fontSize: dialogContentTextFontSize *
                                  size.font_factor),
                          counterStyle: TextStyle(
                              color: fontColorOnBackground),
                          hoverColor: fontColorOnBackground.withOpacity(0.2),
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
                        onChanged: (value) => (_email = value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S
                                .of(context)
                                .pleaseEnterYourMailAddress;
                          }

                          if (!value.contains('@')) {
                            return S
                                .of(context)
                                .emailIsInvalid;
                          }
                          return null;
                        },
                      ),
                    ],
                  )
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S
                    .of(context)
                    .confirm,
                style: TextStyle(
                    fontSize: dialogContentTextFontSize, color: Colors.white),
                textScaleFactor: size.font_factor,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  socket.sendSupportInfo(_processNr, _name, _email);
                  Navigator.of(dialogContext).pop();
                  _sendingSupportInformation(context, socket, size);
                }
                else {
                  logger.i("failed");
                  //Navigator.maybeOf(context)!.pop();
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
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                  )
              ),
            ),
            TextButton(
              child: Text(
                S
                    .of(context)
                    .cancel,
                style: TextStyle(fontSize: dialogContentTextFontSize),
                textScaleFactor: size.font_factor,
              ),
              onPressed: () {
                Navigator.maybeOf(context)!.pop(false);
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
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )
                ),
                side: MaterialStateProperty.resolveWith<BorderSide>(
                      (states) {
                    if (states.contains(MaterialState.hovered)) {
                      return BorderSide(
                          color: drawingColor.withOpacity(hoverOpacity),
                          width: 2.0);
                    } else if (states.contains(MaterialState.pressed)) {
                      return BorderSide(
                          color: drawingColor.withOpacity(activeOpacity),
                          width: 2.0);
                    }
                    return BorderSide(color: drawingColor, width: 2.0);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      });
}

//!!! add manually confirm/cancel buttons
void _sendingSupportInformation(context, DataHand socket, SizeModel size) async {
  bool dialogIsOpen = true;

  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 8.0),
                alignment: FractionalOffset.topRight,
                child: Material( // needed to have the splashAnimation in foreground
                  color: Colors.transparent,
                  child:IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 15 * size.icon_factor,
                    iconSize: 24 * size.icon_factor,
                    alignment: Alignment.center,
                    color: fontColorOnBackground,
                    icon: Icon(DevoloIcons.devolo_UI_cancel_2),
                    onPressed: (){
                      dialogIsOpen = false;
                      Navigator.maybeOf(context)!.pop();
                    },
                  ),
                ),
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          contentTextStyle: TextStyle(color: fontColorOnBackground,
              decorationColor: fontColorOnBackground,
              fontSize: dialogContentTextFontSize * size.font_factor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: CircularProgressIndicator(
                    color: fontColorOnBackground),
                height: 50.0,
                width: 50.0,
              ),
              SizedBox(height: 20,),
              Text(
                S
                    .of(context)
                    .SendCockpitSupportInformationBody,
                style: TextStyle(color: fontColorOnBackground),
              ),
            ],
          ),
          actions: <Widget>[],
        );
      });

  var response = await socket.receiveXML("SupportInfoSendStatus");

  if (response!["result"] == "ok") {
    if (dialogIsOpen)
      Navigator.of(context).pop();
  }

  else if (response["result"] == "failed" || response["result"] == "timeout") {
    if (dialogIsOpen){
      Navigator.of(context).pop();
    }

    errorDialog(context, S
        .of(context)
        .supportInfoSendErrorTitle, S
        .of(context)
        .supportInfoSendErrorBody1 + "\n\n" + S
        .of(context)
        .supportInfoSendErrorBody2, size);
  }
}

void _contactSupportAlert(context, DataHand socket, htmlFileName, zipFileName, SizeModel fontSize) {
  showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              getCloseButton(context, fontSize),
              Center(
                  child: Text(
                    S
                        .of(context)
                        .cockpitSupportInformationTitle,
                  )
              ),
            ],
          ),
          titleTextStyle: TextStyle(color: fontColorOnBackground,
              fontSize: dialogTitleTextFontSize * fontSize.font_factor),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          contentTextStyle: TextStyle(color: fontColorOnBackground,
              fontSize: dialogContentTextFontSize * fontSize.font_factor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Text(
                  S
                      .of(context)
                      .cockpitSupportInformationBody,
                  style: TextStyle(color: fontColorOnBackground),
                ),
              ),
              SizedBox(height: 20,),
              TextButton(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    DevoloIcons.ic_send_24px,
                    color: fontColorOnMain,
                      size: 24 * fontSize.icon_factor
                  ),
                  SizedBox(width: 4,),
                  Text(
                    S
                        .of(context)
                        .send,
                    style: TextStyle(fontSize: dialogContentTextFontSize,
                        color: fontColorOnMain),
                    textScaleFactor: fontSize.font_factor,
                  ),
                ]),
                onPressed: () {
                  _contactInfoAlert(context, socket, fontSize);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<
                        Color?>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return devoloGreen.withOpacity(0.7);
                        } else if (states.contains(MaterialState.pressed)) {
                          return devoloGreen.withOpacity(0.33);
                        }
                        return devoloGreen;
                      },
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 32.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextButton(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.open_in_browser,
                    color: fontColorOnMain,
                      size: 24 * fontSize.icon_factor
                  ),
                  SizedBox(width: 4,),
                  Text(
                    S
                        .of(context)
                        .open,
                    style: TextStyle(fontSize: dialogContentTextFontSize,
                        color: fontColorOnMain),
                    textScaleFactor: fontSize.font_factor,
                  ),
                ]),
                onPressed: () {
                  openFile(htmlFileName);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<
                        Color?>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return devoloGreen.withOpacity(0.7);
                        } else if (states.contains(MaterialState.pressed)) {
                          return devoloGreen.withOpacity(0.33);
                        }
                        return devoloGreen;
                      },
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 32.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextButton(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    DevoloIcons.ic_archive_24px,
                    color: fontColorOnMain,
                      size: 24 * fontSize.icon_factor
                  ),
                  SizedBox(width: 4,),
                  Text(
                    S
                        .of(context)
                        .save,
                    style: TextStyle(fontSize: dialogContentTextFontSize,
                        color: fontColorOnMain),
                    textScaleFactor: fontSize.font_factor,
                  ),
                ]),
                onPressed: () {
                  openFile(zipFileName);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<
                        Color?>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return devoloGreen.withOpacity(0.7);
                        } else if (states.contains(MaterialState.pressed)) {
                          return devoloGreen.withOpacity(0.33);
                        }
                        return devoloGreen;
                      },
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 32.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )
                    )
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        );
      }).then((val) {
    socket.sendXML(
        "SupportInfoCleanup"); // clean temporary files after closing support dialog
  });
}

// !!! closeButton is added manually
void loadingSupportDialog(context, DataHand socket, SizeModel size) async {
  bool dialogIsOpen = true;
  bool actionSucessfull = true;

  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 8.0),
                alignment: FractionalOffset.topRight,
                child: Material( // needed to have the splashAnimation in foreground
                  color: Colors.transparent,
                  child:IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 15 * size.icon_factor,
                    iconSize: 24 * size.icon_factor,
                    alignment: Alignment.center,
                    color: fontColorOnBackground,
                    icon: Icon(DevoloIcons.devolo_UI_cancel_2),
                    onPressed: (){
                      dialogIsOpen = false;
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          contentTextStyle: TextStyle(color: fontColorOnBackground,
              decorationColor: fontColorOnBackground,
              fontSize: dialogContentTextFontSize * size.font_factor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(actionSucessfull)
                Container(
                  child: CircularProgressIndicator(
                      color: fontColorOnBackground),
                  height: 50.0,
                  width: 50.0,
                ),
              if(actionSucessfull)
                SizedBox(height: 20,),
              if(actionSucessfull)
                Text(
                  S
                      .of(context)
                      .LoadCockpitSupportInformationBody,
                  style: TextStyle(color: fontColorOnBackground),
                ),
              if(!actionSucessfull)
                Text(
                  S
                      .of(context)
                      .supportInfoGenerateError,
                  style: TextStyle(color: fontColorOnBackground),
                ),
            ],
          ),
          actions: <Widget>[],
        );
      });

  socket.sendXML('SupportInfoGenerate');
  var response = await socket.receiveXML("SupportInfoGenerateStatus");

  if (response!["result"] == "ok") {
    if (dialogIsOpen) {
      Navigator.pop(context, true);
    }

    _contactSupportAlert(
        context, socket, response["htmlfilename"], response["zipfilename"], size);
  }

  else
  if (response["result"] == "failed" || response["result"] == "timeout") {
    actionSucessfull = false;
  }
}