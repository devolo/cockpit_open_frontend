import 'dart:math';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'dart:io';
import 'dart:ui';

class DrawNetworkOverview extends CustomPainter {
  final double hn_circle_radius = 35.0;
  final double complete_circle_radius = 50.0;
  List<Device> _deviceList;
  List<Offset> _deviceIconOffsetList = deviceIconOffsetList;
  int pivotDeviceIndex = 0;
  bool showSpeedsPermanently = false; //true: a long press results in speeds being shown even after lifting the finger. false: speeds are hidden when lifting the finger.
  bool showingSpeeds = false; //true: draw the device circles with speeds as content. false: draw device circles with icons as content.
  double dashWidth = 9, dashSpace = 5, startX = 0;

  final _textStyle = TextStyle(
    color: drawingColor,
    fontFamily: 'Roboto',
    fontSize: 14,
    backgroundColor: backgroundColor,
    fontWeight: FontWeight.bold,
  );

  final _textNameStyle = TextStyle(
    color: drawingColor,
    fontFamily: 'Roboto',
    fontSize: 14,
    backgroundColor: backgroundColor,
  );

  final _speedTextStyle = TextStyle(
    color: devoloBlue,
    fontFamily: 'Roboto',
    fontSize: 15,
    //backgroundColor: Colors.white,
    fontWeight: FontWeight.bold,
  );

  Paint _deviceIconPaint;
  Paint _circleBorderPaint;
  Paint _circleAreaPaint;
  Paint _speedCircleAreaPaint;
  Paint _linePaint;
  Paint _speedLinePaint;
  Paint _pcPaint;
  Paint _routerPaint;
  Paint _arrowPaint;
  TextPainter _textPainter;
  TextPainter _speedTextPainter;
  double screenWidth;
  double screenHeight;
  int numberFoundDevices;
  double _screenGridWidth;
  double _screenGridHeight;

  DrawNetworkOverview(BuildContext context, DeviceList foundDevices, bool showSpeeds, int pivot) {
    _deviceList = Provider.of<DeviceList>(context).getDeviceList();
    print("DrawNetworkOverview: " + _deviceList.toString());
    numberFoundDevices = _deviceList.length;

    showingSpeeds = config["show_speeds"]; //ToDo fix Hack
    pivotDeviceIndex = pivot; // ToDo same

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    _screenGridWidth = (screenWidth / 5);
    _screenGridHeight = (screenHeight / 10);

    _deviceIconPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    _circleBorderPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke;

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
      ..color = devoloBlue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    _pcPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    _routerPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    _textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    _speedTextPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.left;

    _arrowPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    //..style = PaintingStyle.fill;

    //createFakeGetOverview(_numberFoundDevicesLater);
  }

  void drawNoDevices(Canvas canvas, Offset offset) {
    Offset absoluteOffset = Offset(offset.dx + (screenWidth / 2), offset.dy + (screenHeight / 2));

    final textSpan = TextSpan(
      text: "No devices found \nScanning for devices ...",
      style: _textStyle,
    );
    final loading = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(devoloBlue),
    ); // ToDo Progressbar maybe?

    _textPainter.text = textSpan;
    //_textPainter.text = loading as InlineSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 250);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + (hn_circle_radius + _textPainter.height) - 5));
  }

  void drawOtherConnection(Canvas canvas, Offset deviceOffset){ //ToDo fix internet icon attached to Router
    Offset absoluteOffset = Offset(deviceOffset.dx + (screenWidth / 2), deviceOffset.dy + (screenHeight / 2));
    Offset toOffset = Offset(deviceOffset.dx + (screenWidth / 2)+100, deviceOffset.dy + (screenHeight / 2));

    canvas.drawLine(
        absoluteOffset,
        toOffset,
        _linePaint..strokeWidth= 2.0);

    if(config["internet_centered"])
      drawIcon(canvas, toOffset, Icons.computer_rounded);
    else
      drawIcon(canvas, toOffset, Icons.public_outlined);

  }

  void drawDeviceConnection(Canvas canvas, Offset deviceOffset, Map thickness) {
    double arrowRadian = 30 / 57.295779513082; //Convert degree into radian

    Offset absoluteOffset = Offset(deviceOffset.dx + (screenWidth / 2), deviceOffset.dy + (screenHeight / 2));
    Offset absolutePivotOffset = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2));

    double lineLength = sqrt(pow(absoluteOffset.dx - absolutePivotOffset.dx, 2) + pow(absoluteOffset.dy - absolutePivotOffset.dy, 2));

    double outerCircle = (complete_circle_radius+2) / lineLength;
    double shiftFactor = (1 + (thickness["tx"] + thickness["tx"]) / 4 ) / lineLength;
    double arrowLength = 25 / lineLength;

    Offset lineDirection = Offset(absolutePivotOffset.dx - absoluteOffset.dx, absolutePivotOffset.dy - absoluteOffset.dy);
    print(lineDirection.toString());

    Offset lineDirectionOrtho = Offset(lineDirection.dy, -lineDirection.dx); // orthogonal to connection line

    if (lineDirection.dx <= 0) {
      shiftFactor = -shiftFactor;
      arrowRadian = -arrowRadian;
    }

    Offset arrowDirection = Offset(lineDirection.dx * cos(arrowRadian) - lineDirection.dy * sin(arrowRadian), lineDirection.dx * sin(arrowRadian) + lineDirection.dy * cos(arrowRadian));

    Offset absoluteOffsetRx = Offset(deviceOffset.dx + (screenWidth / 2) + shiftFactor * lineDirectionOrtho.dx, deviceOffset.dy + (screenHeight / 2) + shiftFactor * lineDirectionOrtho.dy);
    Offset absolutePivotOffsetRx = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2) + shiftFactor * lineDirectionOrtho.dx,
        _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2) + shiftFactor * lineDirectionOrtho.dy);

    Offset absoluteOffsetTx = Offset(deviceOffset.dx + (screenWidth / 2) - shiftFactor * lineDirectionOrtho.dx, deviceOffset.dy + (screenHeight / 2) - shiftFactor * lineDirectionOrtho.dy);
    Offset absolutePivotOffsetTx = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2) - shiftFactor * lineDirectionOrtho.dx,
        _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2) - shiftFactor * lineDirectionOrtho.dy);

    Offset absoluteOffsetArrowStartRx = Offset(absolutePivotOffsetRx.dx - outerCircle * lineDirection.dx, absolutePivotOffsetRx.dy - outerCircle * lineDirection.dy);
    Offset absoluteOffsetArrowEndRx;

    Offset absoluteOffsetArrowStartTx = Offset(absoluteOffsetTx.dx + outerCircle * lineDirection.dx, absoluteOffsetTx.dy + outerCircle * lineDirection.dy);
    Offset absoluteOffsetArrowEndTx;

    if (lineDirection.dx > 0) {
      absoluteOffsetArrowEndRx = Offset(absoluteOffsetArrowStartRx.dx - arrowLength * arrowDirection.dx, absoluteOffsetArrowStartRx.dy - arrowLength * arrowDirection.dy);
      absoluteOffsetArrowEndTx = Offset(absoluteOffsetArrowStartTx.dx + arrowLength * arrowDirection.dx, absoluteOffsetArrowStartTx.dy + arrowLength * arrowDirection.dy);
    } else {
      absoluteOffsetArrowEndRx = Offset(absoluteOffsetArrowStartRx.dx - arrowLength * arrowDirection.dx, absoluteOffsetArrowStartRx.dy - arrowLength * arrowDirection.dy);
      absoluteOffsetArrowEndTx = Offset(absoluteOffsetArrowStartTx.dx + arrowLength * arrowDirection.dx, absoluteOffsetArrowStartTx.dy + arrowLength * arrowDirection.dy);
    }

    // intersection between 2 vectors, see: https://de.wikipedia.org/wiki/Schnittpunkt
    Offset p1 = absoluteOffsetArrowEndRx;
    Offset p2 = Offset(absoluteOffsetArrowEndRx.dx + 1 * lineDirectionOrtho.dx, absoluteOffsetArrowEndRx.dy + 1 * lineDirectionOrtho.dy);
    Offset p3 = absoluteOffsetRx;
    Offset p4 = Offset(absoluteOffsetRx.dx + 1 * lineDirection.dx, absoluteOffsetRx.dy + 1 * lineDirection.dy);

    double arrowCossLineX =
        ((p4.dx - p3.dx) * (p2.dx * p1.dy - p1.dx * p2.dy) - (p2.dx - p1.dx) * (p4.dx * p3.dy - p3.dx * p4.dy)) / ((p4.dy - p3.dy) * (p2.dx - p1.dx) - (p2.dy - p1.dy) * (p4.dx - p3.dx));
    double arrowCossLineY =
        ((p1.dy - p2.dy) * (p4.dx * p3.dy - p3.dx * p4.dy) - (p3.dy - p4.dy) * (p2.dx * p1.dy - p1.dx * p2.dy)) / ((p4.dy - p3.dy) * (p2.dx - p1.dx) - (p2.dy - p1.dy) * (p4.dx - p3.dx));

    Offset arrowCrossLineRx = Offset(arrowCossLineX, arrowCossLineY);

    p1 = absoluteOffsetArrowEndTx;
    p2 = Offset(absoluteOffsetArrowEndTx.dx + 1 * lineDirectionOrtho.dx, absoluteOffsetArrowEndTx.dy + 1 * lineDirectionOrtho.dy);
    p3 = absoluteOffsetTx;
    p4 = Offset(absoluteOffsetTx.dx + 1 * lineDirection.dx, absoluteOffsetTx.dy + 1 * lineDirection.dy);

    arrowCossLineX = ((p4.dx - p3.dx) * (p2.dx * p1.dy - p1.dx * p2.dy) - (p2.dx - p1.dx) * (p4.dx * p3.dy - p3.dx * p4.dy)) / ((p4.dy - p3.dy) * (p2.dx - p1.dx) - (p2.dy - p1.dy) * (p4.dx - p3.dx));
    arrowCossLineY = ((p1.dy - p2.dy) * (p4.dx * p3.dy - p3.dx * p4.dy) - (p3.dy - p4.dy) * (p2.dx * p1.dy - p1.dx * p2.dy)) / ((p4.dy - p3.dy) * (p2.dx - p1.dx) - (p2.dy - p1.dy) * (p4.dx - p3.dx));

    Offset arrowCrossLineTx = Offset(arrowCossLineX, arrowCossLineY);

    if (thickness['rx'] < 1.0) {
      canvas.drawLine(
          absolutePivotOffsetRx,
          absoluteOffsetRx,
          _linePaint
            ..colorFilter = ColorFilter.mode(Colors.blueGrey[200], BlendMode.color)
            ..strokeWidth = thickness['rx']);
    }
    if (thickness['tx'] < 1.0) {
      canvas.drawLine(
          absolutePivotOffsetTx,
          absoluteOffsetTx,
          _linePaint
            ..colorFilter = ColorFilter.mode(Colors.blueGrey[200], BlendMode.color)
            ..strokeWidth = thickness['tx']);
    } else {
      canvas.drawLine(
          absoluteOffsetArrowStartRx,
          absoluteOffsetRx,
          _linePaint..strokeWidth = thickness['rx']); // Draw Connection Line
      //canvas.drawLine(absoluteOffsetArrowEndRx, arrowCrossLineRx, _linePaint..colorFilter= ColorFilter.mode(devoloBlue, BlendMode.color)..strokeWidth=thickness['rx']); // Draw Arrow cross Line
      canvas.drawLine(absoluteOffsetArrowStartRx, absoluteOffsetArrowEndRx, _linePaint..colorFilter= ColorFilter.mode(devoloBlue, BlendMode.color)..strokeWidth=thickness['rx']); // Draw Arrow
      //paintTriangle(canvas, absoluteOffsetArrowStartRx, absoluteOffsetArrowEndRx, arrowCrossLineRx, thickness['rx']);

      canvas.drawLine(
          absolutePivotOffsetTx,
          absoluteOffsetArrowStartTx,
          _linePaint..strokeWidth = thickness['tx']); // Draw Connection Line
      //canvas.drawLine(absoluteOffsetArrowEndTx, arrowCrossLineTx, _linePaint..colorFilter= ColorFilter.mode(devoloBlue, BlendMode.color)..strokeWidth=thickness['tx']); // Draw Arrow cross Line
      canvas.drawLine(absoluteOffsetArrowStartTx, absoluteOffsetArrowEndTx, _linePaint..colorFilter= ColorFilter.mode(devoloBlue, BlendMode.color)..strokeWidth=thickness['tx']); // Draw Arrow
      //paintTriangle(canvas, absoluteOffsetArrowStartTx, absoluteOffsetArrowEndTx, arrowCrossLineTx, thickness['tx']);
    }

    // if(showingSpeeds == true)
    //   canvas.drawLine(absolutePivotOffset, absoluteOffset, _linePaint..colorFilter= ColorFilter.mode(Colors.green, BlendMode.color)..strokeWidth= 2.0);
  }

  void paintTriangle(Canvas canvas, start, middle, end, thickness) {
    var path = Path();

    path.moveTo(start.dx, start.dy);
    path.lineTo(middle.dx, middle.dy);
    path.lineTo(end.dx, end.dy);
    path.close();

    canvas.drawPath(path, _arrowPaint..strokeWidth = thickness);
  }

  void drawDottedConnection(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0;
    final _dottedPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), _dottedPaint);
      startX += dashWidth + dashSpace;
    }
  }

  void drawDeviceIconEmpty(Canvas canvas, int deviceIndex) {
    Offset absoluteOffset = Offset(_deviceIconOffsetList.elementAt(deviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(deviceIndex).dy + (screenHeight / 2));
    Offset absolutePivotOffset = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2));

    canvas.drawCircle(absoluteOffset, hn_circle_radius + 15, _circleAreaPaint); //"shadow" of the device circle. covers the connection lines.
    canvas.drawCircle(absoluteOffset, hn_circle_radius, _circleBorderPaint); //the actual circle for a device

    if (showingSpeeds && deviceIndex != pivotDeviceIndex) {
      canvas.drawCircle(absoluteOffset, hn_circle_radius, _speedCircleAreaPaint); //the inner filling of a device circle, when showing speeds
    } else {
      canvas.drawCircle(absoluteOffset, hn_circle_radius, _circleAreaPaint); //the inner filling of a device circle, when showing icons
    }
  }

  void drawDeviceIconContent(Canvas canvas, int deviceIndex) {
    Offset absoluteCenterOffset = Offset(_deviceIconOffsetList.elementAt(deviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(deviceIndex).dy + (screenHeight / 2));
    Offset lineStart = Offset(absoluteCenterOffset.dx - hn_circle_radius + 10, absoluteCenterOffset.dy -5);
    Offset lineEnd = Offset(absoluteCenterOffset.dx + hn_circle_radius - 10, absoluteCenterOffset.dy-5);
    print('Index: ' + deviceIndex.toString());
    print('Pivot :' + pivotDeviceIndex.toString());
    print('showingSpeeds: ' + showingSpeeds.toString());

    if (showingSpeeds && deviceIndex != pivotDeviceIndex) {
      int rx = 0, tx = 0;
      String speedUp = "";
      String speedDown = "";

      print("speeds for " + _deviceList.elementAt(deviceIndex).mac + ": ");
      if (_deviceList.elementAt(pivotDeviceIndex).speeds[_deviceList.elementAt(deviceIndex).mac] != null) {
        rx = _deviceList.elementAt(pivotDeviceIndex).speeds[_deviceList.elementAt(deviceIndex).mac].rx;
        tx = _deviceList.elementAt(pivotDeviceIndex).speeds[_deviceList.elementAt(deviceIndex).mac].tx;
      }
      print(rx.toString() + '  ' + tx.toString());

      if (rx > 0)
        speedUp = rx.toString();
      else
        speedUp = "---";

      if (tx > 0)
        speedDown = tx.toString();
      else
        speedDown = "---";

      print(speedUp);
      print(speedDown);

      final downStreamTextSpan = TextSpan(
        text: String.fromCharCode(0x2191) + " " + speedUp + "\n" + String.fromCharCode(0x2193) + " " + speedDown,
        style: _speedTextStyle,
      );
      final mbpsTextSpan = TextSpan(
        text: "Mbps",
        style: TextStyle(color: devoloBlue, fontSize: 12),
      );
      canvas.drawLine(lineStart, lineEnd, _speedLinePaint);

      _speedTextPainter.text = downStreamTextSpan;
      _speedTextPainter.layout(minWidth: 0, maxWidth: 150);
      _speedTextPainter.paint(canvas, Offset(absoluteCenterOffset.dx - (_speedTextPainter.width / 2), absoluteCenterOffset.dy - (_speedTextPainter.height / 2) -5));

      _speedTextPainter.text = mbpsTextSpan;
      _speedTextPainter.layout(minWidth: 0, maxWidth: 150);
      _speedTextPainter.paint(canvas, Offset(absoluteCenterOffset.dx - (_speedTextPainter.width / 2), absoluteCenterOffset.dy - (_speedTextPainter.height / 2) +20));
    } else {
      Offset imageRectUpperLeft = Offset(absoluteCenterOffset.dx - (hn_circle_radius / 1.6), absoluteCenterOffset.dy - (hn_circle_radius / 1.6));
      Offset imageRectLowerRight = Offset(absoluteCenterOffset.dx + (hn_circle_radius / 1.6), absoluteCenterOffset.dy + (hn_circle_radius / 1.6));

      //canvas.drawImage(deviceIconList.elementAt(0), imageOffset, _deviceIconPaint);
      if (areDeviceIconsLoaded && _deviceList.elementAt(deviceIndex).icon != null) {
        paintImage(
            canvas: canvas,
            image: _deviceList.elementAt(deviceIndex).icon, //deviceIconList[0],
            fit: BoxFit.scaleDown,
            rect: Rect.fromPoints(imageRectUpperLeft, imageRectLowerRight));
      }
    }
  }

  void drawDeviceName(Canvas canvas, Size size, String pName, String uName, Offset offset) {
    Offset absoluteOffset = Offset(offset.dx + (screenWidth / 2), offset.dy + (screenHeight / 2));

    final userNameTextSpan = TextSpan(
      text: (uName.length > 0 ? uName  : ""),
      style: _textStyle,
    );

    _textPainter.text = userNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 150);

    double userNameHeight = _textPainter.height;

    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + hn_circle_radius + userNameHeight ));

    final productNameTextSpan = TextSpan(
      text: pName,
      style: _textNameStyle,
    );

    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 150);

    double productNameHeight = _textPainter.height;

    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + hn_circle_radius + productNameHeight + userNameHeight));
  }

  void drawPCIcon(Canvas canvas, Size size) {
    Offset absolutePCOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2));
    Offset absolutePCDeviceOffset = Offset(_deviceIconOffsetList.elementAt(0).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(0).dy + (screenHeight / 2));

    final textSpan = TextSpan(
      text: "Your PC",
      style: _textStyle,
    );

    Rect pcRect = new Rect.fromPoints(Offset(absolutePCOffset.dx - 20, absolutePCOffset.dy - 15), Offset(absolutePCOffset.dx + 20, absolutePCOffset.dy + 15));
    canvas.drawRect(pcRect, _pcPaint);

    pcRect = new Rect.fromPoints(Offset(absolutePCOffset.dx - 30, absolutePCOffset.dy + 16), Offset(absolutePCOffset.dx + 30, absolutePCOffset.dy + 30));
    canvas.drawRect(pcRect, _pcPaint);

    if (_deviceList.length > 0) canvas.drawLine(Offset(absolutePCOffset.dx, absolutePCOffset.dy + 60), absolutePCDeviceOffset, _linePaint);

    _textPainter.text = textSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 250);

    _textPainter.paint(canvas, Offset(absolutePCOffset.dx - (_textPainter.width / 2), absolutePCOffset.dy + (20 + _textPainter.height)));
  }

  void drawRouterIcon(Canvas canvas, Size size) {
    Offset absoluteRouterOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2));
    Offset absoluteRouterDeviceOffset = Offset(_deviceIconOffsetList.elementAt(0).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(0).dy + (screenHeight / 2));

    final textSpan = TextSpan(
      text: "Internet Access Device",
      style: _textStyle,
    );

    Rect routerRect = new Rect.fromPoints(Offset(absoluteRouterOffset.dx - 30, absoluteRouterOffset.dy - 15), Offset(absoluteRouterOffset.dx + 30, absoluteRouterOffset.dy + 15));
    canvas.drawRect(routerRect, _routerPaint);

    if (_deviceList.length > 0) canvas.drawLine(Offset(absoluteRouterOffset.dx, absoluteRouterOffset.dy + 50), absoluteRouterDeviceOffset, _linePaint);

    _textPainter.text = textSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 250);
    _textPainter.paint(canvas, Offset(absoluteRouterOffset.dx - (_textPainter.width / 2), absoluteRouterOffset.dy + (10 + _textPainter.height)));
  }

  void drawMainIcon(Canvas canvas, icon) {
    Offset absoluteRouterOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2));
    Offset absoluteAreaOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2)+25);
    Offset absoluteRouterDeviceOffset = Offset(_deviceIconOffsetList.elementAt(0).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(0).dy + (screenHeight / 2));

    if (_deviceList.length > 0) canvas.drawLine(Offset(absoluteRouterOffset.dx, absoluteRouterOffset.dy + 50), absoluteRouterDeviceOffset, _linePaint..strokeWidth=3.0);

    canvas.drawCircle(absoluteAreaOffset, hn_circle_radius + 5, _circleAreaPaint); //"shadow" of the device circle. covers the connection lines.

    _textPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: 70.0, fontFamily: icon.fontFamily, color: drawingColor));
    _textPainter.layout();
    _textPainter.paint(canvas, Offset(absoluteRouterOffset.dx - (_textPainter.width / 2), absoluteRouterOffset.dy - 10));


  }

  void drawIcon(Canvas canvas, offset, icon){

    canvas.drawCircle(offset, hn_circle_radius-10, _circleAreaPaint);

    _textPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: 30.0, fontFamily: icon.fontFamily, color: drawingColor,backgroundColor: backgroundColor));
    _textPainter.layout();
    _textPainter.paint(canvas, Offset(offset.dx - (_textPainter.width / 2), offset.dy - 15));
  }

  void fillDeviceIconPositionList() {
    _deviceIconOffsetList.clear();
    _deviceIconOffsetList.add(Offset(0.0, -2.5 * _screenGridHeight));

    switch (_deviceList.length) {
      case 2:
        {
          _deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));
        }
        break;
      case 3:
        {
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
        }
        break;
      case 4:
        {
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
        }
        break;
      case 5:
        {
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
        }
        break;
      case 6:
        {
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
        }
        break;
      case 7:
        {
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3 * _screenGridHeight));
        }
        break;
      case 8:
        {
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3 * _screenGridHeight));
        }
        break;
      default:
        {
          //ToDo more than 8 not supported, yet
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3 * _screenGridHeight));
        }
        break;
    }
  }

  void drawAllDeviceConnections(Canvas canvas, Size size) {
    //draw all device connection lines to the pivot device
    int localIndex =_deviceList.indexWhere((element) => element.isLocalDevice == true);
    int attachedToRouter = _deviceList.indexWhere((element) => element.attachedToRouter == true);
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device line, since it would start and end at the same place
      if (numDev != pivotDeviceIndex) {
        drawDeviceConnection(canvas, _deviceIconOffsetList.elementAt(numDev), getLineThickness(numDev));
      }

      if(config["show_other_devices"]){
        if(config["internet_centered"]){
          drawOtherConnection(canvas, _deviceIconOffsetList.elementAt(localIndex)); //To Do get Local
        }else{
          drawOtherConnection(canvas, _deviceIconOffsetList.elementAt(attachedToRouter));
        }

      }
    }
  }

  Color getLineColor(int dev) {
    // ToDo
    dynamic color = _deviceList[pivotDeviceIndex].speeds[_deviceList[dev].mac];
    if (color != null) {
      color = color.rx * 0.01;
      print('COLOR' + color.toString());
    }
    return color;
  }

  Map<String, double> getLineThickness(int dev) {
    Map thickness = Map<String, double>();
    dynamic rates = _deviceList[pivotDeviceIndex].speeds[_deviceList[dev].mac];
    if (rates != null) {
      if (rates.rx * 0.01 > 7.0) //
        thickness['rx'] = 7.0;
      else
        thickness['rx'] = rates.rx * 0.01.toDouble();

      if (rates.tx * 0.01 > 7.0)
        thickness['tx'] = 7.0;
      else
        thickness['tx'] = rates.tx * 0.01;
      //print('THIIICKNESSS ' + dev.toString() + " " + thickness.toString());
      return thickness;
    }
    else {
      thickness['rx'] = 0.3;
      thickness['tx'] = 0.3;
      return thickness;
    }
  }

  void drawAllDeviceIcons(Canvas canvas, Size size) {
    //first, draw all device circles and their lines to the pivot device
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device icon and line yet
      if (numDev != pivotDeviceIndex) {
        drawDeviceIconEmpty(canvas, numDev);
        drawDeviceIconContent(canvas, numDev);
      }
    }

    //the draw all the device names, so they are above the lines
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device name yet
      if (numDev != pivotDeviceIndex) drawDeviceName(canvas, size, _deviceList.elementAt(numDev).type, _deviceList.elementAt(numDev).name, _deviceIconOffsetList.elementAt(numDev));
    }

    //finally, draw the pivot device so it is above all line endings
    if (_deviceList.length > 0) {
      //draw the pivot device icon last to cover all the line endings (yes, quick and dirty, but it does the job)
      drawDeviceIconEmpty(canvas, pivotDeviceIndex);
      drawDeviceIconContent(canvas, pivotDeviceIndex);
      drawDeviceName(canvas, size, _deviceList.elementAt(pivotDeviceIndex).type, _deviceList.elementAt(pivotDeviceIndex).name, _deviceIconOffsetList.elementAt(pivotDeviceIndex));
    } else {
      drawNoDevices(canvas, _deviceIconOffsetList.elementAt(0));
    }
  }

  bool isPointInsideCircle(Offset point, Offset center, double rradius) {
    var radius = rradius * 1.2;
    return point.dx < (center.dx + radius) && point.dx > (center.dx - radius) && point.dy < (center.dy + radius) && point.dy > (center.dy - radius);
  }

  @override
  void paint(Canvas canvas, Size size) {
    fillDeviceIconPositionList();

    if (Platform.isAndroid || Platform.isIOS)
      drawMainIcon(canvas, Icons.router_outlined);
    else if(config["internet_centered"])
      drawMainIcon(canvas, Icons.public_outlined);
    else
      drawMainIcon(canvas, Icons.computer);
    //drawPCIcon(canvas, size);
    //drawRouterIcon(canvas, size);

    drawAllDeviceConnections(canvas, size);
    drawAllDeviceIcons(canvas, size);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawNetworkOverview oldDelegate) {
    if (oldDelegate.numberFoundDevices != numberFoundDevices) return true;
    if (oldDelegate.showingSpeeds != showingSpeeds) return true;

    return false;

    return oldDelegate.numberFoundDevices != numberFoundDevices;
  }
}
