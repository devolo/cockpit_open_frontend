import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;


class OverviewScreen extends StatefulWidget {
  OverviewScreen({Key key}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final networkIndex = 0;


  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int numDevices = 0;
  Offset _lastTapDownPosition;
  DrawNetworkOverview _Painter;

  bool showingSpeedsFake = false;
  int pivotDeviceIndexFake = 0;


  @override
  void initState() {
    //dataHand();
  }

  void _reloadTest() {
    setState(() {
      //doc = parseXML()
    });
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    final deviceList = Provider.of<DeviceList>(context);
    socket.setDeviceList(deviceList);

    _Painter = DrawNetworkOverview(context, deviceList, showingSpeedsFake, pivotDeviceIndexFake, widget.networkIndex);

    print("drawing Overview...");

    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  Container(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: _handleTap,
          onTapDown:_handleTapDown,
          onLongPress: () =>_handleLongPressStart(context),
          onLongPressUp: _handleLongPressEnd,
          child: Center(
            child: CustomPaint(
              painter: _Painter,
              child: Container(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {setState(() {
          socket.sendXML('RefreshNetwork');
        });
        },
        tooltip: 'Neu laden',
        backgroundColor: devoloBlue,
        hoverColor: Colors.blue,
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void _handleTapDown(TapDownDetails details) {
    print('entering tabDown');
    _lastTapDownPosition = details.localPosition;
  }

  void _handleTap(TapUpDetails details)  {
    print('entering dialog....');
    int index = 0;
    Device hitDevice;
    String hitDeviceName;
    String hitDeviceType;
    String hitDeviceSN;
    String hitDeviceMT;
    String hitDeviceVersion;
    String hitDeviceVersionDate;
    String hitDeviceIp;
    String hitDeviceMac;
    bool hitDeviceAtr;

    for (Offset deviceIconOffset in deviceIconOffsetList) {
      if (index >
          _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2),
          deviceIconOffset.dy + (_Painter.screenHeight / 2));

      if (_Painter.isPointInsideCircle(details.localPosition, absoluteOffset, _Painter.hn_circle_radius)) {
        print("Hit icon #" + index.toString());

        final socket = Provider.of<dataHand>(context);
        final deviceList = Provider.of<DeviceList>(context);

        hitDevice = deviceList.getDeviceList(widget.networkIndex)[index];
        hitDeviceName = deviceList.getDeviceList(widget.networkIndex)[index].name;
        hitDeviceType = deviceList.getDeviceList(widget.networkIndex)[index].type;
        hitDeviceSN = deviceList.getDeviceList(widget.networkIndex)[index].serialno;
        hitDeviceMT = deviceList.getDeviceList(widget.networkIndex)[index].MT;
        hitDeviceVersion = deviceList.getDeviceList(widget.networkIndex)[index].version;
        hitDeviceVersionDate = deviceList.getDeviceList(widget.networkIndex)[index].version_date;
        hitDeviceIp = deviceList.getDeviceList(widget.networkIndex)[index].ip;
        hitDeviceMac = deviceList.getDeviceList(widget.networkIndex)[index].mac;
        hitDeviceAtr = deviceList.getDeviceList(widget.networkIndex)[index].attachedToRouter;

        String _newName = hitDeviceName;

        showDialog<void>(
          context: context,
          barrierDismissible: true, // user doesn't need to tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: SelectableText('Geräteinfo'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Table(
                      defaultColumnWidth: FixedColumnWidth(200.0),
                    children: [
                      TableRow(children: [
                        SelectableText('Name: '),
                      TextFormField(
                        initialValue: _newName,
                        decoration: InputDecoration(
                          //labelText: 'Devicename',
                          //helperText: 'Devicename',
                        ),
                        onChanged: (value) => ( _newName = value),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Bitte Gerätenamen eintargen';
                          }
                          return null;
                        },
                      ),
                      ]),
                      TableRow(children: [
                        SelectableText('Type: '),
                        SelectableText(hitDeviceType),
                      ]),
                      TableRow(children: [
                        SelectableText('Seriennummer: '),
                        SelectableText(hitDeviceSN),
                      ]),
                      TableRow(children: [
                        SelectableText('MT-Nummer: '),
                        SelectableText(hitDeviceMT.substring(2)),
                      ]),
                      TableRow(children: [
                        SelectableText('Version: '),
                        SelectableText('${hitDeviceVersion} (${hitDeviceVersionDate})'),
                      ]),
                      TableRow(children: [
                        SelectableText('IP-Adresse: ' ),
                        SelectableText(hitDeviceIp),
                      ]),
                      TableRow(children: [
                        SelectableText('MAC-Adresse: ' ),
                        SelectableText(hitDeviceMac),
                      ]),
                      TableRow(children: [
                        SelectableText('Attached to Router: ' ),
                        SelectableText(hitDeviceAtr.toString()),
                      ]),
                    ],),
                    //Text('Rates: ' +hitDeviceRx),
                    Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        IconButton(icon: Icon(Icons.public, color: devoloBlue,), tooltip: S.of(context).launchWebinterface, onPressed: () => launchURL(hitDeviceIp),),
                        IconButton(icon: Icon(Icons.lightbulb, color: devoloBlue,), tooltip: S.of(context).identifyDevice, onPressed: () => socket.sendXML('IdentifyDevice', mac: hitDeviceMac)),
                        IconButton(icon: Icon(Icons.find_in_page, color: devoloBlue,), tooltip: S.of(context).showManual,
                            onPressed: () async {
                          socket.sendXML('GetManual', newValue: hitDeviceMT, valueType: 'product', newValue2: 'de', valueType2: 'language');
                          var response = await socket.recieveXML(["GetManualResponse"]);
                          setState(() {
                            openFile(response['filename']);
                          });
                        }),
                        IconButton(icon: Icon(Icons.upload_file, color: devoloBlue,), tooltip: S.of(context).factoryReset, onPressed: () =>_handleCriticalActions(context, socket, 'ResetAdapterToFactoryDefaults', hitDevice),),
                        IconButton(icon: Icon(Icons.delete, color: devoloBlue,), tooltip: S.of(context).deleteDevice, onPressed: () =>_handleCriticalActions(context, socket, 'RemoveAdapter', hitDevice),), //ToDo Delete Device see wiki
                      ],
                    ),

                  ],
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.check_circle_outline,
                    size: 35,
                    color: devoloBlue,
                  ), //Text('Bestätigen'),
                  tooltip: S.of(context).confirm,
                  onPressed: () {
                    // Critical things happening here
                    socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      index++;
    }
  }

  //ToDo UI doesn't change
  void _handleLongPressStart(context) {
    print("long press down");
    RenderBox renderBox = context.findRenderObject();

    int index = 0;
    String hitDeviceName;
    for (Offset deviceIconOffset in deviceIconOffsetList) {
      if (index >
          _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2),
          deviceIconOffset.dy + (_Painter.screenHeight / 2));

      if (_Painter.isPointInsideCircle(_lastTapDownPosition, absoluteOffset, _Painter.hn_circle_radius)) {
        print("Long press on icon #" + index.toString());

        final deviceList = Provider.of<DeviceList>(context);
        hitDeviceName = deviceList.getDeviceList(widget.networkIndex)[index].name;

        setState(() {
          if (_Painter.showSpeedsPermanently && index == _Painter.pivotDeviceIndex) {
            //_Painter.showingSpeeds = !_Painter.showingSpeeds;
          } else {
            //_Painter.showingSpeeds = true;
            showingSpeedsFake = true;  // ToDo fix workaround see OverviewConsturctor
            config["show_speeds"] = true;
          }
          //_Painter.pivotDeviceIndex = index;
          pivotDeviceIndexFake = index;

          //do not update pivot device when the "router device" is long pressed
          print('Pivot on longPress:' +_Painter.pivotDeviceIndex.toString());
          print('sowingSpeed on longPress:' +_Painter.showingSpeeds.toString());
        });
        return;
      }
      index++;
    }
  }

  void _handleLongPressEnd() {
    print("long press up");

    setState(() {
      if (!_Painter.showSpeedsPermanently) {
        showingSpeedsFake = false;
        config["show_speeds"] = false;
        _Painter.pivotDeviceIndex = 0;
        pivotDeviceIndexFake = 0;
      } else {
        if (!_Painter.showingSpeeds) _Painter.pivotDeviceIndex = 0;
      }
    });
  }

  void _handleCriticalActions(context, socket, messageType, Device hitDevice) {
    showDialog<void>(
    context: context,
    barrierDismissible: true, // user doesn't need to tap button!
    builder: (BuildContext context) {
    return AlertDialog(
      title: Text(messageType),
      content: hitDevice.attachedToRouter?Text(S.of(context).pleaseConfirmActionNattentionYourRouterIsConnectedToThis):Text(S.of(context).pleaseConfirmAction),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            size: 35,
            color: devoloBlue,
          ), //Text('Bestätigen'),
          tooltip: S.of(context).confirm,
          onPressed: () {
            // Critical things happening here
            socket.sendXML(messageType, mac: hitDevice.mac);
            Navigator.of(context).pop();
          },
        ),
        Spacer(),
        IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              size: 35,
              color: devoloBlue,
            ), //Text('Abbrechen'),
            tooltip: S.of(context).cancel,
            onPressed: () {
              // Cancel critical action
              Navigator.of(context).pop();
            }),

      ],
    );
  });
  }

}