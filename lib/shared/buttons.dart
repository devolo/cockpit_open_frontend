import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

getConfirmButton(context) {

  FontSize fontSize = context.watch<FontSize>();

  return TextButton(
    child: Text(
      S.of(context).confirm,
      style: TextStyle(fontSize: 14, color: fontColorLight),
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

getCancelButton(context) {

  FontSize fontSize = context.watch<FontSize>();

  return TextButton(
    child: Text(
      S.of(context).cancel,
      style: TextStyle(fontSize: 14),
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
            return Colors.white;
          }
          return Colors.transparent;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
          if (states.contains(MaterialState.hovered)) {
            return fontColorLight.withOpacity(hoverOpacity);
          } else if (states.contains(MaterialState.pressed)) {
            return fontColorLight;
          }
          return fontColorLight;
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
            return BorderSide(color: fontColorLight.withOpacity(hoverOpacity), width: 2.0);
          } else if (states.contains(MaterialState.pressed)) {
            return BorderSide(color: fontColorLight.withOpacity(activeOpacity), width: 2.0);
          }
          return BorderSide(color: fontColorLight, width: 2.0);
        },
      ),
    ),
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
        child: GestureDetector(child: Icon(Icons.clear,color: secondColor,),

          onTap: (){
            Navigator.pop(context);
          },),
      ),
    ),
  );
}