import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/sizeModel.dart';
import 'package:cockpit_devolo/shared/devolo_icons.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fontSize.dart';

getConfirmButton(context, SizeModel size) {

  return TextButton(
    child: Text(
      S.of(context).confirm,
      style: TextStyle(fontSize: dialogContentTextFontSize, color: Colors.white),
      textScaleFactor: size.font_factor,
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

getCancelButton(context, SizeModel size) {

  return TextButton(
    child: Text(
      S.of(context).cancel,
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

getGreenButton(context, text, SizeModel size) {

  return TextButton(
    child: Text(
      text,
      style: TextStyle(fontSize: dialogContentTextFontSize, color: fontColorOnMain),
      textScaleFactor: size.font_factor,
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

getCloseButton(context, SizeModel size, [color]) {
  if(color == null) {
    color = fontColorOnBackground;
  }

  return Container(
      padding: const EdgeInsets.only(right: 8.0),
      alignment: FractionalOffset.topRight,
      child: Material( // needed to have the splashAnimation in foreground
        color: Colors.transparent,
        child:IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 15 * size.icon_factor,
          iconSize: 24 * size.icon_factor,
          alignment: Alignment.center,
          color: color,
          icon: Icon(DevoloIcons.devolo_UI_cancel_2),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
    );
}