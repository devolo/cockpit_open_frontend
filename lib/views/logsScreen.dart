
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';

class DebugScreen extends StatefulWidget {
  DebugScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DebugScreenState createState() => _DebugScreenState(title: title);
}

class _DebugScreenState extends State<DebugScreen> {
  _DebugScreenState({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    final deviceList = Provider.of<DeviceList>(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: devoloBlue,
      ),
      body: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SelectableText('Config', style: TextStyle(fontSize: 20,),),
            SelectableText(config.toString()),
            SelectableText('XML-Response', style: TextStyle(fontSize: 20,),),
            SelectableText(socket.xmlResponse!= null?socket.xmlResponse.toXmlString(pretty: true): "nothing send yet"),
            SelectableText('XML-DeviceList', style: TextStyle(fontSize: 20,),),
            Expanded(child:SelectableText(deviceList.toString()),),
          ]),
    );
  }
}