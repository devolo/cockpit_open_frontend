/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:math';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/sizeModel.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/shared/devolo_icons.dart';
import 'package:cockpit_devolo/generated/l10n.dart';
import 'dart:ui';

class DrawOverview extends CustomPainter {
  double hnCircleRadius = 35.0;
  double productNameTopPadding = 0;
  double userNameTopPadding = 0;
  double hnCircleShadowRadius = 50.0;
  double completeCircleRadius = 50.0;
  late List<Device> _deviceList;
  late NetworkList _providerList;
  List<Offset> _deviceIconOffsetList = [];
  int pivotDeviceIndex = 0;
  int selectedNetworkIndex = 0;
  bool showingSpeeds = false; //true: draw the device circles with speeds as content. false: draw device circles with icons as content.
  double dashWidth = 9, dashSpace = 5, startX = 0;
  bool connect = false;
  int hoveredDevice = 999; // displays wich device index is hovered, if no device is hovered the index is set to 999

  final _textStyle = TextStyle(
    color: drawingColor,
    fontFamily: 'OpenSans',
    fontSize: 14,
    backgroundColor: backgroundColor,
    fontWeight: FontWeight.bold,
  );

  final _textNameStyle = TextStyle(
    color: drawingColor,
    fontFamily: 'OpenSans',
    fontSize: 14,
    backgroundColor: backgroundColor,
  );

  final _speedTextStyle = TextStyle(
    color: backgroundColor,
    fontFamily: 'OpenSans',
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  late Paint _circleAreaPaint;
  late Paint _circleAreaPaintComplement;
  late Paint _speedCircleAreaPaint;
  late Paint _linePaint;
  late Paint _speedLinePaint;
  late Paint _arrowPaint;
  late TextPainter _textPainter;
  late TextPainter _speedTextPainter;
  late TextPainter _iconPainter;
  late double screenWidth;
  late double screenHeight;
  late int numberFoundDevices;
  late double _screenGridWidth;
  late double _screenGridHeight;
  late SizeModel sizes;

  DrawOverview(BuildContext context, NetworkList foundDevices, bool showSpeeds, int pivot, int hoveredDeviceIndex) {
    logger.d("[draw Overview] DrawNetworkOverview -> ");

    _providerList = Provider.of<NetworkList>(context);
    _deviceList = _providerList.getDeviceList();
    hoveredDevice = hoveredDeviceIndex;
    numberFoundDevices = _deviceList.length;
    selectedNetworkIndex = _providerList.selectedNetworkIndex;
    showingSpeeds = showSpeeds | config['show_speeds_permanent'];
    pivotDeviceIndex = pivot; // ToDo same



    sizes = context.watch<SizeModel>();

    hnCircleRadius *= sizes.icon_factor;
    //completeCircleRadius *= fontSize.factor_icon;
    hnCircleShadowRadius *= sizes.icon_factor;

    productNameTopPadding = 20 * sizes.font_factor;
    userNameTopPadding = 15;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    _screenGridWidth = (screenWidth / 5);
    _screenGridHeight = (screenHeight / 10);

    _circleAreaPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 0.0
      ..style = PaintingStyle.fill;

    _circleAreaPaintComplement = Paint()
      ..color = fontColorOnBackground
      ..strokeWidth = 0.0
      ..style = PaintingStyle.fill;

    _speedCircleAreaPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    _linePaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    _speedLinePaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    _textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..textScaleFactor = sizes.font_factor;

    _speedTextPainter = TextPainter()
      ..textDirection = TextDirection.rtl
      ..textAlign = TextAlign.left
      ..textScaleFactor = sizes.icon_factor;

    _iconPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
    ..textScaleFactor = sizes.icon_factor;

    _arrowPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

  }

  void drawDevicesNotFound(Canvas canvas, Offset offset) {
    Offset absoluteOffset = Offset(offset.dx + (screenWidth / 2), offset.dy + (screenHeight / 2));
    var textSpan;

   textSpan = TextSpan(
      text: "No devices found \nScanning for devices ...",
      style: _textStyle,
    );

    final loading = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
    ); // ToDo Progressbar maybe?

    _textPainter.text = textSpan;
    //_textPainter.text = loading as InlineSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 250);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + (hnCircleRadius + _textPainter.height) - 5));
  }

  //connection line to other Devices like PC
  void drawOtherConnection(Canvas canvas, Offset deviceOffset, Size size) {
    Offset absoluteOffset = Offset(deviceOffset.dx + (screenWidth / 2), deviceOffset.dy + (screenHeight / 2));
    Offset toOffset = Offset(deviceOffset.dx + (screenWidth / 2) + 110 , deviceOffset.dy + (screenHeight / 2));
    Offset absoluteRouterOffset = Offset(screenWidth / 2 + 100, -4.5 * _screenGridHeight + (screenHeight / 2) +18);
    var userNameTextSpan;


    if (config["internet_centered"]) {
      canvas.drawLine(absoluteOffset, toOffset.translate(-20, 0), _linePaint..strokeWidth = 2.0);
      drawIcon(canvas, toOffset, DevoloIcons.ic_laptop_24px);
      userNameTextSpan = TextSpan(
        text: S.current.thisPc,
        style: _textNameStyle.apply(),
      );

      _textPainter.text = userNameTextSpan;
      _textPainter.layout(minWidth: 0, maxWidth: 300);
      _textPainter.paint(canvas, toOffset.translate(-23, 15));

    } else {
      if(_providerList.getPivotDevice() != null) { // if there is no device attached to router don't paint line to the internet internet
        canvas.drawLine(absoluteOffset, toOffset.translate(-20, 0) , _linePaint..strokeWidth = 2.0);
        drawIcon(canvas, toOffset, DevoloIcons.devolo_UI_internet);
        userNameTextSpan = TextSpan(
          text: S.current.internet,
          style: _textNameStyle.apply(),
        );

        _textPainter.text = userNameTextSpan;
        _textPainter.layout(minWidth: 0, maxWidth: 300);
        _textPainter.paint(canvas, toOffset.translate(-23, 15));

      }else{
        canvas.drawLine(absoluteRouterOffset, absoluteRouterOffset, _linePaint..strokeWidth = 2.0);
        if(connect) {
          drawIcon(canvas, absoluteRouterOffset, DevoloIcons.devolo_UI_internet_off, 50);
        } else {
          drawIcon(canvas, absoluteRouterOffset, DevoloIcons.devolo_UI_internet, 50);
        }

        userNameTextSpan = TextSpan(
          text: "Internet",
          style: _textNameStyle.apply(),
        );
        _textPainter.text = userNameTextSpan;
        _textPainter.layout(minWidth: 0, maxWidth: 300);
        _textPainter.paint(canvas, absoluteRouterOffset.translate(-25, 35));
      }
    }
  }

  void drawDeviceConnection(Canvas canvas, Offset deviceOffset, Map color) {

    Offset absoluteOffset = Offset(deviceOffset.dx + (screenWidth / 2), deviceOffset.dy + (screenHeight / 2));
    Offset absolutePivotOffset = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2));

    double shiftFactor = 3; // how much space between lines

    Offset lineDirection = Offset(absolutePivotOffset.dx - absoluteOffset.dx, absolutePivotOffset.dy - absoluteOffset.dy);

    Offset lineDirectionOrtho = Offset(lineDirection.dy, -lineDirection.dx); // orthogonal to connection line

    if (lineDirection.dx <= 0) {
      shiftFactor = -shiftFactor;
    }

    var angle = atan2(lineDirectionOrtho.dy, lineDirectionOrtho.dx);

    Offset absoluteOffsetRx = Offset(deviceOffset.dx + (screenWidth / 2) + shiftFactor * cos(angle), deviceOffset.dy + (screenHeight / 2) + shiftFactor * sin(angle));
    Offset absolutePivotOffsetRx = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2) + shiftFactor * cos(angle), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2) + shiftFactor * sin(angle));

    Offset absoluteOffsetTx = Offset(deviceOffset.dx + (screenWidth / 2) - shiftFactor * cos(angle), deviceOffset.dy + (screenHeight / 2) - shiftFactor * sin(angle));
    Offset absolutePivotOffsetTx = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2) - shiftFactor * cos(angle), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2) - shiftFactor * sin(angle));

    drawArrow(canvas, absoluteOffsetRx, absolutePivotOffsetRx, color['rx']);
    drawArrow(canvas, absolutePivotOffsetTx, absoluteOffsetTx, color['tx']);

  }

  void drawArrow(Canvas canvas, start, end, color) {

    var dx = end.dx - start.dx;
    var dy = end.dy - start.dy;
    var distance = sqrt(pow(dx, 2) + pow(dy, 2));
    var angle = atan2(dy, dx);
    var headLength = 15; // length of head in pixels

    double paddingEnd; // padding between end of arrow and device icon circle
    double paddingStart; // padding between start of arrow and device icon circle DON`T TOUCH!!!
    var paddingConstant;
    if(sin(angle) == -1 || sin(angle) == 1){
      paddingConstant = 20;
    }
    else if((sin(angle) >= -0.5 && sin(angle) <= -0.3) || sin(angle) >= 0.3 && sin(angle) <= 0.5){
      logger.i("1");
      paddingConstant = 80;
    }
    else if((sin(angle) < -0.5 && sin(angle) >= -1) || sin(angle) > 0.5 && sin(angle) <= 1){
      logger.i("2");
      paddingConstant = 40;
    }
    else{
      logger.i("3");
      paddingConstant = 40;
    }

    if(sin(angle) < -0.3 && sin(angle) >= -1){  // Arrow to top
      paddingEnd = hnCircleRadius + getDeviceNameAndTypeHeight() + paddingConstant;
      paddingStart = hnCircleRadius + paddingConstant + headLength + 5;
    }
    else if((sin(angle) > 0.3 && sin(angle) <= 1)){ // Arrow to bottom
      paddingEnd = hnCircleRadius + paddingConstant;
      paddingStart = hnCircleRadius + getDeviceNameAndTypeHeight() + paddingConstant + headLength + 5;
    }
    else{ // arrow where the name does not collide with
      paddingEnd = hnCircleRadius + paddingConstant;
      paddingStart = hnCircleRadius + paddingConstant + headLength + 5;
    }

    if(paddingStart + paddingEnd > distance){
      paddingEnd = paddingEnd - paddingConstant + distance/16;
      paddingStart = paddingStart - paddingConstant + distance/16;
    }

    dynamic startDx = start.dx + cos(angle) * paddingStart;
    dynamic startDy = start.dy + sin(angle) * paddingStart;
    dynamic endDx = end.dx - cos(angle) * paddingEnd;
    dynamic endDy = end.dy-sin(angle) * paddingEnd;

    var path = Path();
    path.moveTo(startDx, startDy);
    path.lineTo(endDx, endDy);
    canvas.drawPath(
        path,
        _arrowPaint
          ..strokeWidth = 2.5
          ..color = color);

    path.moveTo(endDx, endDy);
    path.lineTo(endDx - headLength * cos(angle - pi / 6), endDy - headLength * sin(angle - pi / 6));
    path.moveTo(endDx, endDy);
    path.lineTo(endDx - headLength * cos(angle + pi / 6), endDy - headLength * sin(angle + pi / 6));
    canvas.drawPath(
        path,
        _arrowPaint
          ..strokeWidth = 3
          ..color = color);
  }

  // circular border
  void drawDeviceIconBorder(Canvas canvas, int deviceIndex) {
    Offset absoluteOffset = Offset(_deviceIconOffsetList.elementAt(deviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(deviceIndex).dy + (screenHeight / 2));

    if (showingSpeeds && deviceIndex != pivotDeviceIndex) {
      canvas.drawCircle(absoluteOffset, hnCircleRadius, _speedCircleAreaPaint); //the inner filling of a device circle, when showing speeds
    } else {
      canvas.drawCircle(absoluteOffset, hnCircleRadius,  _circleAreaPaint); //the inner filling of a device circle, when showing icons
    }
  }

  void drawDeviceIconContent(Canvas canvas, int deviceIndex) {
    Offset absoluteCenterOffset = Offset(_deviceIconOffsetList.elementAt(deviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(deviceIndex).dy + (screenHeight / 2));
    Offset lineStart = Offset(absoluteCenterOffset.dx - hnCircleRadius + 10, absoluteCenterOffset.dy - 5);
    Offset lineEnd = Offset(absoluteCenterOffset.dx + hnCircleRadius - 10, absoluteCenterOffset.dy - 5);

    if (showingSpeeds && deviceIndex != hoveredDevice) {
      int rx = 0,
          tx = 0;
      String speedUp = "";
      String speedDown = "";

      if (_deviceList
          .elementAt(pivotDeviceIndex)
          .speeds![_deviceList
          .elementAt(deviceIndex)
          .mac] != null) {
        rx = _deviceList
            .elementAt(pivotDeviceIndex)
            .speeds![_deviceList
            .elementAt(deviceIndex)
            .mac]!.rx;
        tx = _deviceList
            .elementAt(pivotDeviceIndex)
            .speeds![_deviceList
            .elementAt(deviceIndex)
            .mac]!.tx;
      }

      if (rx > 0)
        speedUp = rx.toString();
      else
        speedUp = "---";

      if (tx > 0)
        speedDown = tx.toString();
      else
        speedDown = "---";

      final downStreamTextSpan = TextSpan(
        text: speedUp + " " + String.fromCharCode(0x2191) + "\n" + speedDown +
            " " + String.fromCharCode(0x2193),
        style: _speedTextStyle//..fontSize = 15 * fontSize.factor,
      );
      final mbpsTextSpan = TextSpan(
        text: "Mbps",
        style: TextStyle(color: backgroundColor, fontSize: 12),
      );

      canvas.drawLine(lineStart, lineEnd, _speedLinePaint);

      _speedTextPainter.text = downStreamTextSpan;
      _speedTextPainter.layout(minWidth: 0, maxWidth: 150);
      _speedTextPainter.paint(canvas, Offset(
          absoluteCenterOffset.dx - (_speedTextPainter.width / 2),
          absoluteCenterOffset.dy - (_speedTextPainter.height / 2) - 5));

      _speedTextPainter.text = mbpsTextSpan;
      _speedTextPainter.layout(minWidth: 0, maxWidth: 150);
      _speedTextPainter.paint(canvas, Offset(
          absoluteCenterOffset.dx - (_speedTextPainter.width / 2),
          absoluteCenterOffset.dy - (_speedTextPainter.height / 2) + 20 * sizes.icon_factor));

      if (deviceIndex == pivotDeviceIndex) {
        Offset iconPosition = Offset(absoluteCenterOffset.dx, absoluteCenterOffset.dy);

        IconData circledDeviceIcon = getCircledIconForDeviceType(_deviceList.elementAt(deviceIndex).typeEnum);
        _iconPainter.text = TextSpan(text: String.fromCharCode(circledDeviceIcon.codePoint), style: TextStyle(fontSize: 70.0, fontFamily: circledDeviceIcon.fontFamily, color: drawingColor));
        _iconPainter.layout();
        _iconPainter.paint(canvas, Offset(iconPosition.dx - _iconPainter.width/2, iconPosition.dy - _iconPainter.height/2));
      }
    }else {

      if(deviceIndex == hoveredDevice){
        Offset iconPosition = Offset(absoluteCenterOffset.dx, absoluteCenterOffset.dy);

        IconData circledDeviceIcon = getFilledIconForDeviceType(_deviceList.elementAt(deviceIndex).typeEnum);
        _iconPainter.text = TextSpan(text: String.fromCharCode(circledDeviceIcon.codePoint), style: TextStyle(fontSize: 70.0, fontFamily: circledDeviceIcon.fontFamily, color: drawingColor));
        _iconPainter.layout();
        _iconPainter.paint(canvas, Offset(iconPosition.dx - _iconPainter.width/2, iconPosition.dy - _iconPainter.height/2));
      }
      else{
        Offset iconPosition = Offset(absoluteCenterOffset.dx, absoluteCenterOffset.dy);

        IconData circledDeviceIcon = getCircledIconForDeviceType(_deviceList.elementAt(deviceIndex).typeEnum);
        _iconPainter.text = TextSpan(text: String.fromCharCode(circledDeviceIcon.codePoint), style: TextStyle(fontSize: 70.0, fontFamily: circledDeviceIcon.fontFamily, color: drawingColor));
        _iconPainter.layout();
        _iconPainter.paint(canvas, Offset(iconPosition.dx - _iconPainter.width/2, iconPosition.dy - _iconPainter.height/2));
      }

    }
  }

  void drawDeviceName(Canvas canvas, String pName, String uName, Offset offset, [Size? size]) {
    Offset absoluteOffset = Offset(offset.dx + (screenWidth / 2), offset.dy + (screenHeight / 2));

    final userNameTextSpan = TextSpan(
      text: (uName.length > 0 ? uName : ""),
      style: _textStyle.apply(),
    );
    _textPainter.text = userNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + hnCircleRadius + userNameTopPadding));

    final productNameTextSpan = TextSpan(
      text: pName,
      style: _textNameStyle.apply(),
    );
    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + productNameTopPadding + hnCircleRadius + userNameTopPadding));
  }

  double getNameWidth(String pName, String uName) {

    final userNameTextSpan = TextSpan(
      text: (uName.length > 0 ? uName : ""),
      style: _textStyle.apply(),
    );

    final productNameTextSpan = TextSpan(
      text: pName,
      style: _textNameStyle.apply(),
    );

    _textPainter.text = userNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    double uNameWidth = _textPainter.width;
    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    double pNameWidth = _textPainter.width;

    return max(uNameWidth,pNameWidth);
  }

  double getDeviceNameAndTypeHeight() {

    final productNameTextSpan = TextSpan(
      text: "WAfwafwAWfwaf",
      style: _textNameStyle.apply(),
    );

    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    double pNameHeight = _textPainter.height;

    return pNameHeight + userNameTopPadding + productNameTopPadding;
  }


  void drawMainIcon(Canvas canvas, icon) {
    Offset absoluteRouterOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2));
    Offset absoluteAreaOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2) + 30);
    Offset absoluteRouterDeviceOffset = Offset(_deviceIconOffsetList.elementAt(0).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(0).dy + (screenHeight / 2));
    var internetTextSpan = TextSpan(
      text: S.current.internet,
      style: _textNameStyle.apply(),
    );

    if (_deviceList.length > 0 ) {
      if(_providerList.getPivotDevice() != null) { // if there is no device attached to router don't paint line to the internet internet
        canvas.drawLine(Offset(absoluteRouterOffset.dx, absoluteRouterOffset.dy + 50), absoluteRouterDeviceOffset, _linePaint..strokeWidth = 3.0);
      }
      if (!config["internet_centered"]) { // if view is not internet centered draw the connection line to the PC (local device)
        canvas.drawLine(Offset(absoluteRouterOffset.dx, absoluteRouterOffset.dy + 50), absoluteRouterDeviceOffset, _linePaint..strokeWidth = 3.0);
      }

    }

    if (config["internet_centered"]) {
      _textPainter.text = internetTextSpan;
      _textPainter.layout(minWidth: 0, maxWidth: 300);
      _textPainter.paint(canvas, absoluteAreaOffset.translate(35* sizes.icon_factor, -7));
    }

    canvas.drawCircle(absoluteAreaOffset, hnCircleRadius , _circleAreaPaint); //"shadow" of the device circle. covers the connection lines.

    _iconPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: 60.0, fontFamily: icon.fontFamily, color: drawingColor));
    _iconPainter.layout();
    _iconPainter.paint(canvas, Offset(absoluteRouterOffset.dx - (_iconPainter.width / 2), absoluteRouterOffset.dy));

  }

  void drawIcon(Canvas canvas, Offset offset, icon, [double? size]) {
    size??=30.0;

    _iconPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: size, fontFamily: icon.fontFamily, color: drawingColor, backgroundColor: backgroundColor));
    _iconPainter.layout();
    _iconPainter.paint(canvas, Offset(offset.dx - (_iconPainter.width / 2), offset.dy - 15));
  }

  void fillDeviceIconPositionList() {
    _deviceIconOffsetList.clear();
    _deviceIconOffsetList = getDeviceIconOffsetList(_deviceList.length);

  }

  List<Offset> getDeviceIconOffsetList(int numberDevices) {
    List<Offset> deviceIconOffsetList = [];

    deviceIconOffsetList.add(Offset(0.0, _screenGridHeight - _screenGridHeight * 3.0));

    switch (numberDevices) {
      case 2:
        {
          deviceIconOffsetList.add(Offset(0.0, 1.5 * _screenGridHeight));
        }
        break;
      case 3:
        {
          deviceIconOffsetList.add(Offset(0.7 * _screenGridWidth, 1.5 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-0.7 * _screenGridWidth, 1.5 * _screenGridHeight));
        }
        break;
      case 4:
        {
          logger.i(_screenGridHeight - _screenGridHeight * 3.0);
          logger.i(2.0 * _screenGridHeight);
          logger.i(_screenGridHeight - _screenGridHeight * 3.0 + 2.0 * _screenGridHeight);
          deviceIconOffsetList.add(Offset(1.2 * _screenGridWidth, (deviceIconOffsetList[0].dy + 2.0 * _screenGridHeight) /2));
          deviceIconOffsetList.add(Offset(0.0, 2.0 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.2 * _screenGridWidth, (deviceIconOffsetList[0].dy + 2.0 * _screenGridHeight) /2));
        }
        break;
      case 5:
        {
          deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(0.7 * _screenGridWidth, 1.8 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-0.7 * _screenGridWidth, 1.8 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -1 * _screenGridHeight));
        }
        break;
      case 6:
        {
          deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1.2 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(1.2 * _screenGridWidth, 1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.2 * _screenGridWidth, 1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1.2 * _screenGridHeight));
        }
        break;
      case 7:
        {
          deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3.2 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -0.8 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(0.7 * _screenGridWidth, 1.8 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-0.7 * _screenGridWidth, 1.8 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -0.8* _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3.2 * _screenGridHeight));
        }
        break;
      case 8:
        {
          deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3.2 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -0.8 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(0.9 * _screenGridWidth, 1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-0.9 * _screenGridWidth, 1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -0.8* _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3.2 * _screenGridHeight));
        }
        break;
      default:
        {
          //ToDo more than 8 not supported, yet
          deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(0.0, 1.5 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
          deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3 * _screenGridHeight));
        }
        break;
    }

    return deviceIconOffsetList;
  }

  void drawAllDeviceConnections(Canvas canvas, Size size) {
    //draw all device connection lines to the pivot device
    int localIndex = _deviceList.indexWhere((element) => element.isLocalDevice == true);
    int attachedToRouterIndex = _deviceList.indexWhere((element) => element.attachedToRouter == true);
    if(attachedToRouterIndex == -1) { // -1 when element is not found
      attachedToRouterIndex = 0;
    }
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device line, since it would start and end at the same place
      if (numDev != pivotDeviceIndex) {
        drawDeviceConnection(canvas, _deviceIconOffsetList.elementAt(numDev), getLineColor(numDev));
      }

      if (config["show_other_devices"]) {
        if (config["internet_centered"]) {
          drawOtherConnection(canvas, _deviceIconOffsetList.elementAt(localIndex), size);
        } else {
          drawOtherConnection(canvas, _deviceIconOffsetList.elementAt(attachedToRouterIndex), size);
        }
      }
    }
  }

  Map<String, dynamic> getLineColor(int dev) {
    // ToDo
    Map<String, Color> colors = {"rx": devoloLightGray, "tx": devoloLightGray};
    dynamic rates = _deviceList[pivotDeviceIndex].speeds![_deviceList[dev].mac];
    if (rates != null) {
      if (rates.rx > 400)
        colors['rx'] = devoloGreen;
      else if (rates.rx <= 400)
        colors['rx'] = devoloOrange;

      if (rates.tx > 400)
        colors['tx'] = devoloGreen;
      else if (rates.tx <= 400)
        colors['tx'] = devoloOrange;
    }
    return colors;
  }

  void drawAllDeviceIcons(Canvas canvas, Size size) {

    //the draw all the device names, so they are above the lines
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device name yet
      drawDeviceName(canvas, _deviceList.elementAt(numDev).type, _deviceList.elementAt(numDev).name, _deviceIconOffsetList.elementAt(numDev), size * sizes.icon_factor);
    }

    //first, draw all device circles and their lines to the pivot device
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device icon and line yet
      if (numDev != pivotDeviceIndex) {
        drawDeviceIconBorder(canvas, numDev);
        drawDeviceIconContent(canvas, numDev);
      }
    }

    //finally, draw the pivot device so it is above all line endings
    if (_deviceList.length > 0) {
      //draw the pivot device icon last to cover all the line endings
      drawDeviceIconBorder(canvas, pivotDeviceIndex);
      drawDeviceIconContent(canvas, pivotDeviceIndex);
      } else {
      drawDevicesNotFound(canvas, _deviceIconOffsetList.elementAt(0));
    }
  }

  bool isPointInsideCircle(Offset point, Offset center, double rradius) {
    var radius = rradius * 1.2;
    return point.dx < (center.dx + radius) && point.dx > (center.dx - radius) && point.dy < (center.dy + radius) && point.dy > (center.dy - radius);
  }

  @override
  void paint(Canvas canvas, Size size) {
    fillDeviceIconPositionList();

    if (config["internet_centered"]) {
      getConnection();
      connect = connected;
      if (connected) {
        drawMainIcon(canvas, DevoloIcons.devolo_UI_internet);
      } else {
        drawMainIcon(canvas, DevoloIcons.devolo_UI_internet_off);
      }
    } else
      drawMainIcon(canvas, DevoloIcons.ic_laptop_24px);

    drawAllDeviceConnections(canvas, size);
    drawAllDeviceIcons(canvas, size);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawOverview oldDelegate) {
    if (oldDelegate.numberFoundDevices != numberFoundDevices) return true;
    if (oldDelegate.showingSpeeds != showingSpeeds) return true;
    if (oldDelegate.pivotDeviceIndex != pivotDeviceIndex) return true;
    if (oldDelegate.selectedNetworkIndex != selectedNetworkIndex) return true;
    if (oldDelegate.connect != connect) return true;
    if (oldDelegate.hoveredDevice != hoveredDevice) return true;

    return false;
  }
}
