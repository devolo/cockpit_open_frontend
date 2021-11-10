import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/sizeModel.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fontSize.dart';
import 'buttons.dart';

// Confirmation Dialog with 2 Buttons
Future<bool> confirmDialog(context, title, body, SizeModel fontSize) async {

  bool? returnVal = await showDialog(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              getCloseButton(context, fontSize),
              Text(
                title,
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.font_factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.font_factor),
          content: Text(body),
          actions: <Widget>[
            getConfirmButton(context, fontSize),
            getCancelButton(context, fontSize)
          ],
        );
      });

  if (returnVal == null) returnVal = false;

  return returnVal;
}

Future<bool> errorDialog(context, title, body, SizeModel fontSize) async {

  bool? returnVal = await showDialog(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              getCloseButton(context, fontSize),
              Text(
                title,
                style: TextStyle(color: fontColorOnBackground),
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.font_factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.font_factor),
          content: Text(body),
          actions: <Widget>[],
        );
      });

  if (returnVal == null) returnVal = false;

  return returnVal;
}

void notAvailableDialog(context, SizeModel fontSize) async {

  showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              getCloseButton(context, fontSize),
              Text(
                S.of(context).currentlyNotAvailableTitle,
                style: TextStyle(color: fontColorOnBackground),
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.font_factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.font_factor),
          content: Text(S.of(context).currentlyNotAvailableBody),
          actions: <Widget>[],
        );
      });
}
