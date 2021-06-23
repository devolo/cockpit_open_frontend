/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:xml/xml.dart';

class DebugScreen extends StatefulWidget {
  DebugScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _DebugScreenState createState() => _DebugScreenState(title: title);
}

class _DebugScreenState extends State<DebugScreen> {
  _DebugScreenState({required this.title});

  final String title;

  final _scrollController = ScrollController();
  final _scrollControllerInside = ScrollController();

  String printResponseList(socket) {
    String ret = "";
    for (var elem in socket.xmlDebugResponseList) {
      if (elem.runtimeType == XmlDocument) {
        ret += elem.toXmlString(pretty: true);
        ret += "\n";
      } else {
        ret += elem.toString();
      }
      ret += "\n";
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<DataHand>(context);
    final deviceList = Provider.of<NetworkList>(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: backgroundColor,
      ),
      body: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Container(
          color: backgroundColor,
          child: Scrollbar(
            controller: _scrollController, // <---- Here, the controller
            isAlwaysShown: true, // <---- Required
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: new SingleChildScrollView(
                controller: _scrollController,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  SelectableText(
                    'DeviceListList',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SelectableText(deviceList.networkListToRealString()),
                  SizedBox(
                    height: 20,
                  ),
                  SelectableText(
                    'Active DeviceList',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Column(
                    children: [
                      Scrollbar(
                          controller: _scrollControllerInside, // <---- Here, the controller
                          isAlwaysShown: true, // <---- Required
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new SingleChildScrollView(
                              controller: _scrollControllerInside,
                              child: SelectableText(deviceList.selectedNetworkListToRealString()),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SelectableText(
                    'XML-Response',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SelectableText(socket.xmlDebugResponseList != [] ? printResponseList(socket) : "nothing send yet"),
                  SizedBox(
                    height: 20,
                  ),
                  SelectableText(
                    'Config',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SelectableText(config.toString()),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
