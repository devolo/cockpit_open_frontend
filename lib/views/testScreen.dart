import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import '../shared/helpers.dart';
import '../services/drawOverview.dart';

class EmptyScreen extends StatefulWidget {
  EmptyScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EmptyScreenState createState() => _EmptyScreenState(title: title);
}

class _EmptyScreenState extends State<EmptyScreen> {
  _EmptyScreenState({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: devoloBlue,
      ),
      body: new Center(child: Text("Test Screen")),
      backgroundColor: Colors.white,
    );
  }
}