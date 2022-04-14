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
  late double deviceCircleRadius;
  late double laptopCircleRadius;
  double productNameTopPadding = 0;
  double userNameTopPadding = 0;
  late List<Device> _deviceList;
  late NetworkList _providerList;
  List<Offset> _deviceIconOffsetList = [];
  int pivotDeviceIndex = 0;
  int selectedNetworkIndex = 0;
  bool showingSpeeds = false; //true: draw the device circles with speeds as content. false: draw device circles with icons as content.
  bool connect = false;
  int selectedDevice = 999; // displays wich device index is hovered, if no device is hovered the index is set to 999
  late TextStyle _textStyle;
  late TextStyle _productTypeStyle;
  late TextStyle _dataRateTypeStyle;
  late Paint _circleAreaPaint;
  late Paint _speedCircleAreaPaint;
  late Paint _linePaint;
  late Paint _speedLinePaint;
  late Paint _arrowPaint;
  late TextPainter _textPainter;
  late TextPainter _speedTextPainter;
  late TextPainter _iconPainter;
  late double canvasWidth;
  late double canvasHeight;
  late double canvasGridWidth;
  late double canvasGridHeight;
  late int numberFoundDevices;
  late SizeModel sizes;
  late double fontSizeDeviceInfo;
  late double connectionLineWidth;
  late double screenWidth;
  late int maxDisplayedCharactersOfDevice;
  late BuildContext context;

  DrawOverview(BuildContext context, NetworkList foundDevices, int pivot, int selectedDeviceIndex) {
    logger.d("[draw Overview] DrawNetworkOverview -> ");

    _providerList = Provider.of<NetworkList>(context);
    _deviceList = _providerList.getDeviceList();
    selectedDevice = selectedDeviceIndex;
    numberFoundDevices = _deviceList.length;
    selectedNetworkIndex = _providerList.selectedNetworkIndex;
    showingSpeeds = config['show_speeds_permanent'];
    pivotDeviceIndex = pivot; // ToDo same
    this.context = context;

    sizes = context.watch<SizeModel>();

    productNameTopPadding = 20 * sizes.font_factor;
    userNameTopPadding = 15;

    screenWidth = MediaQuery.of(context).size.width;

    fontSizeDeviceInfo = 16;  //Device Name + Device Type
    maxDisplayedCharactersOfDevice = 14;

    deviceCircleRadius = 35; // Device Icon
    laptopCircleRadius = deviceCircleRadius/2;  // local Icon (PC)
    connectionLineWidth = 2.5; //dataRate Arrows
    // scale of arrowhead in arrow method itself

    _textStyle = TextStyle(
      color: drawingColor,
      fontFamily: 'OpenSans',
      fontSize: fontSizeDeviceInfo,
      backgroundColor: backgroundColor,
      fontWeight: FontWeight.bold,
    );

    _productTypeStyle = TextStyle(
      color: drawingColor,
      fontFamily: 'OpenSans',
      fontSize: fontSizeDeviceInfo,
      backgroundColor: backgroundColor,
    );

    _dataRateTypeStyle = TextStyle(
      color: drawingColor,
      fontFamily: 'OpenSans',
      fontSize: 16,
      backgroundColor: backgroundColor,
    );

    _circleAreaPaint = Paint()
      ..color = backgroundColor
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
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    _textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..textScaleFactor = sizes.font_factor;

    _speedTextPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..textScaleFactor = sizes.font_factor;

    _iconPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    _arrowPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = connectionLineWidth
      ..style = PaintingStyle.stroke;

  }

  void drawDevicesNotFound(Canvas canvas, Offset offset) {
    Offset absoluteOffset = Offset(offset.dx, offset.dy);
    var textSpan;

   textSpan = TextSpan(
      text: S.of(context).noDevicesFoundScanningForDevices,
      style: _textStyle,
    );

    _textPainter.text = textSpan;
    _textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    _textPainter.paint(canvas, Offset(canvasWidth/2 - _textPainter.width/2 , canvasHeight/2 - _textPainter.height/2));
  }

  Offset getCircularProgressIndicatorPosition(double canvasWidth, canvasHeight) {
    var textSpan;

    textSpan = TextSpan(
      text: S.of(context).noDevicesFoundScanningForDevices,
      style: _textStyle,
    );

    _textPainter.text = textSpan;
    _textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    return Offset(canvasWidth/2 + _textPainter.width/2 , canvasHeight/2 + _textPainter.height/4);
  }

  //connection to other Devices like PC
  void drawOtherConnection(Canvas canvas, Offset deviceOffset, Size size) {
    int localIndex = _deviceList.indexWhere((element) => element.isLocalDevice == true);

    Offset toOffset = getLaptopIconOffset(localIndex, _deviceIconOffsetList);

    if (localIndex == selectedDevice) {
      drawIcon(canvas, toOffset, DevoloIcons.ic_laptop_24px_circled,laptopCircleRadius*2,drawingColor, false);
    } else {
      drawIcon(canvas, toOffset, DevoloIcons.ic_laptop_24px_filled,laptopCircleRadius*2,drawingColor, false);
    }
  }

  void drawDeviceConnection(Canvas canvas, Offset deviceOffset, Map color, Map dataRates) {

    Offset absoluteOffset = deviceOffset;
    Offset absolutePivotOffset = _deviceIconOffsetList.elementAt(pivotDeviceIndex);

    double shiftFactor = 3; // how much space between lines

    Offset lineDirection = Offset(absolutePivotOffset.dx - absoluteOffset.dx, absolutePivotOffset.dy - absoluteOffset.dy);

    Offset lineDirectionOrtho = Offset(lineDirection.dy, -lineDirection.dx); // orthogonal to connection line

    var angle = atan2(lineDirectionOrtho.dy, lineDirectionOrtho.dx);

    Offset absoluteOffsetRx = Offset(deviceOffset.dx + shiftFactor * cos(angle), deviceOffset.dy + shiftFactor * sin(angle));
    Offset absolutePivotOffsetRx = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + shiftFactor * cos(angle), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + shiftFactor * sin(angle));

    Offset absoluteOffsetTx = Offset(deviceOffset.dx - shiftFactor * cos(angle), deviceOffset.dy - shiftFactor * sin(angle));
    Offset absolutePivotOffsetTx = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx - shiftFactor * cos(angle), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy - shiftFactor * sin(angle));

    /// the position of the data rates are dependent on the arrow orientation
    if(deviceOffset.dx > deviceOffset.dx + shiftFactor * cos(angle)){ // to check which of both arrows needs the data rate text on the left side
      if(deviceOffset.dy > deviceOffset.dy + shiftFactor * sin(angle)){ // to check which of both arrows needs the data rate text on the top side
        drawArrow(canvas, absoluteOffsetRx, absolutePivotOffsetRx, color['rx'],true,true, dataRates['rx']);
        drawArrow(canvas, absolutePivotOffsetTx, absoluteOffsetTx, color['tx'],false,false, dataRates['tx']);
      }
      else{
        drawArrow(canvas, absoluteOffsetRx, absolutePivotOffsetRx, color['rx'],true,false, dataRates['rx']);
        drawArrow(canvas, absolutePivotOffsetTx, absoluteOffsetTx, color['tx'],false,true, dataRates['tx']);
      }
    }
    else{
      if(deviceOffset.dy > deviceOffset.dy + shiftFactor * sin(angle)){ // to check which of both arrows needs the data rate text on the top side
        drawArrow(canvas, absoluteOffsetRx, absolutePivotOffsetRx, color['rx'],false,true, dataRates['rx']);
        drawArrow(canvas, absolutePivotOffsetTx, absoluteOffsetTx, color['tx'],true,false, dataRates['tx']);
      }
      else{
        drawArrow(canvas, absoluteOffsetRx, absolutePivotOffsetRx, color['rx'],false,false, dataRates['rx']);
        drawArrow(canvas, absolutePivotOffsetTx, absoluteOffsetTx, color['tx'],true,true, dataRates['tx']);
      }
    }


  }

  void drawDeviceConnection2(Canvas canvas, Offset deviceOffset, Map color) {

    Offset absoluteOffset = deviceOffset;
    Offset absolutePivotOffset = _deviceIconOffsetList.elementAt(pivotDeviceIndex);

    Offset lineDirection = Offset(absolutePivotOffset.dx - absoluteOffset.dx, absolutePivotOffset.dy - absoluteOffset.dy);

    Offset lineDirectionOrtho = Offset(lineDirection.dy, -lineDirection.dx); // orthogonal to connection line

    var angle = atan2(lineDirectionOrtho.dy, lineDirectionOrtho.dx);

    drawLine(canvas, absoluteOffset, absolutePivotOffset, Colors.white);

  }

  void drawLine(Canvas canvas, start, end, color) {

    var dx = end.dx - start.dx;
    var dy = end.dy - start.dy;
    var distance = sqrt(pow(dx, 2) + pow(dy, 2));
    var angle = atan2(dy, dx);

    double paddingStart;
    double paddingEnd;

    var collisionAvoidPadding;
    var standardPadding = 40;
    if(sin(angle) == -1 || sin(angle) == 1){
      collisionAvoidPadding = 20;
    }
    else if((sin(angle) >= -0.5 && sin(angle) <= -0.3) || sin(angle) >= 0.3 && sin(angle) <= 0.5){
      collisionAvoidPadding = 40;
    }
    else if((sin(angle) < -0.5 && sin(angle) >= -1) || sin(angle) > 0.5 && sin(angle) <= 1){
      collisionAvoidPadding = 40;
    }
    else{
      collisionAvoidPadding = standardPadding;
    }

    if(sin(angle) < -0.4 && sin(angle) >= -1){  // Arrow to top - As the arrow points to the top, we need no extra padding between the start of the arrow and the icon, as there will be no name collision.
      paddingStart = deviceCircleRadius + collisionAvoidPadding;
      paddingEnd= deviceCircleRadius + getDeviceNameAndTypeHeight() + collisionAvoidPadding;
    }
    else if((sin(angle) > 0.4 && sin(angle) <= 1)){ // Arrow to bottom - As the arrow points to the bottom, we need no extra padding between the arrow cross and the icon, as there will be no name collision.
      paddingStart = deviceCircleRadius + getDeviceNameAndTypeHeight() + collisionAvoidPadding;
      paddingEnd = deviceCircleRadius + collisionAvoidPadding;
    }
    else{ // arrow where the name does not collide with
      paddingStart = deviceCircleRadius + collisionAvoidPadding;
      paddingEnd= deviceCircleRadius + collisionAvoidPadding;
    }

    while(paddingStart + paddingEnd > distance){
      paddingEnd -= distance/20;
      paddingStart -= distance/20;
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
          ..color = color);
  }

  void drawArrow(Canvas canvas, start, end, color, textOnLeft, textOnTop, dataRateText) {

    var dx = end.dx - start.dx;
    var dy = end.dy - start.dy;
    var distance = sqrt(pow(dx, 2) + pow(dy, 2));
    var angle = atan2(dy, dx);
    var headLength = getScaleSize(1,8,15,screenWidth); // length of head in pixels

    double paddingEnd; // padding between end of arrow and device icon circle
    double paddingStart; // padding between start of arrow and device icon circle
    var collisionAvoidPadding;
    var standardPadding = 40;
    if(sin(angle) == -1 || sin(angle) == 1){
      collisionAvoidPadding = 20;
    }
    else if((sin(angle) >= -0.5 && sin(angle) <= -0.3) || sin(angle) >= 0.3 && sin(angle) <= 0.5){
      collisionAvoidPadding = 40;
    }
    else if((sin(angle) < -0.5 && sin(angle) >= -1) || sin(angle) > 0.5 && sin(angle) <= 1){
      collisionAvoidPadding = 40;
    }
    else{
      collisionAvoidPadding = standardPadding;
    }

    if(sin(angle) < -0.4 && sin(angle) >= -1){  // Arrow to top - As the arrow points to the top, we need no extra padding between the start of the arrow and the icon, as there will be no name collision.
      paddingEnd = deviceCircleRadius + getDeviceNameAndTypeHeight() + collisionAvoidPadding;
      paddingStart = deviceCircleRadius + standardPadding + headLength + 5;
    }
    else if((sin(angle) > 0.4 && sin(angle) <= 1)){ // Arrow to bottom - As the arrow points to the bottom, we need no extra padding between the arrow cross and the icon, as there will be no name collision.
      paddingEnd = deviceCircleRadius + standardPadding;
      paddingStart = deviceCircleRadius + getDeviceNameAndTypeHeight() + collisionAvoidPadding + headLength + 5;
    }
    else{ // arrow where the name does not collide with
      paddingEnd = deviceCircleRadius + collisionAvoidPadding;
      paddingStart = deviceCircleRadius + collisionAvoidPadding + headLength + 5;
    }

    while(paddingStart + paddingEnd > distance){
      paddingEnd -= distance/20;
      paddingStart -= distance/20;

    }

    dynamic startDx = start.dx + cos(angle) * paddingStart;
    dynamic startDy = start.dy + sin(angle) * paddingStart;
    dynamic endDx = end.dx - cos(angle) * paddingEnd;
    dynamic endDy = end.dy-sin(angle) * paddingEnd;

    var path = Path();
    path.moveTo(startDx, startDy);
    path.lineTo(endDx, endDy);

    path.moveTo(endDx, endDy);
    path.lineTo(endDx - headLength * cos(angle - pi / 6), endDy - headLength * sin(angle - pi / 6));
    path.moveTo(endDx, endDy);
    path.lineTo(endDx - headLength * cos(angle + pi / 6), endDy - headLength * sin(angle + pi / 6));
    canvas.drawPath(
        path,
        _arrowPaint
          ..color = color);

    drawDataRateText(canvas, dataRateText, angle, textOnTop, textOnLeft, startDx, endDx, startDy, endDy);
  }

  void drawDataRateText(Canvas canvas, dataRateText, double angle, bool textOnTop, bool textOnLeft, startDx, endDx, startDy, endDy) {
    var dataRatePadding = -5.0;
    double topTextPadding = 0;
    double orthogonalAngle = 0;

    final dataRateTextSpan = TextSpan(
      text: dataRateText.toString() + " Mbps",
      style: _dataRateTypeStyle.apply(),
    );

    _textPainter.text = dataRateTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);

    // calculate positive orthogonal angle
    if((angle * 180/pi <= -90 && angle * 180/pi >= -180 || angle * 180/pi >= 180 && angle * 180/pi <= 270) || (angle * 180/pi <= -180 && angle * 180/pi >= -270 || angle * 180/pi >= 90 && angle * 180/pi <= 180))
      orthogonalAngle = angle + pi / 2;
    else{
      orthogonalAngle = angle - pi / 2;
    }

    // horizontal arrow
    if(orthogonalAngle * 180/pi == 90 || orthogonalAngle * 180/pi == -90 || orthogonalAngle * 180/pi == 270 || orthogonalAngle * 180/pi == -270) {

      if(textOnTop){
        dataRatePadding = dataRatePadding - _textPainter.height;
      }
      else{
        dataRatePadding = -dataRatePadding;
      }

        _textPainter.paint(canvas, Offset(canvasWidth/2 - _textPainter.width/2, ((startDy + endDy) / 2) + dataRatePadding));
    }

    // vertical arrow
    else if(orthogonalAngle * 180/pi == 0 || orthogonalAngle * 180/pi == 180 || orthogonalAngle * 180/pi == -180) {
      dataRatePadding = -dataRatePadding;

      canvas.save();

      if(textOnLeft){
        canvas.translate(-_textPainter.width/2 - _textPainter.height/2 - dataRatePadding, -_textPainter.height/2);
      }
      else{
        canvas.translate(-_textPainter.width/2 + _textPainter.height/2 + dataRatePadding, -_textPainter.height/2);
      }

      //put padding between text and arrow
      final pivot = _textPainter.size.center( Offset(((startDx + endDx) / 2) , ((startDy + endDy) / 2) ));
      canvas.translate(pivot.dx, pivot.dy);
      //rotate text
      canvas.rotate(-90 * pi/180);
      canvas.translate(-pivot.dx, -pivot.dy);
      _textPainter.paint(canvas, Offset(((startDx + endDx) / 2) , ((startDy + endDy) / 2) ));

      canvas.restore();

      /*
      if(textOnLeft){
        _textPainter.paint(canvas, Offset(((startDx + endDx) / 2) - _textPainter.width - dataRatePadding, ((startDy + endDy) / 2) - _textPainter.height/2));
      }
      else{
        _textPainter.paint(canvas, Offset(((startDx + endDx) / 2) + 5, ((startDy + endDy) / 2) - _textPainter.height/2 ));
      }*/
    }

    // other arrows
    else{

      if(textOnTop){
        dataRatePadding = -dataRatePadding + _textPainter.height/2;
      }
      else{
        dataRatePadding = dataRatePadding - _textPainter.height/2;
      }

      canvas.save();

      if (angle * 180/pi < -90 )
        angle = angle + 180 *pi/180;
      if (angle * 180/pi > 100 )
        angle = angle + 180 *pi/180;

      //put text on center of arrow
      canvas.translate(-_textPainter.width/2, -_textPainter.height/2);
      //put padding between text and arrow
      canvas.translate(dataRatePadding * cos(orthogonalAngle), dataRatePadding * sin(orthogonalAngle));
      final pivot = _textPainter.size.center( Offset(((startDx + endDx) / 2) , ((startDy + endDy) / 2) ));
      canvas.translate(pivot.dx, pivot.dy);
      //rotate text
      canvas.rotate(angle);
      canvas.translate(-pivot.dx, -pivot.dy);
      _textPainter.paint(canvas, Offset(((startDx + endDx) / 2) , ((startDy + endDy) / 2) ));

      canvas.restore();
    }


  }

  void drawDeviceIconContent(Canvas canvas, int deviceIndex) {
    Offset absoluteCenterOffset = _deviceIconOffsetList.elementAt(deviceIndex);

    if(deviceIndex == selectedDevice){
      Offset iconPosition = Offset(absoluteCenterOffset.dx, absoluteCenterOffset.dy);

      IconData circledDeviceIcon = getFilledIconForDeviceType(_deviceList.elementAt(deviceIndex).typeEnum);
      _iconPainter.text = TextSpan(text: String.fromCharCode(circledDeviceIcon.codePoint), style: TextStyle(fontSize: deviceCircleRadius*2, fontFamily: circledDeviceIcon.fontFamily, color: drawingColor));
      _iconPainter.layout();
      _iconPainter.paint(canvas, Offset(iconPosition.dx - _iconPainter.width/2, iconPosition.dy - _iconPainter.height/2));

    }
    else{
      Offset iconPosition = Offset(absoluteCenterOffset.dx, absoluteCenterOffset.dy);

      IconData circledDeviceIcon = getCircledIconForDeviceType(_deviceList.elementAt(deviceIndex).typeEnum);
      _iconPainter.text = TextSpan(text: String.fromCharCode(circledDeviceIcon.codePoint), style: TextStyle(fontSize: deviceCircleRadius*2, fontFamily: circledDeviceIcon.fontFamily, color: drawingColor));
      _iconPainter.layout();
      _iconPainter.paint(canvas, Offset(iconPosition.dx - _iconPainter.width/2, iconPosition.dy - _iconPainter.height/2));
    }
  }

  void drawDeviceName(Canvas canvas, String pName, String uName, Offset offset, [Size? size]) {
    Offset absoluteOffset = offset;

    if(uName.length > maxDisplayedCharactersOfDevice){
      uName = uName.replaceRange(maxDisplayedCharactersOfDevice, uName.length, "...");
    }
    final userNameTextSpan = TextSpan(
      text: uName.length > 0 ? uName : "",
      style: _textStyle.apply(),
    );
    _textPainter.text = userNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + deviceCircleRadius + userNameTopPadding));

    double productNameTopPadding = _textPainter.height;

    final productNameTextSpan = TextSpan(
      text: pName,
      style: _productTypeStyle.apply(),
    );
    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + productNameTopPadding + deviceCircleRadius + userNameTopPadding));
  }

  double getNameWidth(String pName, String uName) {

    final userNameTextSpan = TextSpan(
      text: (uName.length > 0 ? uName : ""),
      style: _textStyle.apply(),
    );

    final productNameTextSpan = TextSpan(
      text: pName,
      style: _productTypeStyle.apply(),
    );

    _textPainter.text = userNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    double uNameWidth = _textPainter.width;
    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    double pNameWidth = _textPainter.width;

    return max(uNameWidth,pNameWidth);
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = "W"; //as this is one of the largest
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  double getGeneralNameWidth() {

    var userNameTextSpan = TextSpan(
      text: "",
      style: _textStyle.apply(),
    );

    TextPainter widestText = _textPainter;
    widestText.text = userNameTextSpan;

    var devices = _providerList.getDeviceList();

    for(int i = 0; i < devices.length; i++){

      var deviceName = devices[i].name;

      if(deviceName.length > maxDisplayedCharactersOfDevice){
        deviceName = deviceName.replaceRange(maxDisplayedCharactersOfDevice, deviceName.length, "...");
      }

      var userNameTextSpan = TextSpan(
        text: deviceName,
        style: _textStyle.apply(),
      );

      _textPainter.text = userNameTextSpan;
      _textPainter.layout();

      if(_textPainter.width > widestText.width){
        widestText = _textPainter;
      }

      var deviceType = devices[i].type;

      final productNameTextSpan = TextSpan(
        text: deviceType,
        style: _productTypeStyle.apply(),
      );
      _textPainter.text = productNameTextSpan;
      _textPainter.layout();

      if(_textPainter.width > widestText.width){
        widestText = _textPainter;
      }
    }

    return _textPainter.width;
  }

  double getDeviceNameHeight(String name) {

    final userNameTextSpan = TextSpan(
      text: (name.length > 0 ? name : ""),
      style: _textStyle.apply(),
    );

    _textPainter.text = userNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    return _textPainter.height;
  }

  double getDeviceNameAndTypeHeight() {

    final productNameTextSpan = TextSpan(
      text: "WAfwafwAWfwaf",
      style: _productTypeStyle.apply(),
    );

    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 300);
    double pNameHeight = _textPainter.height;

    return pNameHeight*2 + userNameTopPadding;
  }


  void drawMainIcon(Canvas canvas, icon) {

    Offset absoluteRouterOffset = Offset(0,0);
    if (_deviceIconOffsetList.length >= 5){
      absoluteRouterOffset = Offset(canvasWidth / 2, canvasGridHeight * -50 + canvasHeight/2);
    }
    else{
      absoluteRouterOffset = Offset(canvasWidth / 2, canvasGridHeight * -45 + canvasHeight/2);
    }

    Offset absoluteRouterDeviceOffset = _deviceIconOffsetList.elementAt(0);

    _iconPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: 30, fontFamily: icon.fontFamily, color: drawingColor));
    _iconPainter.layout();
    _iconPainter.paint(canvas, Offset(absoluteRouterOffset.dx - (_iconPainter.width / 2), absoluteRouterOffset.dy));

    if (_deviceList.length > 0 ) {

      var dx = absoluteRouterDeviceOffset.dx - absoluteRouterOffset.dx;
      var dy = absoluteRouterDeviceOffset.dy - absoluteRouterOffset.dy;
      var distance = sqrt(pow(dx, 2) + pow(dy, 2));

      if(_providerList.getPivotDevice() != null) { // if there is no device attached to router don't paint line to the internet internet
        canvas.drawLine(Offset(absoluteRouterOffset.dx, absoluteRouterOffset.dy + _iconPainter.height + distance/12), Offset(absoluteRouterDeviceOffset.dx, absoluteRouterDeviceOffset.dy - deviceCircleRadius - distance/12), _linePaint..strokeWidth = connectionLineWidth);
      }
    }
  }

  void drawIcon(Canvas canvas, Offset offset, icon, double size, Color color, [bool transparentBackground = true]) {

    if(transparentBackground == false){   //draws circle behind icon
      Offset offsetBackground = Offset(offset.dx + (size/2),offset.dy + (size/2));
      canvas.drawCircle(offsetBackground, (size/2),  _circleAreaPaint);
    }

    _iconPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: size, fontFamily: icon.fontFamily, color: color));
    _iconPainter.layout();
    _iconPainter.paint(canvas, Offset(offset.dx , offset.dy ));
  }

  void fillDeviceIconPositionList(Size size) {
    _deviceIconOffsetList.clear();
    _deviceIconOffsetList = getDeviceIconOffsetList(_deviceList.length, size.width, size.height);

  }

  Offset getLaptopIconOffset(int localIndex,List<Offset>deviceIconOffsetList){
    return Offset(localIndex == -1 ? 0 : deviceIconOffsetList.elementAt(localIndex).dx + deviceCircleRadius/2, localIndex == -1 ? 0 :deviceIconOffsetList.elementAt(localIndex).dy - deviceCircleRadius);
  }

  List<Offset> getDeviceIconOffsetListVariable() {
    return _deviceIconOffsetList;
  }

  double getScaleSize(double scaleFactor, double minScaleSize, double maxScaleSize, double canvasWidth){
    double canvasGridWidth = canvasWidth/100;
    double scaleSize = canvasGridWidth * scaleFactor;
    if(scaleSize < minScaleSize)
      return minScaleSize;
    else if(scaleSize > maxScaleSize)
      return maxScaleSize;
    else
      return scaleSize;
  }

  List<Offset> getDeviceIconOffsetList(int numberDevices, double canvasWidth, double canvasHeight) {
    double canvasGridWidth = canvasWidth/100;
    double canvasGridHeight = canvasHeight/100;
    List<Offset> deviceIconOffsetList = [];
    var widthPadding = 20;

    //coordinate and value explanation
    //Offset.dx = (value * canvasGridWidth) + canvasWidth/2 -> where value = [-50,50] and canvasWidth/2 moves the origin of the coordinate system to the center
    //Offset.dy = (value * canvasGridHeight) + canvasHeight/2 -> where value = [-50,50] and canvasHeight/2 moves the origin of the coordinate system to the center

    if(numberDevices == 8){
      deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, canvasGridHeight * -39 + canvasHeight/2));
    }
    else if(numberDevices >= 5)
      deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, canvasGridHeight * -35 + canvasHeight/2));
    else
      deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, canvasGridHeight * -25 + canvasHeight/2));

    switch (numberDevices) {
      case 2:
        {
          deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, canvasGridHeight * 25 + canvasHeight/2));
        }
        break;
      case 3:
        {
          if((canvasGridHeight * 25) + canvasHeight/2 + pixelToCoordinateSystem(deviceCircleRadius) + pixelToCoordinateSystem(getDeviceNameAndTypeHeight()) > canvasHeight){
            deviceIconOffsetList.add(Offset(30 * canvasGridWidth + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
            deviceIconOffsetList.add(Offset(-30 * canvasGridWidth + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
          }
          else{
            deviceIconOffsetList.add(Offset(30 * canvasGridWidth + canvasWidth/2, (canvasGridHeight * 25) + canvasHeight/2));
            deviceIconOffsetList.add(Offset(-30 * canvasGridWidth + canvasWidth/2, (canvasGridHeight * 25) + canvasHeight/2));
          }
        }
        break;
      case 4:
        {
          deviceIconOffsetList.add(Offset(35 * canvasGridWidth + canvasWidth/2, canvasGridHeight * 0 + canvasHeight/2));
          if((canvasGridHeight * 25) + canvasHeight/2 + pixelToCoordinateSystem(deviceCircleRadius) + pixelToCoordinateSystem(getDeviceNameAndTypeHeight()) > canvasHeight){
            deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
          }
          else{
            deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, canvasGridHeight * 25 + canvasHeight/2));
          }
          deviceIconOffsetList.add(Offset(-35 * canvasGridWidth + canvasWidth/2, canvasGridHeight * 0 + canvasHeight/2));
        }
        break;
      case 5:
        {
          deviceIconOffsetList.add(Offset(35 * canvasGridWidth + canvasWidth/2, -10 * canvasGridHeight + canvasHeight/2));
          if((canvasGridHeight * 30) + canvasHeight/2 + pixelToCoordinateSystem(deviceCircleRadius) + pixelToCoordinateSystem(getDeviceNameAndTypeHeight()) > canvasHeight){
            deviceIconOffsetList.add(Offset(35 * canvasGridWidth + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
            deviceIconOffsetList.add(Offset(-35 * canvasGridWidth + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));

          }
          else{
            deviceIconOffsetList.add(Offset(35 * canvasGridWidth + canvasWidth/2, 30 * canvasGridHeight + canvasHeight/2));
            deviceIconOffsetList.add(Offset(-35 * canvasGridWidth + canvasWidth/2, 30 * canvasGridHeight + canvasHeight/2));
          }
          deviceIconOffsetList.add(Offset(-35 * canvasGridWidth + canvasWidth/2, -10 * canvasGridHeight + canvasHeight/2));
        }
        break;
      case 6:
        {
          deviceIconOffsetList.add(Offset(35 * canvasGridWidth + canvasWidth/2, -10 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(35 * canvasGridWidth + canvasWidth/2, 20 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
          deviceIconOffsetList.add(Offset(-35 * canvasGridWidth + canvasWidth/2, 20 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(-35 * canvasGridWidth + canvasWidth/2, -10 * canvasGridHeight + canvasHeight/2));
        }
        break;
      case 7:
        {

          deviceIconOffsetList.add(Offset((50 * canvasGridWidth + canvasWidth/2) - pixelToCoordinateSystem(getGeneralNameWidth()/2) - widthPadding, -15 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset((50 * canvasGridWidth + canvasWidth/2) - pixelToCoordinateSystem(getGeneralNameWidth()/2) - widthPadding, 18 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(13 * canvasGridWidth + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
          deviceIconOffsetList.add(Offset(-13 * canvasGridWidth + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
          deviceIconOffsetList.add(Offset((-50 * canvasGridWidth + canvasWidth/2) + pixelToCoordinateSystem(getGeneralNameWidth()/2) + widthPadding, 18 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset((-50 * canvasGridWidth + canvasWidth/2) + pixelToCoordinateSystem(getGeneralNameWidth()/2) + widthPadding, -15 * canvasGridHeight + canvasHeight/2));

        }
        break;
      case 8:
        {
          deviceIconOffsetList.add(Offset((50 * canvasGridWidth + canvasWidth/2) - pixelToCoordinateSystem(getGeneralNameWidth()/2) - widthPadding, -20 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset((50 * canvasGridWidth + canvasWidth/2) - pixelToCoordinateSystem(getGeneralNameWidth()/2) - widthPadding, 10 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(24 * canvasGridWidth + canvasWidth/2, 30 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, (50 * canvasGridHeight + canvasHeight/2) - pixelToCoordinateSystem(deviceCircleRadius) - pixelToCoordinateSystem(getDeviceNameAndTypeHeight())));
          deviceIconOffsetList.add(Offset(-24 * canvasGridWidth + canvasWidth/2, 30 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset((-50 * canvasGridWidth + canvasWidth/2) + pixelToCoordinateSystem(getGeneralNameWidth()/2) + widthPadding, 10 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset((-50 * canvasGridWidth + canvasWidth/2) + pixelToCoordinateSystem(getGeneralNameWidth()/2) + widthPadding, -20 * canvasGridHeight + canvasHeight/2));
        }
        break;
      default:
        {
          //ToDo more than 8 not supported, yet
          deviceIconOffsetList.add(Offset(28 * canvasGridWidth + canvasWidth/2, -30 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(32 * canvasGridWidth + canvasWidth/2, -10 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(28 * canvasGridWidth + canvasWidth/2, 10 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(0.0 + canvasWidth/2, 15 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(-28 * canvasGridWidth + canvasWidth/2, 10 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(-32 * canvasGridWidth + canvasWidth/2, -10 * canvasGridHeight + canvasHeight/2));
          deviceIconOffsetList.add(Offset(-28 * canvasGridWidth + canvasWidth/2, -30 * canvasGridHeight + canvasHeight/2));
        }
        break;
    }

    return deviceIconOffsetList;
  }

  void drawAllDeviceConnections(Canvas canvas, Size size) {
    //draw all device connection lines to the pivot device
    int attachedToRouterIndex = _deviceList.indexWhere((element) => element.attachedToRouter == true);
    if(attachedToRouterIndex == -1) { // -1 when element is not found
      attachedToRouterIndex = 0;
    }
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device line, since it would start and end at the same place
      if (numDev != pivotDeviceIndex) {
        showingSpeeds ? drawDeviceConnection(canvas, _deviceIconOffsetList.elementAt(numDev), getLineColor(numDev), getDataRate(numDev)) : drawDeviceConnection2(canvas, _deviceIconOffsetList.elementAt(numDev), getLineColor(numDev));
      }

    }
  }

  double pixelToCoordinateSystem(double pixel){
    return pixel*(2/100 + 1);
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

  Map<String, dynamic> getDataRate(int dev) {
    dynamic rates = _deviceList[pivotDeviceIndex].speeds![_deviceList[dev].mac];
    return  {"rx": rates.rx, "tx": rates.tx};
  }

  void drawLocalDeviceIcon(Canvas canvas, Size size){
    int localIndex = _deviceList.indexWhere((element) => element.isLocalDevice == true);
    if (localIndex != -1 && config["show_other_devices"]) {
      drawOtherConnection(canvas, _deviceIconOffsetList.elementAt(localIndex), size);
    }
  }

  void drawAllDeviceIcons(Canvas canvas, Size size) {

    //the draw all the device names, so they are above the lines
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device name yet
      drawDeviceName(canvas, _deviceList.elementAt(numDev).type, _deviceList.elementAt(numDev).name, _deviceIconOffsetList.elementAt(numDev), size);
    }

    //first, draw all device circles and their lines to the pivot device
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device icon and line yet
      if (numDev != pivotDeviceIndex) {
        drawDeviceIconContent(canvas, numDev);
      }
    }

    //finally, draw the pivot device so it is above all line endings
    if (_deviceList.length > 0) {
      //draw the pivot device icon last to cover all the line endings
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

    canvasWidth = size.width;
    canvasHeight = size.height;

    canvasGridHeight = canvasHeight / 100;
    canvasGridWidth = canvasWidth / 100;

    fillDeviceIconPositionList(size);

    getConnection();
    connect = connected;
    if (connected) {
      drawMainIcon(canvas, DevoloIcons.devolo_UI_internet);
    } else {
      drawMainIcon(canvas, DevoloIcons.devolo_UI_internet_off);
    }

    drawAllDeviceConnections(canvas, size);
    drawAllDeviceIcons(canvas, size);
    drawLocalDeviceIcon(canvas,size);

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
    if (oldDelegate.selectedDevice != selectedDevice) return true;

    return false;
  }
}
