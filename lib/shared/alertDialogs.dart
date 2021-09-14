import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fontSize.dart';
import 'buttons.dart';

// Confirmation Dialog with 2 Buttons
Future<bool> confirmDialog(context, title, body, FontSize fontSize) async {

  bool? returnVal = await showDialog(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              getCloseButton(context),
              Text(
                title,
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
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

void errorDialog(context, title, body, FontSize fontSize) {

  showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              getCloseButton(context),
              Text(
                title,
                style: TextStyle(color: fontColorOnBackground),
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(dialogTitlePadding),
          titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
          contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
          content: Text(body),
          actions: <Widget>[],
        );
      });
}
