import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/services/drawNetworksOverview.dart';
import 'package:cockpit_devolo/services/drawOverview.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;


class OverviewNetworksScreen extends StatefulWidget {
  OverviewNetworksScreen({Key key}) : super(key: key);


  @override
  _OverviewNetworksScreenState createState() => _OverviewNetworksScreenState();
}

class _OverviewNetworksScreenState extends State<OverviewNetworksScreen> {
  Offset _lastTapDownPosition;
  DrawNetworksOverview _Painter;

  bool showingSpeeds = false;
  int pivotDeviceIndex = 0;


  @override
  void initState() {
    //dataHand();
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    final _deviceList = Provider.of<NetworkList>(context);
    socket.setDeviceList(_deviceList);

    _Painter = DrawNetworksOverview(context, _deviceList, showingSpeeds, pivotDeviceIndex);

    print("drawing Overview...");

    //if(devic)
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  Container(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (TapUpDetails) => _handleTap(TapUpDetails, context),
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
        tooltip: S.of(context).refresh,
        backgroundColor: mainColor,
        hoverColor: secondColor,
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void _handleTapDown(TapDownDetails details) {
    print('entering tabDown');
    _lastTapDownPosition = details.localPosition;
  }

  void _handleTap(TapUpDetails details, BuildContext context)  {
    print('entering dialog....');
    int index = 0;
    DrawOverview _DevicePainter;

    for (Offset deviceIconOffset in deviceIconOffsetList) {
      if (index >
          _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2),
          deviceIconOffset.dy + (_Painter.screenHeight / 2));

      if (_Painter.isPointInsideCircle(details.localPosition, absoluteOffset, _Painter.hn_circle_radius)) {
        print("Hit icon #" + index.toString());

        final socket = Provider.of<dataHand>(context);
        final _networkList = Provider.of<NetworkList>(context);

        setState(() {
          _networkList.selectedNetworkIndex = index;
          showNetwork = false;
          socket.sendXML('RefreshNetwork'); // ToDo refresh as workaround setState should change UI
        });

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

        final deviceList = Provider.of<NetworkList>(context);
        hitDeviceName = deviceList.getDeviceList()[index].name;

        setState(() {
          if (config["show_speeds_permanent"] && index == _Painter.pivotDeviceIndex) {
            //_Painter.showingSpeeds = !_Painter.showingSpeeds;
          } else {
            //_Painter.showingSpeeds = true;
            showingSpeeds = true;  // ToDo fix workaround see OverviewConsturctor
            config["show_speeds"] = true;
          }
          //_Painter.pivotDeviceIndex = index;
          pivotDeviceIndex = index;

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
      if (!config["show_speeds_permanent"]) {
        showingSpeeds = false;
        config["show_speeds"] = false;
        _Painter.pivotDeviceIndex = 0;
        pivotDeviceIndex = 0;
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
      content: hitDevice.attachedToRouter?Text(S.of(context).pleaseConfirmActionAttentionYourRouterIsConnectedToThis):Text(S.of(context).pleaseConfirmAction),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            size: 35,
            color: mainColor,
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
              color: mainColor,
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