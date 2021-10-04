/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

/* OLD Code

 // !!! closeButton is added manually
  void _loadingAddDeviceDialog(context, DataHand socket, Device selectedDevice, String securityID) async {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(dialogTitlePadding),
            contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                Container(
                  child: CircularProgressIndicator(color: fontColorOnBackground),
                  height: 50.0,
                  width: 50.0,
                ),
                SizedBox(height: 20,),
                Text(
                  S
                      .of(context)
                      .addDeviceLoading,
                  style: TextStyle(color: fontColorOnBackground),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S
                      .of(context)
                      .cancel,
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

    else if (response["result"] == "timeout" || response["result"] == "read_pib_failed") {
      Navigator.pop(context, true);
      errorDialog(context, S
          .of(context)
          .addDeviceErrorTitle, S
          .of(context)
          .addDeviceErrorBody, fontSize);
    }

    else if (response["result"] == "device_not_found") {
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
            content: StatefulBuilder( // You need this, notice the parameters below:
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
                                onPressed: () => _addRemoteDeviceDialog(context, socket),
                                child: Text(
                                    S
                                        .of(context)
                                        .addDeviceViaSecurityId, textScaleFactor: fontSize.factor,
                                    style: TextStyle(color: Colors.white)
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
                                                    image: AssetImage('assets/addDeviceImages/MagicWifi_step1.PNG'),
                                                    fit: BoxFit.scaleDown,
                                                  )),
                                              Expanded(
                                                  child: Image(
                                                    image: AssetImage('assets/addDeviceImages/MagicWifi_step2.PNG'),
                                                    fit: BoxFit.scaleDown,
                                                  )),
                                              Expanded(
                                                  child: Image(
                                                    image: AssetImage('assets/addDeviceImages/MagicWifi_step3.PNG'),
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
                                            image: AssetImage('assets/addDeviceImages/MagicWifi_step4.PNG'),
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
                                            image: AssetImage('assets/addDeviceImages/MagicWifi_step5.PNG'),
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
                                            image: AssetImage('assets/addDeviceImages/MagicWifi_step6.PNG'),
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
    for (Device device in localHpavDevices) {
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
              S
                  .of(context)
                  .addDeviceViaSecurityId,
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
            contentTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  if(localHpavDevices.length > 1)
                    Text(S
                        .of(context)
                        .chooseNetwork, textAlign: TextAlign.start),
                  if(localHpavDevices.length > 1)
                    SizedBox(
                      height: 20,
                    ),
                  if(localHpavDevices.length > 1)
                    DropdownButtonFormField<String>(
                      value: selectedDevice.name,
                      //TODO - use Network Name
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
                  Text(S
                      .of(context)
                      .addDeviceViaSecurityIdDialogContent),
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
                      labelText: S
                          .of(context)
                          .securityId,
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
                      switch ('-'
                          .allMatches(value)
                          .length) {
                        case 1:
                          setMinusAt = 9;
                          setMinusAt2 = setMinusAt + 1;
                          break;
                        case 2:
                          setMinusAt = 14;
                          setMinusAt2 = setMinusAt + 1;
                      }

                      if (value.length == setMinusAt2 && !(value.length < oldValueLength)) {
                        securityIDController.text = value.replaceRange(value.length - 1, value.length, "-" + value[value.length - 1]);
                        securityIDController.selection = TextSelection.collapsed(offset: value.length + 1);
                        oldValueLength = value.length + 1;
                      }

                      else if (value.length == setMinusAt && !(value.length < oldValueLength)) {
                        securityIDController.text = value + "-";
                        securityIDController.selection = TextSelection.collapsed(offset: value.length + 1);
                        oldValueLength = value.length + 1;
                      }

                      else
                        oldValueLength = value.length;

                      if (value.length >= 18) {
                        AppBuilder.of(context)!.rebuild();
                      }

                      securityID = value;
                    },
                  ),
                ]),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S
                      .of(context)
                      .confirm,
                  style: TextStyle(fontSize: dialogContentTextFontSize, color: (securityID.length == 19) ? Colors.white : buttonDisabledForeground),
                  textScaleFactor: fontSize.factor,
                ),
                onPressed: (securityID.length != 19)
                    ? null
                    : () {
                  _loadingAddDeviceDialog(context, socket, selectedDevice, securityID);
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
                  S
                      .of(context)
                      .cancel,
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

 */