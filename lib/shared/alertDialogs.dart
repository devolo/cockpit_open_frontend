import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'buttons.dart';

// Confirmation Dialog with 2 Buttons
Future<bool> confirmDialog(context, title, body) async {
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
                style: TextStyle(color: fontColorLight),
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(2),
          backgroundColor: backgroundColor.withOpacity(0.9),
          contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18 * fontSizeFactor),
          content: Text(body),
          actions: <Widget>[
            getConfirmButton(context),
            getCancelButton(context)
          ],
        );
      });

  if (returnVal == null) returnVal = false;

  return returnVal;
}

void errorDialog(context, title, body) {
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
                style: TextStyle(color: fontColorLight),
              ),
            ],
          ),
          titlePadding: EdgeInsets.all(2),
          backgroundColor: backgroundColor.withOpacity(0.9),
          contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18 * fontSizeFactor),
          content: Text(body),
          actions: <Widget>[],
        );
      });
}