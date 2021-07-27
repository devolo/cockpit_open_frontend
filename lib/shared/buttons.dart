import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fontSize.dart';

getConfirmButton(context, FontSize fontSize) {

  return TextButton(
    child: Text(
      S.of(context).confirm,
      style: TextStyle(fontSize: dialogContentTextFontSize, color: Colors.white),
      textScaleFactor: fontSize.factor,
    ),
    onPressed: () {
      Navigator.maybeOf(context)!.pop(true);
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
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            )
        )
    ),
  );
}

getCancelButton(context, FontSize fontSize) {

  return TextButton(
    child: Text(
      S.of(context).cancel,
      style: TextStyle(fontSize: dialogContentTextFontSize),
      textScaleFactor: fontSize.factor,
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
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          )
      ),
      side: MaterialStateProperty.resolveWith<BorderSide>(
            (states) {
          if (states.contains(MaterialState.hovered)) {
            return BorderSide(color: drawingColor.withOpacity(hoverOpacity), width: 2.0);
          } else if (states.contains(MaterialState.pressed)) {
            return BorderSide(color: drawingColor.withOpacity(activeOpacity), width: 2.0);
          }
          return BorderSide(color: drawingColor, width: 2.0);
        },
      ),
    ),
  );
}

getGreenButton(context, text, FontSize fontSize) {

  return TextButton(
    child: Text(
      text,
      style: TextStyle(fontSize: dialogContentTextFontSize, color: fontColorOnMain),
      textScaleFactor: fontSize.factor,
    ),
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
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            )
        )
    ), onPressed: () {  },
  );
}

getCloseButton(context) {

  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
    child: GestureDetector(
      onTap: () {

      },
      child: Container(
        alignment: FractionalOffset.topRight,
        child: GestureDetector(child: Icon(DevoloIcons.devolo_UI_cancel,color: fontColorOnBackground,),

          onTap: (){
            Navigator.pop(context);
          },),
      ),
    ),
  );
}