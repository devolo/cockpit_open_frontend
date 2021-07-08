/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:io';

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/fontSizeModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/alertDialogs.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/buttons.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';

class AddDeviceScreen extends StatefulWidget {
  AddDeviceScreen({Key? key, NetworkList? deviceList, required this.title}) : super(key: key);

  final String title;
  DataHand? model;

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {

  var response;

  //_AddDeviceScreenState({required this.title});

  late final String title;
  List<Image> optimizeImages = loadOptimizeImages();
  late Image _currImage;
  int _index = 0;

  List<Device> localHpavDevices = [];

  FocusNode myFocusNode = new FocusNode();

  late FontSize fontSize;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _currImage = optimizeImages.first;
    var socket = Provider.of<DataHand>(context);
    final _deviceList = Provider.of<NetworkList>(context);

    localHpavDevices.clear();
    List<Device> localDevices = _deviceList.getLocalDevices();
    for(Device device in localDevices){
      if(device.networkType.contains('hpav')){
        localHpavDevices.add(device);
      }
    }

    fontSize = context.watch<FontSize>();

    return new Scaffold(
      backgroundColor: Colors.transparent,

      body: new SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: paddingBarTop, left: 20, right: 20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                S.of(context).help,
                style: TextStyle(fontSize: fontSizeAppBarTitle * fontSize.factor, color: fontColorOnBackground),
              ),
              SizedBox(height:paddingBarTop),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonTheme(
                    minWidth: 300,
                    child: RaisedButton(
                      color: secondColor,
                      textColor: fontColorOnSecond,
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
                            DevoloIcons.ic_add_24px,
                            size: 100,
                            color: mainColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            S.of(context).setUpDevice,
                            textScaleFactor: fontSize.factor,
                          ),
                        ],
                      ),
                      onPressed: () {
                        _addDeviceAlert(context,socket);
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 300,
                    child: RaisedButton(
                      color: secondColor,
                      textColor: fontColorOnSecond,
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
                            DevoloIcons.devolo_UI_wifi,
                            size: 100,
                            color: mainColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            S.of(context).optimizeReception,
                            textScaleFactor: fontSize.factor,
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
                      textColor: fontColorOnSecond,
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
                            DevoloIcons.ic_question_answer_24px,
                            size: 100,
                            color: mainColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            S.of(context).contactSupport,
                            textScaleFactor: fontSize.factor,
                          ),
                        ],
                      ),
                      onPressed: () {
                        _loadingSupportDialog(context,socket);
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
    String? selected;

    Map<String, dynamic> contents = Map();
    optimizeImages.asMap().forEach((i, value) {
      contents["Optimierungstitel $i"] = optimizeImages[i];
    });

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Center(
                    child: Text(
                  S.of(context).optimizationHelp,
                  style: TextStyle(color: fontColorOnBackground),
                )),
              ],
            ),
            titlePadding: EdgeInsets.all(2),
            backgroundColor: backgroundColor.withOpacity(0.9),
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            content: StatefulBuilder(// You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Center(
                    child: Column(
                      children: [
                        for (dynamic con in contents.entries)
                          Flex(
                            direction: Axis.vertical,
                            children: [
                              new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    logger.w(con);
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
                                        style: TextStyle(color: fontColorOnSecond),
                                      ),
                                      Spacer(),
                                      // ToDo CircleAvatar doesn't change
                                      // new CircleAvatar(
                                      //   backgroundColor: con.value.selectedColor, //_tempShadeColor,
                                      //   radius: 15.0,
                                      // ),
                                      new Icon(
                                        DevoloIcons.ic_arrow_drop_down_24px,
                                        color: fontColorOnSecond,
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
                      ],
                    ),
                  );
            }),
          );
        });
  }

  void _addDeviceAlert(context, socket) {
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
            title: Column(
              children: [
                getCloseButton(context),
                Center(
                    child: Text(
                  "Gerät einrichten",
                  style: TextStyle(color: fontColorOnBackground),
                )),
              ],
            ),
            titlePadding: EdgeInsets.all(2),
            backgroundColor: backgroundColor.withOpacity(0.9),
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            content: StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                    //color: Colors.grey[200],
                    height: 800,
                    width: 900,
                    child: Stack(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            if(localHpavDevices.length > 0)
                              TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0))),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 35, vertical: 18)),
                                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                        (states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return devoloGreen.withOpacity(hoverOpacity);
                                      } else if (states.contains(MaterialState.pressed)) {
                                        return devoloGreen.withOpacity(activeOpacity);
                                      }
                                      return devoloGreen;
                                    },
                                  ),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () => _addRemoteDeviceDialog(context,socket),
                                child: Text(
                                      S.of(context).addDeviceViaSecurityId, textScaleFactor: fontSize.factor,
                                      style:TextStyle(color: Colors.white)
                                  ),
                                ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    canvasColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    colorScheme:
                                    fontColorOnSecond == devoloGray
                                        ? ColorScheme.dark(
                                      primary: secondColor,
                                      secondary: secondColor,
                                    )
                                        : ColorScheme.light(
                                      primary: secondColor,
                                      secondary: secondColor,
                                    ),
                                ),

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
                                  controlsBuilder: (BuildContext context, {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: onStepCancel,
                                          child: Row(
                                            children: [
                                              Icon(DevoloIcons.devolo_UI_chevron_left, color: fontColorOnBackground),
                                              Text(
                                                'Zurück',
                                                style: TextStyle(color: fontColorOnBackground),
                                              ),
                                            ],
                                          ),
                                          //color: Colors.white,
                                        ),

                                        TextButton(
                                          onPressed: onStepContinue,
                                          child: Row(
                                            children: [
                                              Text('Weiter', style: TextStyle(color: fontColorOnBackground)),
                                              Icon(DevoloIcons.devolo_UI_chevron_right, color: fontColorOnBackground,),
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
                                            style: TextStyle(color: fontColorOnBackground),
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
                                            style: TextStyle(color: fontColorOnBackground),
                                          ),
                                          SelectableText(
                                            "(Alternativ kann das Pairing auch über das Webinterface des bereits vorhandenen Geräts gestartet werden.)",
                                            style: TextStyle(color: fontColorOnBackground),
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
                                            style: TextStyle(color: fontColorOnBackground),
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
                                            style: TextStyle(color: fontColorOnBackground),
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
                  );
            }),
          );
        });
  }

  void _addRemoteDeviceDialog(context, socket) {

    Device selectedDevice = localHpavDevices.first;
    List<String> hpavDevicesNames = [];
    for(Device device in localHpavDevices){
      hpavDevicesNames.add(device.name);
    }
    
    String securityID = "";
    var securityIDController = TextEditingController();
    var oldValueLength = 0;

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              S.of(context).addDeviceViaSecurityId,
                textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
            contentTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                if(localHpavDevices.length > 1)
                  Text(S.of(context).chooseNetwork, textAlign: TextAlign.start),
                if(localHpavDevices.length > 1)
                SizedBox(
                  height: 20,
                ),
                if(localHpavDevices.length > 1)
                  DropdownButtonFormField<String>(
                    value: selectedDevice.name, //TODO - use Network Name
                    dropdownColor: secondColor,
                    icon: Icon(DevoloIcons.devolo_UI_chevron_down),
                    isDense: true,
                    elevation: 8,
                    style: TextStyle(color: fontColorOnSecond, fontSize: dialogContentTextFontSize * fontSize.factor),
                    iconSize: 24 * fontSize.factor,
                    decoration: InputDecoration(
                      hoverColor: fontColorOnBackground.withOpacity(0.2),
                      contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      filled: true,
                      fillColor: fontColorOnBackground.withOpacity(0.2),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: fontColorOnBackground,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: fontColorOnBackground, //Colors.transparent,
                        ),
                      ),
                    ),
                    iconEnabledColor: fontColorOnBackground,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDevice = localHpavDevices.firstWhere((element) => element.name.contains(newValue!));
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return hpavDevicesNames.map((String value) {
                        return Text(value, textScaleFactor: fontSize.factor, style: TextStyle(color: fontColorOnBackground));
                      }).toList();
                    },
                    items: hpavDevicesNames.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, textScaleFactor: fontSize.factor),
                      );
                    }).toList(),
                  ),
                if(localHpavDevices.length > 1)
                SizedBox(
                  height: 20,
                ),
                Text(S.of(context).addDeviceViaSecurityIdDialogContent),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: securityIDController,
                  keyboardType: TextInputType.text,
                  enableInteractiveSelection: false,
                  maxLength: 19,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z-]")),
                  ],
                  style: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                  decoration: InputDecoration(
                    labelText: S.of(context).securityId,
                    labelStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                    hoverColor: fontColorOnBackground.withOpacity(0.2),
                    contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    filled: true,
                    fillColor: fontColorOnBackground.withOpacity(0.2),
                    errorStyle: TextStyle(color: devoloRed),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorOnBackground,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: fontColorOnBackground, //Colors.transparent,
                      ),
                    ),
                  ),
                  onChanged: (value) {

                    int setMinusAt = 4;
                    int setMinusAt2 = setMinusAt + 1;
                    switch ('-'.allMatches(value).length){
                      case 1:
                        setMinusAt = 9;
                        setMinusAt2 = setMinusAt + 1;
                        break;
                      case 2:
                        setMinusAt = 14;
                        setMinusAt2 = setMinusAt + 1;
                    }

                    if(value.length == setMinusAt2 && !(value.length < oldValueLength)){
                      securityIDController.text = value.replaceRange(value.length -1, value.length, "-" + value[value.length -1]);
                      securityIDController.selection = TextSelection.collapsed(offset: value.length + 1);
                      oldValueLength = value.length + 1;
                    }

                    else if(value.length == setMinusAt && !(value.length < oldValueLength)){
                      securityIDController.text = value + "-";
                      securityIDController.selection = TextSelection.collapsed(offset: value.length + 1);
                      oldValueLength = value.length + 1;
                    }

                    else
                      oldValueLength = value.length;

                    if(value.length >= 18){
                      AppBuilder.of(context)!.rebuild();
                    }

                    securityID = value;

                  },
                ),
              ]),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S.of(context).confirm,
                  style: TextStyle(fontSize: dialogContentTextFontSize, color: (securityID.length == 19) ? Colors.white : buttonDisabledForeground),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: (securityID.length != 19)
                    ? null
                    : () {
                      _loadingAddDeviceDialog(context,socket,selectedDevice, securityID);
                    },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return devoloGreen.withOpacity(hoverOpacity);
                        } else if (states.contains(MaterialState.pressed)) {
                          return devoloGreen.withOpacity(activeOpacity);
                        }
                        return (securityID.length == 19) ? devoloGreen : buttonDisabledBackground;
                      },
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )
                    )
                ),
              ),
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(fontSize: dialogContentTextFontSize),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: () {
                  Navigator.maybeOf(context)!.pop(false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.transparent;
                      } else if (states.contains(MaterialState.pressed)) {
                        return drawingColor;
                      }
                      return Colors.transparent;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return drawingColor.withOpacity(hoverOpacity);
                      } else if (states.contains(MaterialState.pressed)) {
                        return drawingColor;
                      }
                      return drawingColor;
                    },
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return BorderSide(color: drawingColor.withOpacity(hoverOpacity), width: 2.0);
                      } else if (states.contains(MaterialState.pressed)) {
                        return BorderSide(color: drawingColor.withOpacity(activeOpacity), width: 2.0);
                      }
                      return BorderSide(color: drawingColor, width: 2.0);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }

  //!!! add manually confirm/cancel buttons
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
            ),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
            contentTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(S.of(context).theCreatedSupportInformationCanNowBeSentToDevolo,
                    textScaleFactor: fontSize.factor,),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: fontColorOnBackground),
                        decoration: InputDecoration(
                          labelText: S.of(context).processNumber,
                          labelStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                          hoverColor: fontColorOnBackground.withOpacity(0.2),
                          contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          filled: true,
                          fillColor: fontColorOnBackground.withOpacity(0.2),
                          errorStyle: TextStyle(color: devoloRed),
                          //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: fontColorOnBackground,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: fontColorOnBackground, //Colors.transparent,
                              //width: 2.0,
                            ),
                          ),
                          //labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.amberAccent : Colors.blue),
                        ),
                        onChanged: (value) => (_processNr = value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S.of(context).pleaseEnterProcessingNumber;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: fontColorOnBackground),
                        decoration: InputDecoration(
                          labelText: S.of(context).yourName,
                          labelStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                          hoverColor: fontColorOnBackground.withOpacity(0.2),
                          contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          filled: true,
                          fillColor: fontColorOnBackground.withOpacity(0.2),
                          errorStyle: TextStyle(color: devoloRed),
                          //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: fontColorOnBackground,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: fontColorOnBackground, //Colors.transparent,
                              //width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (value) => (_name = value),
                        validator: (value) {
                          if (value!.isEmpty) {
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
                        style: TextStyle(color: fontColorOnBackground),
                        decoration: InputDecoration(
                          labelText: S.of(context).yourEmailaddress,
                          labelStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
                          counterStyle: TextStyle(color: fontColorOnBackground),
                          hoverColor: fontColorOnBackground.withOpacity(0.2),
                          contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          filled: true,
                          fillColor: fontColorOnBackground.withOpacity(0.2),
                          errorStyle: TextStyle(color: devoloRed),
                          //myFocusNode.hasFocus ? secondColor.withOpacity(0.2):Colors.transparent,//secondColor.withOpacity(0.2),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: fontColorOnBackground,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: fontColorOnBackground, //Colors.transparent,
                              //width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (value) => (_email = value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S.of(context).pleaseEnterYourMailAddress;
                          }

                          if (!value.contains('@')) {
                            return S.of(context).emailIsInvalid;
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S.of(context).confirm,
                  style: TextStyle(fontSize: dialogContentTextFontSize, color: Colors.white),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    logger.i("succes");
                    //ToDo send supportInfo
                    //socket.sendXML(messageType, mac: hitDevice.mac);
                    Navigator.maybeOf(context)!.pop();
                  }
                  else{
                    logger.i("failed");
                    //Navigator.maybeOf(context)!.pop();
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                        if (states.contains(MaterialState.hovered)) {
                          return devoloGreen.withOpacity(hoverOpacity);
                        } else if (states.contains(MaterialState.pressed)) {
                          return devoloGreen.withOpacity(activeOpacity);
                        }
                        return devoloGreen;
                      },
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )
                    )
                ),
              ),
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(fontSize: dialogContentTextFontSize),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: () {
                  Navigator.maybeOf(context)!.pop(false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.transparent;
                      } else if (states.contains(MaterialState.pressed)) {
                        return drawingColor;
                      }
                      return Colors.transparent;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return drawingColor.withOpacity(hoverOpacity);
                      } else if (states.contains(MaterialState.pressed)) {
                        return drawingColor;
                      }
                      return drawingColor;
                    },
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return BorderSide(color: drawingColor.withOpacity(hoverOpacity), width: 2.0);
                      } else if (states.contains(MaterialState.pressed)) {
                        return BorderSide(color: drawingColor.withOpacity(activeOpacity), width: 2.0);
                      }
                      return BorderSide(color: drawingColor, width: 2.0);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }

  // !!! closeButton is added manually
  void _loadingAddDeviceDialog (context, DataHand socket, Device selectedDevice, String securityID) async {

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(dialogTitlePadding),
            contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                SizedBox(height: 20,),
                Container(
                  child: CircularProgressIndicator(color: fontColorOnBackground),
                  height: 50.0,
                  width: 50.0,
                ),
                SizedBox(height: 20,),
                Text(
                  S.of(context).addDeviceLoading,
                  style: TextStyle(color: fontColorOnBackground),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(fontSize: dialogContentTextFontSize),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: () {
                  socket.sendXML("AddRemoteAdapterCancel");
                  Navigator.maybeOf(context)!.pop(false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.transparent;
                      } else if (states.contains(MaterialState.pressed)) {
                        return drawingColor;
                      }
                      return Colors.transparent;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return drawingColor.withOpacity(hoverOpacity);
                      } else if (states.contains(MaterialState.pressed)) {
                        return drawingColor;
                      }
                      return drawingColor;
                    },
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return BorderSide(color: drawingColor.withOpacity(hoverOpacity), width: 2.0);
                      } else if (states.contains(MaterialState.pressed)) {
                        return BorderSide(color: drawingColor.withOpacity(activeOpacity), width: 2.0);
                      }
                      return BorderSide(color: drawingColor, width: 2.0);
                    },
                  ),
                ),
              ),
            ],
          );
        });

    socket.sendXML('AddRemoteAdapter', mac: selectedDevice.mac, newValue: securityID, valueType: "securityID");
    response = await socket.receiveXML("AddRemoteAdapterStatus");

    if (response["result"] == "ok") {
        Navigator.pop(context, true);
    }

    else if(response["result"] == "timeout" || response["result"] == "read_pib_failed") {
      Navigator.pop(context, true);
      errorDialog(context, S
          .of(context)
          .addDeviceErrorTitle, S
          .of(context)
          .addDeviceErrorBody, fontSize);
    }

    else if(response["result"] == "device_not_found"){
      Navigator.pop(context, true);
      errorDialog(context, S
          .of(context)
          .deviceNameErrorTitle, S
          .of(context)
          .deviceNotFoundDeviceName + "\n\n" + S
          .of(context)
          .deviceNotFoundHint, fontSize);
    }
  }

  // !!! closeButton is added manually
  void _loadingSupportDialog (context, socket) async {
    bool dialogIsOpen = true;
    bool actionSucessfull = true;

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: Container(
                    alignment: FractionalOffset.topRight,
                    child: GestureDetector(
                      child: Icon(DevoloIcons.devolo_UI_cancel,color: fontColorOnBackground),
                      onTap: (){
                        dialogIsOpen = false;
                        Navigator.pop(context);
                        },
                    ),
                  ),
                ),
              ],
            ),
            titlePadding: EdgeInsets.all(dialogTitlePadding),
            contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                if(actionSucessfull)
                  Container(
                  child: CircularProgressIndicator(color: fontColorOnBackground),
                  height: 50.0,
                  width: 50.0,
                  ),
                if(actionSucessfull)
                  SizedBox(height: 20,),
                if(actionSucessfull)
                  Text(
                    S.of(context).LoadCockpitSupportInformationsBody,
                    style: TextStyle(color: fontColorOnBackground),
                  ),
                if(!actionSucessfull)
                  Text(
                    S.of(context).supportInfoGenerateError,
                    style: TextStyle(color: fontColorOnBackground),
                  ),
              ],
            ),
            actions: <Widget>[],
          );
        });

    socket.sendXML('SupportInfoGenerate');
    response = await socket.receiveXML("SupportInfoGenerateStatus");
    //logger.i('Response: ' + response.toString());

    if (response["result"] == "ok") {
      if(dialogIsOpen){
        Navigator.pop(context, true);
      }

      _contactSupportAlert(context, socket, response["htmlfilename"], response["zipfilename"]);

    }

    else if(response["result"] == "failed" || response["status"] == "timeout"){
        actionSucessfull = false;
    }
  }

  void _contactSupportAlert(context, socket, htmlFileName, zipFileName) {

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Center(
                    child: Text(
                      S.of(context).cockpitSupportInformationsTitle,
                    )
                ),
              ],
            ),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize* fontSize.factor),
            titlePadding: EdgeInsets.all(dialogTitlePadding),
            contentTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize* fontSize.factor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Text(
                    S.of(context).cockpitSupportInformationsBody,
                    style: TextStyle(color: fontColorOnBackground),
                  ),
                ),
                SizedBox(height: 20,),
                TextButton(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(
                      DevoloIcons.ic_send_24px,
                      color: fontColorOnMain,
                      size: 24 * fontSize.factor,
                    ),
                    SizedBox(width: 4,),
                    Text(
                      S.of(context).sendToDevolo,
                      style: TextStyle(fontSize: dialogContentTextFontSize, color: fontColorOnMain),
                      textScaleFactor: fontSize.factor,
                    ),
                  ]),
                  onPressed: () {
                    _contactInfoAlert(context);
                    },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.hovered)) {
                                return devoloGreen.withOpacity(0.7);
                              } else if (states.contains(MaterialState.pressed)) {
                                return devoloGreen.withOpacity(0.33);
                              }
                              return devoloGreen;
                              },
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )
                      )
                  ),
                ),
                SizedBox(height: 20,),
                TextButton(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Icon(
                      Icons.open_in_browser,
                      color: fontColorOnMain,
                      size: 24 * fontSize.factor,
                    ),
                    SizedBox(width: 4,),
                    Text(
                      S.of(context).openSupportInformations,
                      style: TextStyle(fontSize: dialogContentTextFontSize, color: fontColorOnMain),
                      textScaleFactor: fontSize.factor,
                    ),
                  ]),
                  onPressed: () {
                    openFile(htmlFileName);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return devoloGreen.withOpacity(0.7);
                          } else if (states.contains(MaterialState.pressed)) {
                            return devoloGreen.withOpacity(0.33);
                          }
                          return devoloGreen;
                        },
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )
                      )
                  ),
                ),
                SizedBox(height: 20,),
                TextButton(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(
                      DevoloIcons.ic_archive_24px,
                      color: fontColorOnMain,
                      size: 24 * fontSize.factor,
                    ),
                    SizedBox(width: 4,),
                    Text(
                      S.of(context).saveSupportInformations,
                      style: TextStyle(fontSize: dialogContentTextFontSize, color: fontColorOnMain),
                      textScaleFactor: fontSize.factor,
                    ),
                  ]),
                  onPressed: () {
                    openFile(zipFileName);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return devoloGreen.withOpacity(0.7);
                          } else if (states.contains(MaterialState.pressed)) {
                            return devoloGreen.withOpacity(0.33);
                          }
                          return devoloGreen;
                        },
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )
                      )
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          );
        });
  }
}


