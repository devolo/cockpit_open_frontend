import 'package:cockpit_devolo/deviceClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'handleSocket.dart';
import 'DrawOverview.dart';
import 'helpers.dart';
import 'EmptyPage.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(
  MultiProvider(providers: [
  ChangeNotifierProvider<dataHand>(create: (context) => dataHand()),
  ],
  child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Devolo Cockpit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: devoloBlue,
        canvasColor: Colors.white,
      ),
      home: MyHomePage(title: 'devolo Cockpit'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numDevices = 0;
  Offset _lastTapDownPosition;
  DrawNetworkOverview _Painter;

  @override
  void initState() {
    //dataHand();
    loadAllDeviceIcons();
  }

  void _incrementCounter() {
    setState(() {
      //doc = parseXML()
    });
  }

  @override
  Widget build(BuildContext context) {

    final model = Provider.of<dataHand>(context);
    _Painter = DrawNetworkOverview(context, model.getdeviceList.devices);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: devoloBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            InkWell(
                child: SvgPicture.asset('assets/logo.svg', height: 24, color: Colors.white)
            ),
            Spacer(),
            SizedBox(width: 56)
          ],
        )
        ,
        centerTitle: true,
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:
            GestureDetector(
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
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     ' Devices: ' + deviceList.devices.length.toString(),
            //     style: Theme
            //         .of(context)
            //         .textTheme
            //         .headline5,
            //   ),),
            // Expanded(
            //   child: ListView.builder(
            //       padding: const EdgeInsets.all(0),
            //       itemCount: deviceList.devices.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return ListTile(
            //           title: Text(deviceList.devices[index].type),
            //           subtitle: Text(deviceList.devices[index].name +
            //               ", " +
            //               deviceList.devices[index].ip +
            //               ", " +
            //               deviceList.devices[index].mac +
            //               ", " +
            //               deviceList.devices[index].serialno +
            //               ", " +
            //               deviceList.devices[index].MT),
            //         );
            //       }),
            // ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: () => model.sendXML(),
        tooltip: 'Reload',
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

  void _handleTap(TapUpDetails details) async {
    print('entering dialog....');
    int index = 0;
    String hitDeviceName;
    String hitDeviceType;
    String hitDeviceSN;
    String hitDeviceMT;
    String hitDeviceIp;
    String hitDeviceMac;

    for (Offset deviceIconOffset in deviceIconOffsetList) {
      if (index >
          _Painter.numberFoundDevices) //do not check invisible circles
        break;

      Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2),
          deviceIconOffset.dy + (_Painter.screenHeight / 2));

      if (_Painter.isPointInsideCircle(details.localPosition, absoluteOffset, _Painter.hn_circle_radius)) {
        print("Hit icon #" + index.toString());

        final model = Provider.of<dataHand>(context);

        hitDeviceName = model.getdeviceList.devices[index].name;
        hitDeviceType = model.getdeviceList.devices[index].type;
        hitDeviceSN = model.getdeviceList.devices[index].serialno;
        hitDeviceMT = model.getdeviceList.devices[index].MT;
        hitDeviceIp = model.getdeviceList.devices[index].ip;
        hitDeviceMac = model.getdeviceList.devices[index].mac;

        String _newName = hitDeviceName;

        showDialog<void>(
          context: context,
          barrierDismissible: true, // user doesn't need to tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Info '),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _newName,
                      decoration: InputDecoration(
                        labelText: 'Devicename',
                        //helperText: 'Devicename',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) => ( _newName = value),
                    ),
                    SizedBox(height: 15,),
                    Text('Type: ' +hitDeviceType),
                    Text('Serialnumber: ' +hitDeviceSN),
                    Text('MT-number: ' +hitDeviceMT),
                    Text('IP: ' +hitDeviceIp),
                    Text('MAC: ' +hitDeviceMac),
                    //Text('Rates: ' +hitDeviceRx),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        IconButton(icon: Icon(Icons.web), tooltip: 'Launch Webinterface', onPressed: () => launchURL(hitDeviceIp),),
                        IconButton(icon: Icon(Icons.settings), tooltip: 'Settings', onPressed: () => print('Settings'),),
                        IconButton(icon: Icon(Icons.delete), tooltip: 'Delete Device', onPressed: () => print('Delete Device'),),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    model.sendXML(_newName, hitDeviceMac);
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
  void _handleLongPressStart(BuildContext context) {
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

        final model = Provider.of<dataHand>(context);
        hitDeviceName = model.getdeviceList.devices[index].name;

        setState(() {
          if (_Painter.showSpeedsPermanently && index == _Painter.pivotDeviceIndex) {
            _Painter.showingSpeeds = !_Painter.showingSpeeds;
          } else {
            _Painter.showingSpeeds = true;
          }
          _Painter.pivotDeviceIndex = index;

          //do not update pivot device when the "router device" is long pressed
          print(_Painter.pivotDeviceIndex);
          print(_Painter.showingSpeeds);
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
        _Painter.showingSpeeds = true;
        _Painter.pivotDeviceIndex = 0;
      } else {
        if (!_Painter.showingSpeeds) _Painter.pivotDeviceIndex = 0;
      }
    });
  }

// void _handleTap(TapUpDetails details) {
//   print('entering _handleTab');
//   RenderBox renderBox = context.findRenderObject();
//
//   int index = 0;
//   String hitDeviceName;
//   for (Offset deviceIconOffset in deviceIconOffsetList) {
//     if (index >
//         _Painter.numberFoundDevices) //do not check invisible circles
//       break;
//
//     Offset absoluteOffset = Offset(deviceIconOffset.dx + (_Painter.screenWidth / 2),
//         deviceIconOffset.dy + (_Painter.screenHeight / 2));
//
//     if (_Painter.isPointInsideCircle(details.localPosition, absoluteOffset, _Painter.hn_circle_radius)) {
//       print("Hit icon #" + index.toString());
//
//       hitDeviceName = deviceList.devices[index].name;
//
//       if (deviceList.devices[index].ip != null &&
//           deviceList.devices[index].ip.length > 0 &&
//           deviceList.devices[index].ip.compareTo("http://") != 0 &&
//           deviceList.devices[index].ip.compareTo("https://") != 0) // ToDo understand... 3rd & 4th condition necessary? Ask what backend will send..just seen ips
//       {
//         String webUrl = "http://"+deviceList.devices[index].ip;
//         print("Opening web UI at " + webUrl);
//
//         if (Platform.isFuchsia || Platform.isLinux)
//           print("Would now have opened the Web-Interface at " +
//               webUrl +
//               ", but we are experimental on the current platform. :-/");
//         else
//           launchURL(webUrl);
//
//       } else {
//         Navigator.push(
//           context,
//           new MaterialPageRoute(
//               builder: (context) => new EmptyScreen(title: hitDeviceName)),
//         );
//       }
//     }
//     index++;
//   }
// }
}