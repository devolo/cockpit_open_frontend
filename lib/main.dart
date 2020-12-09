import 'package:cockpit_devolo/deviceClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'handleSocket.dart';
import 'DrawOverview.dart';
import 'helpers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devolo Cockpit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Devolo Cockpit'),
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
  int _counter = 0;
  DrawNetworkOverview _Painter;

  //DeviceList deviceList = DeviceList();

  @override
  void initState() {
    handleSocket();
    loadAllDeviceIcons();
  }

  void _incrementCounter() {
    setState(() {
      //doc = parseXML();
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    _Painter = DrawNetworkOverview(context, deviceList.devices);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              //onTapUp: _handleTap,
              onTap: () {_handleTapDown(context);},
              // onLongPress: _handleLongPressStart,
              // onLongPressUp: _handleLongPressEnd,
              child: Center(
                child: CustomPaint(
                  painter: _Painter,
                  child: Container(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
              ' Devices: ' +deviceList.devices.length.toString(),
              style: Theme.of(context).textTheme.headline5,
            ),),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: deviceList.devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(deviceList.devices[index].type),
                      subtitle: Text(deviceList.devices[index].name +
                          ", " +
                          deviceList.devices[index].ip +
                          ", " +
                          deviceList.devices[index].mac +
                          ", " +
                          deviceList.devices[index].serialno +
                          ", " +
                          deviceList.devices[index].MT),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// void _handleTapDown(TapDownDetails details) {
//   print('Tabed');
//   showDialog(
//     context: context,
//     builder: (BuildContext context){
//       return AlertDialog()
//     },
//   );
// }

//ToDo Tabhandler not working yet
void _handleTapDown(BuildContext context) async {
  print('entering dialog....');
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
