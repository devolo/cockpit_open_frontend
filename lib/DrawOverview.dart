import 'package:flutter/material.dart';
import 'deviceClass.dart';
import 'helpers.dart';
import 'dart:io';

class DrawNetworkOverview extends CustomPainter {
  final double hn_circle_radius = 35.0;
  List<Device> _deviceList = new List();
  List<Offset> _deviceIconOffsetList = deviceIconOffsetList;
  bool areDeviceIconsLoaded = false;
  int pivotDeviceIndex = 0;
  bool showSpeedsPermanently = false; //true: a long press results in speeds being shown even after lifting the finger. false: speeds are hidden when lifting the finger.
  bool showingSpeeds = false; //true: draw the device circles with speeds as content. false: draw device circles with icons as content.

  final _textStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Roboto',
    fontSize: 14,
    //backgroundColor: Colors.blue,
  );

  //TODO not implemented yet
  final _speedTextStyle = TextStyle(
    color: Colors.blue,
    fontFamily: 'Roboto',
    fontSize: 14,
    backgroundColor: Colors.white,
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
  TextPainter _textPainter;
  TextPainter _speedTextPainter;
  double screenWidth;
  double screenHeight;
  int numberFoundDevices;
  double _screenGridWidth;
  double _screenGridHeight;

  DrawNetworkOverview(BuildContext context, List<Device> foundDevices) {
    _deviceList = foundDevices;
    numberFoundDevices = _deviceList.length;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    _screenGridWidth = (screenWidth / 5);
    _screenGridHeight = (screenHeight / 10);

    _deviceIconPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    _circleBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke;

    _circleAreaPaint = Paint()
      ..color = devoloBlue
      ..strokeWidth = 0.0
      ..style = PaintingStyle.fill;

    _speedCircleAreaPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    _linePaint = Paint()
      ..color = devoloBlue
      ..strokeWidth = getLineThikness()
      ..style = PaintingStyle.stroke;

    _speedLinePaint = Paint()
      ..color = devoloBlue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    _pcPaint = Paint()
      ..color = devoloBlue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    _routerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    _textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    _speedTextPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.left;

    //createFakeGetOverview(_numberFoundDevicesLater);
  }

  void drawNoDevices(Canvas canvas, Offset offset) {
    Offset absoluteOffset = Offset(offset.dx + (screenWidth / 2), offset.dy + (screenHeight / 2));

    final textSpan = TextSpan(
      text: "No devices found \nScanning for devices ...",
      style: _textStyle,
    );
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    ); // ToDo Progressbar maybe?

    _textPainter.text = textSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 250);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + (hn_circle_radius + _textPainter.height) - 5));
  }

  void drawDeviceConnection(Canvas canvas, Offset deviceOffset) {
    Offset absoluteOffset = Offset(deviceOffset.dx + (screenWidth / 2), deviceOffset.dy + (screenHeight / 2));
    Offset absolutePivotOffset = Offset(_deviceIconOffsetList.elementAt(pivotDeviceIndex).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(pivotDeviceIndex).dy + (screenHeight / 2));

    canvas.drawLine(absolutePivotOffset, absoluteOffset, _linePaint);
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
    Offset lineStart = Offset(absoluteCenterOffset.dx - hn_circle_radius + 10, absoluteCenterOffset.dy);
    Offset lineEnd = Offset(absoluteCenterOffset.dx + hn_circle_radius - 10, absoluteCenterOffset.dy);
    print('Index: ' + deviceIndex.toString());
    print('Pivot :' + pivotDeviceIndex.toString());
    print(showingSpeeds);

    if (showingSpeeds && deviceIndex != pivotDeviceIndex) {
      int rx = 0, tx = 0;
      String speedUp = "";
      String speedDown = "";

      print("speeds for " + _deviceList.elementAt(deviceIndex).mac + ": ");

      if (_deviceList.elementAt(pivotDeviceIndex).speeds[_deviceList.elementAt(deviceIndex).mac] != null) {
        rx = _deviceList.elementAt(pivotDeviceIndex).speeds[_deviceList.elementAt(deviceIndex).mac].rx;
        tx = _deviceList.elementAt(pivotDeviceIndex).speeds[_deviceList.elementAt(deviceIndex).mac].tx;
      }
      print(rx.toString() +'  '+ tx.toString());

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
        text: String.fromCharCode(0x2191) + " " + speedUp + "\n\n" + String.fromCharCode(0x2193) + " " + speedDown,
        style: _speedTextStyle,
      );
      canvas.drawLine(lineStart, lineEnd, _speedLinePaint);

      _speedTextPainter.text = downStreamTextSpan;
      _speedTextPainter.layout(minWidth: 0, maxWidth: 150);

      _speedTextPainter.paint(canvas, Offset(absoluteCenterOffset.dx - (_speedTextPainter.width / 2), absoluteCenterOffset.dy - (_speedTextPainter.height / 2)));
    }
    else {
      Offset imageRectUpperLeft = Offset(absoluteCenterOffset.dx - (hn_circle_radius / 1.6), absoluteCenterOffset.dy - (hn_circle_radius / 1.6));
      Offset imageRectLowerRight = Offset(absoluteCenterOffset.dx + (hn_circle_radius / 1.6), absoluteCenterOffset.dy + (hn_circle_radius / 1.6));

      //canvas.drawImage(deviceIconList.elementAt(0), imageOffset, _deviceIconPaint);
      paintImage(
          canvas: canvas,
          image: _deviceList.elementAt(deviceIndex).icon, //deviceIconList[0],
          fit: BoxFit.scaleDown,
          rect: Rect.fromPoints(imageRectUpperLeft, imageRectLowerRight));
    }
  }

  void drawDeviceName(Canvas canvas, Size size, String pName, String uName, Offset offset) {
    Offset absoluteOffset = Offset(offset.dx + (screenWidth / 2), offset.dy + (screenHeight / 2));

    final productNameTextSpan = TextSpan(
      text: pName,
      style: _textStyle,
    );

    _textPainter.text = productNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 150);

    double productNameHeight = _textPainter.height;

    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + hn_circle_radius + productNameHeight - 5));

    final userNameTextSpan = TextSpan(
      text: (uName.length > 0 ? "(" + uName + ")" : ""),
      style: _textStyle,
    );

    _textPainter.text = userNameTextSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 150);

    double userNameHeight = _textPainter.height;

    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + hn_circle_radius + productNameHeight + userNameHeight - 5));
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
    for (int numDev = 0; numDev < _deviceList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

      //do not draw pivot device line, since it would start and end at the same place
      if (numDev != pivotDeviceIndex) drawDeviceConnection(canvas, _deviceIconOffsetList.elementAt(numDev));
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
      drawRouterIcon(canvas, size);
    else
      drawPCIcon(canvas, size);

    drawAllDeviceConnections(canvas, size);
    drawAllDeviceIcons(canvas, size);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawNetworkOverview oldDelegate) {
    return oldDelegate.numberFoundDevices != numberFoundDevices;
  }
}
