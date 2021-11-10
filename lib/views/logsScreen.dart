/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/models/sizeModel.dart';
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
  late SizeModel size;
  final _scrollController = ScrollController();
  final _scrollControllerInside = ScrollController();

  /* =========== Styling =========== */

  double titleFontSize = 23;
  double textFontSize = 14;
  double contentPadding = 14;
  double titlePadding = 14;
  /* ====================== */

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
    size = context.watch<SizeModel>();
    return new Scaffold(
      backgroundColor: backgroundColor,
      appBar: new AppBar(
        title: new Text(title, style: TextStyle(color: fontColorOnMain)),
        backgroundColor: mainColor,
      ),
      body: DefaultTextStyle(
        style: TextStyle(color: fontColorOnBackground),
        child: Container(
          color: backgroundColor,
          child: Scrollbar(
            controller: _scrollController, // <---- Here, the controller
            isAlwaysShown: true, // <---- Required
            child: new SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  SizedBox(
                    height: titlePadding,
                  ),
                  SelectableText(
                    'All devices',
                    style: TextStyle(
                      fontSize: titleFontSize * size.font_factor,
                    ),
                  ),
                  SizedBox(
                    height: contentPadding,
                  ),
                  SelectableText(
                    deviceList.networkListToRealString(),
                    style: TextStyle(fontSize: textFontSize * size.font_factor)
                  ),
                  SizedBox(
                    height: titlePadding,
                  ),
                  SelectableText(
                    'Devices of selected Network',
                    style: TextStyle(
                      fontSize: titleFontSize * size.font_factor,
                    ),
                  ),
                  SizedBox(
                    height: contentPadding,
                  ),
                  SelectableText(deviceList.selectedNetworkListToRealString()),
                  SizedBox(
                    height: titlePadding,
                  ),
                  SelectableText(
                    'XML-Responses',
                    style: TextStyle(
                      fontSize: titleFontSize * size.font_factor,
                    ),
                  ),
                  SizedBox(
                    height: contentPadding,
                  ),
                  SelectableText(
                      socket.xmlDebugResponseList != [] ? printResponseList(socket) : "nothing send yet",
                      style: TextStyle(
                        fontSize: textFontSize * size.font_factor,
                      ),
                  ),
                  SizedBox(
                    height: titlePadding,
                  ),
                  SelectableText(
                    'Config',
                    style: TextStyle(
                      fontSize: titleFontSize * size.font_factor,
                    ),
                  ),
                  SizedBox(
                    height: contentPadding,
                  ),
                  SelectableText(
                      config.toString(),
                      style: TextStyle(
                        fontSize: textFontSize * size.font_factor,
                      ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
