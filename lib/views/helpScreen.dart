/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddDeviceScreen extends StatefulWidget {
  AddDeviceScreen({Key key, this.title, NetworkList deviceList}) : super(key: key);

  final String title;
  dataHand model;

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState(title: title);
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  var response;
  bool _loading = false;

  _AddDeviceScreenState({this.title});

  final String title;
  List<Image> optimizeImages = loadOptimizeImages();
  Image _currImage;
  int _index = 0;

  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    _currImage = optimizeImages.first;
    var socket = Provider.of<dataHand>(context);
    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text(
          S.of(context).help,
          style: TextStyle(color: fontColorLight),
          textScaleFactor: fontSizeFactor,
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        shadowColor: Colors.transparent,
      ),
      body: new SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonTheme(
                    minWidth: 300,
                    child: RaisedButton(
                      color: secondColor,
                      textColor: fontColorDark,
                      hoverColor: mainColor.withOpacity(0.3),
                      padding: EdgeInsets.only(
                        top: 40,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.post_add_rounded,
                            size: 100,
                            color: mainColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Gerät einrichten",
                            textScaleFactor: fontSizeFactor,
                          ),
                        ],
                      ),
                      onPressed: () {
                        _addDeviceAlert(context);
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 300,
                    child: RaisedButton(
                      color: secondColor,
                      textColor: fontColorDark,
                      padding: EdgeInsets.only(
                        top: 40,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      hoverColor: mainColor.withOpacity(0.3),
                      child: Column(
                        children: [
                          Icon(
                            Icons.settings_remote_rounded,
                            size: 100,
                            color: mainColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Empfang Optimieren",
                            textScaleFactor: fontSizeFactor,
                          ),
                        ],
                      ),
                      onPressed: () {
                        _optimiseAlert(context);
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 300,
                    child: RaisedButton(
                      color: secondColor,
                      textColor: fontColorDark,
                      hoverColor: mainColor.withOpacity(0.3),
                      padding: EdgeInsets.only(
                        top: 40,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.contact_support,
                            size: 100,
                            color: mainColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Support kontaktieren",
                            textScaleFactor: fontSizeFactor,
                          ),
                        ],
                      ),
                      onPressed: () {
                        _contactSupportAlert(context, socket);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _optimiseAlert(context) {
    double _animatedHeight = 0.0;
    String selected;

    Map<String, dynamic> contents = Map();
    optimizeImages.asMap().forEach((i, value) {
      contents["Optimierungstitel $i"] = optimizeImages[i];
    });

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              S.of(context).optimizationHelp,
              style: TextStyle(color: fontColorLight),
            )),
            backgroundColor: backgroundColor.withOpacity(0.9),
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            content: StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned.fill(
                    top: -90,
                    right: -35,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: secondColor,
                          child: Icon(Icons.close, color: fontColorDark),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        for (dynamic con in contents.entries)
                          Flex(
                            direction: Axis.vertical,
                            children: [
                              new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    print(con);
                                    selected = con.key;
                                    _animatedHeight != 0.0 ? _animatedHeight = 0.0 : _animatedHeight = 250.0;
                                  });
                                  //AppBuilder.of(context).rebuild();
                                },
                                child: new Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(
                                        " " + con.key,
                                        style: TextStyle(color: fontColorDark),
                                      ),
                                      Spacer(),
                                      // ToDo CircleAvatar doesn't change
                                      // new CircleAvatar(
                                      //   backgroundColor: con.value.selectedColor, //_tempShadeColor,
                                      //   radius: 15.0,
                                      // ),
                                      new Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: fontColorDark,
                                      ),
                                    ],
                                  ),
                                  color: secondColor, //Colors.grey[800].withOpacity(0.9),
                                  height: 50.0,
                                  width: 900.0,
                                ),
                              ),
                              new AnimatedContainer(
                                duration: const Duration(milliseconds: 120),
                                child: Column(
                                  children: [
                                    Expanded(child: con.value),
                                  ],
                                ),
                                height: selected == con.key ? _animatedHeight : 0.0,
                                color: secondColor.withOpacity(0.8),
                                //Colors.grey[800].withOpacity(0.6),
                                width: 900.0,
                              ),
                            ],
                          ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //       icon: Icon(Icons.arrow_back_ios, color: fontColorLight,),
                        //       onPressed: () {
                        //         print("back");
                        //         setState(() {
                        //           if(_index > 0){
                        //           _index--;
                        //           _currImage = optimizeImages[_index];}
                        //           else{return null;}
                        //         });
                        //       },
                        //     ),
                        //     Container(
                        //       child: _currImage,
                        //     ),
                        //     IconButton(
                        //       icon: Icon(Icons.arrow_forward_ios, color: fontColorLight,),
                        //       onPressed: () {
                        //         print("forward");
                        //         setState(() {
                        //           if(_index < optimizeImages.length-1){
                        //           _index++;
                        //           _currImage = optimizeImages[_index];}
                        //           else{return null;}
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  void _addDeviceAlert(context) {
    int _currentStep = 0;
    StepperType stepperType = StepperType.horizontal;

    switchStepsType() {
      setState(() => stepperType == StepperType.vertical ? stepperType = StepperType.horizontal : stepperType = StepperType.vertical);
    }

    tapped(int step) {
      setState(() => _currentStep = step);
    }

    continued() {
      _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    }

    cancel() {
      _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
    }

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Gerät einrichten",
              style: TextStyle(color: fontColorLight),
            )),
            backgroundColor: backgroundColor.withOpacity(0.9),
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            content: StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned.fill(
                    top: -90,
                    right: -35,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: secondColor,
                          child: Icon(Icons.close, color: fontColorDark),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.grey[200],
                    height: 800,
                    width: 900,
                    child: Stack(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    accentColor: Colors.white,
                                    primarySwatch: Colors.grey,
                                    canvasColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    //textTheme: TextTheme(: fontColorDark),
                                    colorScheme: ColorScheme.light(
                                        //primary: Colors.white
                                        )),
                                child: Stepper(
                                  type: stepperType,
                                  physics: ScrollPhysics(),
                                  currentStep: _currentStep,
                                  onStepTapped: (step) {
                                    setState(() => _currentStep = step);
                                  },
                                  onStepContinue: () {
                                    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
                                  },
                                  onStepCancel: () {
                                    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
                                  },
                                  controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: onStepCancel,
                                          child: Row(
                                            children: [
                                              Icon(Icons.arrow_back_ios_rounded, color: fontColorLight),
                                              Text(
                                                'Zurück',
                                                style: TextStyle(color: fontColorLight),
                                              ),
                                            ],
                                          ),
                                          //color: Colors.white,
                                        ),

                                        FlatButton(
                                          onPressed: onStepContinue,
                                          child: Row(
                                            children: [
                                              Text('Weiter', style: TextStyle(color: fontColorLight)),
                                              Icon(Icons.arrow_forward_ios_rounded, color: fontColorLight,),
                                            ],
                                          ),
                                          //color: Colors.white,
                                        ),
                                      ],
                                    );
                                  },
                                  steps: <Step>[
                                    Step(
                                      title: new Text(''),
                                      content: Column(
                                        children: <Widget>[
                                          SelectableText(
                                            "Stecken Sie beide PLC-Geräte in die gewünschten Wandsteckdosen und warten ca. 45 Sekunden.",
                                            style: TextStyle(color: fontColorLight),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                  child: Image(
                                                    image: AssetImage('assets/addDevice/MagicWifi_step1.PNG'),
                                                    fit: BoxFit.scaleDown,
                                                  )),
                                              Expanded(
                                                  child: Image(
                                                    image: AssetImage('assets/addDevice/MagicWifi_step2.PNG'),
                                                    fit: BoxFit.scaleDown,
                                                  )),
                                              Expanded(
                                                  child: Image(
                                                    image: AssetImage('assets/addDevice/MagicWifi_step3.PNG'),
                                                    fit: BoxFit.scaleDown,
                                                  )),
                                            ],
                                          ),

                                          //SizedBox(height: 50,),
                                          // SelectableText(
                                          //   S.of(context).addDeviceInstructionText,
                                          //   style: TextStyle(color: fontColorLight),
                                          //   //textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: true),
                                          // ),
                                        ],
                                      ),
                                      isActive: _currentStep >= 0,
                                      state: _currentStep >= 0 ? StepState.complete : StepState.indexed,
                                    ),
                                    Step(
                                      title: new Text(''),
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SelectableText(
                                            "Drücken Sie kurz den Verschlüsselungsknopf des ersten (evtl. bereits vorhandenen) PLC-Gerätes.",
                                            style: TextStyle(color: fontColorLight),
                                          ),
                                          SelectableText(
                                            "(Alternativ kann das Pairing auch über das Webinterface des bereits vorhandenen Geräts gestartet werden.)",
                                            style: TextStyle(color: fontColorLight),
                                          ),
                                            Image(
                                                  image: AssetImage('assets/addDevice/MagicWifi_step4.PNG'),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                  child: Image(
                                                image: AssetImage('assets/addDevice1.png'),
                                                fit: BoxFit.scaleDown,
                                              )),
                                              Expanded(
                                                  child: Image(
                                                image: AssetImage('assets/addDevice2.png'),
                                                fit: BoxFit.scaleDown,
                                              )),
                                              Expanded(
                                                  child: Image(
                                                    image: AssetImage('assets/addDevice3.png'),
                                                    fit: BoxFit.scaleDown,
                                                  )),
                                              Expanded(
                                                  child: Image(
                                                    image: AssetImage('assets/addDevice4.png'),
                                                    fit: BoxFit.scaleDown,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      isActive: _currentStep >= 0,
                                      state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
                                    ),
                                    Step(
                                      title: new Text(''),
                                      content: Column(
                                        children: <Widget>[
                                          SelectableText(
                                            "Drücken Sie innerhalb von zwei Minuten den Verschlüsselungsknopf des zweiten (neuen) PLC-Gerätes ebenfalls kurz.",
                                            style: TextStyle(color: fontColorLight),
                                          ),
                                          Image(
                                            image: AssetImage('assets/addDevice/MagicWifi_step5.PNG'),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ],
                                      ),
                                      isActive: _currentStep >= 0,
                                      state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
                                    ),
                                    Step(
                                      title: new Text(''),
                                      content: Column(
                                        children: <Widget>[
                                          SelectableText(
                                            "Sobald die LEDs dauerhaft leuchten, sind die PLC-Geräte betriebsbereit.",
                                            style: TextStyle(color: fontColorLight),
                                          ),
                                          Image(
                                            image: AssetImage('assets/addDevice/MagicWifi_step6.PNG'),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ],
                                      ),
                                      isActive: _currentStep >= 0,
                                      state: _currentStep >= 3 ? StepState.indexed : StepState.indexed,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  void _contactInfoAlert(context) {
    String _processNr;
    String _name;
    String _email;

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              S.of(context).contactInfo,
              style: TextStyle(color: fontColorLight),
            ),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: fontColorLight),
            content: Column(
              children: <Widget>[
                Text(S.of(context).theCreatedSupportInformationCanNowBeSentToDevolo),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: S.of(context).processNumber,
                    labelStyle: TextStyle(color: fontColorLight),
                    hoverColor: secondColor.withOpacity(0.2),
                    contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    filled: true,
                    fillColor: secondColor.withOpacity(0.2),
                    //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorLight,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorLight, //Colors.transparent,
                        //width: 2.0,
                      ),
                    ),
                    //labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.amberAccent : Colors.blue),
                  ),
                  onChanged: (value) => (_processNr = value),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).pleaseEnterProcessingNumber;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //initialValue: _newPw,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: S.of(context).yourName,
                    labelStyle: TextStyle(color: fontColorLight),
                    hoverColor: secondColor.withOpacity(0.2),
                    contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    filled: true,
                    fillColor: secondColor.withOpacity(0.2),
                    //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorLight,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorLight, //Colors.transparent,
                        //width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) => (_name = value),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).pleaseFillInYourName;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //initialValue: _newPw,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: S.of(context).yourEmailaddress,
                    labelStyle: TextStyle(color: fontColorLight),
                    counterStyle: TextStyle(color: fontColorLight),
                    hoverColor: secondColor.withOpacity(0.2),
                    contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    filled: true,
                    fillColor: secondColor.withOpacity(0.2),
                    //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorLight,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorLight, //Colors.transparent,
                        //width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) => (_email = value),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).pleaseEnterYourMailAddress;
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: fontColorLight,
                      size: 35 * fontSizeFactor,
                    ),
                    Text(
                      S.of(context).confirm,
                      style: TextStyle(color: fontColorLight),
                    ),
                  ],
                ),
                onPressed: () {
                  // Critical things happening here
                  //ToDo send supportInfo
                  //socket.sendXML(messageType, mac: hitDevice.mac);
                  Navigator.maybeOf(context).pop();
                },
              ),
              FlatButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: fontColorLight,
                        size: 35 * fontSizeFactor,
                      ),
                      Text(
                        S.of(context).cancel,
                        style: TextStyle(color: fontColorLight),
                      ),
                    ],
                  ), //Text('Abbrechen'),
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context).pop();
                  }),
            ],
          );
        });
  }

  void _contactSupportAlert(context, socket) {
    String _htmlfilename;
    String _zipfilename;
    bool _isButtonDisabled = true;

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Support kontaktieren",
              style: TextStyle(color: fontColorLight),
            )),
            backgroundColor: backgroundColor.withOpacity(0.9),
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            content: StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned.fill(
                    top: -90,
                    right: -35,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: secondColor,
                          child: Icon(Icons.close, color: fontColorDark),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          tileColor: secondColor,
                          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                            FlatButton(
                              height: 60,
                              hoverColor: mainColor.withOpacity(0.4),
                              color: mainColor.withOpacity(0.4),
                              child: Row(children: [
                                Text(
                                  S.of(context).generateSupportInformation,
                                  style: TextStyle(color: fontColorDark),
                                ),
                                Stack(children: <Widget>[
                                  Container(child: _loading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)) : Text("")),
                                  if (response != null && _loading == false)
                                    Container(
                                        child: (response["result"] == "ok" && response.isNotEmpty)
                                            ? Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              )),
                                ]),
                              ]),
                              //color: devoloBlue,
                              //textColor: Colors.white,
                              onPressed: () async {
                                setState(() {
                                  _loading = true;
                                  socket.sendXML('SupportInfoGenerate');
                                });

                                response = await socket.recieveXML(["SupportInfoGenerateStatus"]);
                                //print('Response: ' + response.toString());

                                if (response["result"] == "ok") {
                                  setState(() {
                                    _htmlfilename = response["htmlfilename"];
                                    _zipfilename = response["zipfilename"];
                                    _loading = false;
                                    _isButtonDisabled = false;
                                  });
                                }
                              },
                            ),
                            //Flexible(child: socket.waitingResponse ? CircularProgressIndicator() : Text(" ")),
                            Spacer(),
                            AbsorbPointer(
                                absorbing: _isButtonDisabled,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.open_in_browser_rounded),
                                      tooltip: S.of(context).openBrowser,
                                      color: _isButtonDisabled ? Colors.grey : mainColor,
                                      onPressed: () {
                                        openFile(_htmlfilename);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.archive_outlined),
                                      tooltip: S.of(context).openZip,
                                      color: _isButtonDisabled ? Colors.grey : mainColor,
                                      onPressed: () {
                                        openFile(_zipfilename);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send_and_archive),
                                      tooltip: S.of(context).sendToDevolo,
                                      color: _isButtonDisabled ? Colors.grey : mainColor,
                                      onPressed: () {
                                        _contactInfoAlert(context);
                                      },
                                    ),
                                  ],
                                )),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

}
