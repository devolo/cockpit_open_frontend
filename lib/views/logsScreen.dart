
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/helpers.dart';
import '../services/handleSocket.dart';

class LogsScreen extends StatefulWidget {
  LogsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LogsScreenState createState() => _LogsScreenState(title: title);
}

class _LogsScreenState extends State<LogsScreen> {
  _LogsScreenState({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: devoloBlue,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SelectableText('Config', style: TextStyle(fontSize: 20,),),
            SelectableText(config.toString()),
            SelectableText('XML-Response', style: TextStyle(fontSize: 20,),),
            SelectableText(socket.xmlResponse.toXmlString(pretty: true)),
          ]),
      backgroundColor: Colors.white,
    );
  }
}