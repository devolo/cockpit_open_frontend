import 'dart:math';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'dart:io';
import 'dart:ui';

class DrawNetworksOverview extends CustomPainter {
  final double hn_circle_radius = 35.0;
  final double complete_circle_radius = 50.0;
  var _networkList;//List<Device> _deviceList;
  List<Offset> _deviceIconOffsetList = deviceIconOffsetList;
  int pivotDeviceIndex = 0;
  bool showSpeedsPermanently = false; //true: a long press results in speeds being shown even after lifting the finger. false: speeds are hidden when lifting the finger.
  bool showingSpeeds = false; //true: draw the device circles with speeds as content. false: draw device circles with icons as content.

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

  Paint _deviceIconPaint;
  Paint _circleBorderPaint;
  Paint _circleAreaPaint;
  Paint _speedCircleAreaPaint;
  Paint _linePaint;
  TextPainter _textPainter;
  double screenWidth;
  double screenHeight;
  int numberFoundDevices;
  double _screenGridWidth;
  double _screenGridHeight;

  DrawNetworksOverview(BuildContext context, NetworkList foundDevices, bool showSpeeds, int pivot) {
    _networkList = Provider.of<NetworkList>(context).getNetworkList();
    print("DrawOverview: " + _networkList.toString());
    numberFoundDevices = _networkList.length;
    

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    _screenGridWidth = (screenWidth / 5);
    _screenGridHeight = (screenHeight / 10);

    _deviceIconPaint = Paint()
      ..color = drawingColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    _circleBorderPaint = Paint()
      ..color = backgroundColor
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

    _textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;
    

    //createFakeGetOverview(_numberFoundDevicesLater);
  }

  void drawNoDevices(Canvas canvas, Offset offset) {
    Offset absoluteOffset = Offset(offset.dx + (screenWidth / 2), offset.dy + (screenHeight / 2));

    final textSpan = TextSpan(
      text: "No devices found \nScanning for devices ...",
      style: _textStyle,
    );
    final loading = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
    ); // ToDo Progressbar maybe?

    _textPainter.text = textSpan;
    //_textPainter.text = loading as InlineSpan;
    _textPainter.layout(minWidth: 0, maxWidth: 250);
    _textPainter.paint(canvas, Offset(absoluteOffset.dx - (_textPainter.width / 2), absoluteOffset.dy + (hn_circle_radius + _textPainter.height) - 5));
  }

  void drawDeviceConnection(Canvas canvas, Offset deviceOffset) {
    Offset absoluteOffset = Offset(deviceOffset.dx + (screenWidth / 2), deviceOffset.dy + (screenHeight / 2));
    Offset absoluteRouterOffset = Offset(screenWidth / 2, -4 * _screenGridHeight + (screenHeight / 2));

    canvas.drawLine(absoluteRouterOffset, absoluteOffset, _linePaint);
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

    Offset imageRectUpperLeft = Offset(absoluteCenterOffset.dx - (hn_circle_radius / 1.6), absoluteCenterOffset.dy - (hn_circle_radius / 1.6));
    Offset imageRectLowerRight = Offset(absoluteCenterOffset.dx + (hn_circle_radius / 1.6), absoluteCenterOffset.dy + (hn_circle_radius / 1.6));

      //canvas.drawImage(deviceIconList.elementAt(0), imageOffset, _deviceIconPaint);
      if (areDeviceIconsLoaded && _networkList != null) {
        paintImage(
            canvas: canvas,
            image: deviceIconList[deviceIconList.length-1],
            fit: BoxFit.scaleDown,
            rect: Rect.fromPoints(imageRectUpperLeft, imageRectLowerRight));
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

  void drawMainIcon(Canvas canvas, icon) {
    Offset absoluteRouterOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2));
    Offset absoluteAreaOffset = Offset(screenWidth / 2, -4.5 * _screenGridHeight + (screenHeight / 2)+25);
    Offset absoluteRouterDeviceOffset = Offset(_deviceIconOffsetList.elementAt(0).dx + (screenWidth / 2), _deviceIconOffsetList.elementAt(0).dy + (screenHeight / 2));

    //if (_networkList.length > 0) canvas.drawLine(Offset(absoluteRouterOffset.dx, absoluteRouterOffset.dy + 50), absoluteRouterDeviceOffset, _linePaint..strokeWidth=3.0);

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
    //_deviceIconOffsetList.add(Offset(0.0, 2 * _screenGridHeight));

    switch (_networkList.length) {
      case 1:
        {
          _deviceIconOffsetList.add(Offset(0.0, 1.5 * _screenGridHeight));
        }
        break;
      case 2:
        {
          _deviceIconOffsetList.add(Offset(1.0 * _screenGridWidth, -1.5 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.0 * _screenGridWidth, -1.5 * _screenGridHeight));
        }
        break;
      case 3:
        {
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -2 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(0.0, 1.5 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -2 * _screenGridHeight));
        }
        break;
      case 4:
        {
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
        }
        break;
      case 5:
        {
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(0.0, 1.5 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
        }
        break;
      case 6:
        {
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3 * _screenGridHeight));
        }
        break;
      case 7:
        {
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, -3 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(0.0, 1.5 * _screenGridHeight));
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
          _deviceIconOffsetList.add(Offset(0.0, 1.5 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, 1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.6 * _screenGridWidth, -1 * _screenGridHeight));
          _deviceIconOffsetList.add(Offset(-1.4 * _screenGridWidth, -3 * _screenGridHeight));
        }
        break;
    }
  }

  void drawAllDeviceConnections(Canvas canvas, Size size) {
    //draw all device connection lines to the pivot device
    //int localIndex =_networkList.indexWhere((element) => element.isLocalDevice == true);
    //int attachedToRouter = _networkList.indexWhere((element) => element.attachedToRouter == true);
    for (int numDev = 0; numDev < _networkList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

        drawDeviceConnection(canvas, _deviceIconOffsetList.elementAt(numDev));
        drawDeviceName(canvas, size, "Geräte online: ${_networkList[numDev].length}", "Netzwerk ${numDev +1 }", _deviceIconOffsetList.elementAt(numDev));


    }
  }


  void drawAllDeviceIcons(Canvas canvas, Size size) {
    //first, draw all device circles and their lines to the pivot device
    for (int numDev = 0; numDev < _networkList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;

        drawDeviceIconEmpty(canvas, numDev);
        drawDeviceIconContent(canvas, numDev);
    }

    //the draw all the device names, so they are above the lines
    for (int numDev = 0; numDev < _networkList.length; numDev++) {
      if (numDev > _deviceIconOffsetList.length) break;
    }

  }

  bool isPointInsideCircle(Offset point, Offset center, double rradius) {
    var radius = rradius * 1.2;
    return point.dx < (center.dx + radius) && point.dx > (center.dx - radius) && point.dy < (center.dy + radius) && point.dy > (center.dy - radius);
  }

  @override
  void paint(Canvas canvas, Size size) {
    fillDeviceIconPositionList();
    //print(_deviceIconOffsetList);

    drawAllDeviceConnections(canvas, size);
    drawAllDeviceIcons(canvas, size);

    if (Platform.isAndroid || Platform.isIOS)
      drawMainIcon(canvas, Icons.router_outlined);
    else if(config["internet_centered"])
      drawMainIcon(canvas, Icons.public_outlined);
    else
      drawMainIcon(canvas, Icons.computer);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawNetworksOverview oldDelegate) {
    if (oldDelegate.numberFoundDevices != numberFoundDevices) return true;
    if (oldDelegate.showingSpeeds != showingSpeeds) return true;

    return false;

    return oldDelegate.numberFoundDevices != numberFoundDevices;
  }
}
