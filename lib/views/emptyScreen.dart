/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatefulWidget {
  EmptyScreen({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _EmptyScreenState createState() => _EmptyScreenState(title: title);
}

class _EmptyScreenState extends State<EmptyScreen> {
  _EmptyScreenState({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: mainColor,
      ),
      body: new Center(child: Text("TO DO")),
      backgroundColor: Colors.white,
    );
  }
}