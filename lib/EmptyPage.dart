import 'package:flutter/material.dart';

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
      ),
      body: new Center(child: Text("This page is intentionally left blank.")),
      backgroundColor: Colors.white,
    );
  }
}