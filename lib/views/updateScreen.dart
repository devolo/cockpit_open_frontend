import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'dart:ui' as ui;

class UpdateScreen extends StatefulWidget {
  UpdateScreen({Key key, this.title, NetworkList deviceList}) : super(key: key);

  final String title;

  int networkIndex = 0;

  @override
  _UpdateScreenState createState() => _UpdateScreenState(title: title);
}

class _UpdateScreenState extends State<UpdateScreen> {
  _UpdateScreenState({this.title});

  final String title;

  bool _loading = false;
  bool _loadingFW = false;
  DateTime _lastPoll = DateTime.now();

  final _scrollController = ScrollController();
  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    var _deviceList = Provider.of<NetworkList>(context);

    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text(
          S.of(context).updates,
          style: TextStyle(color: fontColorLight),
          textScaleFactor: fontSizeFactor,
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        shadowColor: Colors.transparent,
      ),
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                leading: Text(""), //Placeholder
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(flex: 2,child: Text(
                      S.of(context).name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: fontColorLight),
                      semanticsLabel: S.of(context).name,
                    ),),
                Expanded(flex: 2,child: Text(
                      S.of(context).currentVersion,
                      style: TextStyle(color: fontColorLight ),
                      semanticsLabel: S.of(context).currentVersion,
                    ),),
                Expanded(flex: 2,child: Text(
                      S.of(context).newVersion,
                      style: TextStyle(color: fontColorLight),
                      semanticsLabel: S.of(context).newVersion,
                    ),),
                  ],
                ),
                trailing: Text(
                  S.of(context).state,
                  style: TextStyle(color: fontColorLight),
                  semanticsLabel: S.of(context).state,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: 100.0,
                height: 50.0,
                child: RaisedButton(
                    color: secondColor,
                    textColor: fontColorDark,
                    onPressed: () async {
                      setState(() {
                        socket.sendXML('UpdateCheck');
                        _loading = socket.waitingResponse;
                      });

                      var response = await socket.recieveXML(["UpdateIndication", "FirmwareUpdateIndication"]);

                      setState(() {
                        _loading = socket.waitingResponse; //ToDo set state?
                      });

                      response["status"] == 'none'
                          ? showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user doesn't need to tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(S.of(context).update, style: TextStyle(color: fontColorLight,),),
                              backgroundColor: backgroundColor.withOpacity(0.9),
                              contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white),
                              content: Text(S.of(context).cockpitSoftwareIsUpToDate, textScaleFactor: fontSizeFactor,),
                              actions: <Widget>[
                                FlatButton(
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    size: 35,
                                    color: fontColorLight,
                                  ), //Text('Bestätigen'),
                                  onPressed: () {
                                    Navigator.maybeOf(context).pop();
                                  },
                                ),
                              ],
                            );
                          })
                          : response["status"] == 'downloaded_setup'
                          ? showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user doesn't need to tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(S.of(context).update),
                              backgroundColor: backgroundColor.withOpacity(0.9),
                              content: Text(response["status"] == 'downloaded_setup' ? S.of(context).updateReadyToInstall : response.toString()),
                              //ToDo Handle error [] if updating 'Geräte werden aktualisiert... '
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.check_circle_outline,
                                    size: 35,
                                    color: fontColorLight,
                                  ), //Text('Bestätigen'),
                                  tooltip: S.of(context).install,
                                  onPressed: () {
                                    // Critical things happening here
                                    socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
                                    Navigator.maybeOf(context).pop();
                                  },
                                ),
                                Spacer(),
                                IconButton(
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      size: 35,
                                      color: fontColorLight,
                                    ), //Text('Abbrechen'),
                                    tooltip: S.of(context).cancel,
                                    onPressed: () {
                                      // Cancel critical action
                                      socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'skip');
                                      Navigator.maybeOf(context).pop();
                                    }),
                                // IconButton(
                                //     icon: Icon(
                                //       Icons.cancel_outlined,
                                //       size: 35,
                                //       color: Colors.grey,
                                //     ), //Text('Abbrechen'),
                                //     tooltip: "Abbrechen",
                                //     onPressed: () {
                                //       // Cancel critical action
                                //       Navigator.of(context).pop();
                                //     }),
                              ],
                            );
                          })
                          : _lastPoll = DateTime.now();
                    },
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.refresh),
                        Text(S.of(context).checkUpdates),
                        if (_loading)
                          CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(fontColorDark),
                          ),
                        Spacer(),
                        //Text(""),
                        Text(_lastPoll.toString().substring(0, _lastPoll.toString().indexOf("."))),
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.speed_rounded,color: Colors.white,),
                title: Text("Cockpit Software"),
                tileColor: secondColor,
                trailing:
                _deviceList.CockpitUpdate == false?
                IconButton(
                  icon: Icon(Icons.check_circle_outline,
                    color: Colors.green,),
                  iconSize: 24 * fontSizeFactor,
                  // tooltip: "already uptodate",
                )
                :
                IconButton(
                    icon: Icon(Icons.download_rounded,color: mainColor,),
                    iconSize: 24 * fontSizeFactor,
                    onPressed: () async {
                      print("Updating Cockpit...");
                      setState(() {
                        socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
                        //_loadingFW = socket.waitingResponse;
                      });

                      var response = await socket.recieveXML([]);
                      print('Response: ' + response.toString());
                    }),
              ),
              Divider(),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  //height: 350,
                  child: ListView.separated(
                    //padding: const EdgeInsets.all(8),
                    controller: _scrollController,
                    itemCount: _deviceList.getAllDevices().length,//_deviceList.getDeviceList().length,
                    itemBuilder: (BuildContext context, int index) {
                      var device = _deviceList.getAllDevices()[index];
                      return new Column(
                        children: [
                          ListTile(
                            onTap: () => _handleTap(device),
                            tileColor: secondColor,
                            leading: RawImage(
                              image: getIconForDeviceType(device.typeEnum),
                              height: 35,
                            ),
                            //Icon(Icons.devices),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      device.name,
                                      style: TextStyle(fontWeight: FontWeight.bold, color: fontColorDark),
                                    )),
                                //Spacer(flex: 1,),
                                Expanded(
                                  flex: 2,
                                  child: SelectableText(
                                    '${device.version}',
                                    style: TextStyle(color: fontColorDark),
                                  ),
                                ),
                                //Spacer(flex: 2,),
                                Expanded(
                                  flex: 2,
                                  child: SelectableText(
                                    '---',
                                    style: TextStyle(color: fontColorDark),
                                  ),
                                ), //ToDo somehow get new FW version
                                //Spacer(flex: 2,),
                              ],
                            ),
                            subtitle: Text(
                              '${device.type}',
                              style: TextStyle(color: fontColorDark),
                            ),
                            trailing: device.updateStateInt != 0
                                ? Text(
                                    device.updateStateInt.toInt().toString() + " %",
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  )
                                :  _deviceList.getUpdateList().contains(device.mac)
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.download_rounded,
                                          color: mainColor,
                                        ),
                                        iconSize: 24 * fontSizeFactor,
                                        onPressed: () async {
                                          print("Updating ${device.mac}");
                                          setState(() {
                                            socket.sendXML('FirmwareUpdateResponse', newValue: device.mac);
                                            _loadingFW = socket.waitingResponse;
                                          });

                                          var response = await socket.recieveXML([]);
                                          print('Response: ' + response.toString());
                                        })
                                    : IconButton(
                                        icon: Icon(Icons.check_circle_outline,
                                        color: Colors.green,),
                                        iconSize: 24 * fontSizeFactor,
                                        // tooltip: "already Uptodate",
                                      ),
                          ),
                          device.updateStateInt != 0
                              ? LinearProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                                  minHeight: 5,
                                  backgroundColor: secondColor,
                                  value: device.updateStateInt * 0.01,
                                )
                              : LinearProgressIndicator(
                                  backgroundColor: secondColor,
                                  value: 0,
                                ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(Device dev) {
    print('entering dialog....');
    int index = 0;
    Device hitDevice;
    String hitDeviceName;
    String hitDeviceType;
    String hitDeviceSN;
    String hitDeviceMT;
    String hitDeviceVersion;
    String hitDeviceVersionDate;
    String hitDeviceIp;
    String hitDeviceMac;
    bool hitDeviceAtr;
    bool hitDeviceisLocal;

    hitDevice = dev;
    hitDeviceName = dev.name;
    hitDeviceType = dev.type;
    hitDeviceSN = dev.serialno;
    hitDeviceMT = dev.MT;
    hitDeviceVersion = dev.version;
    hitDeviceVersionDate = dev.version_date;
    hitDeviceIp = dev.ip;
    hitDeviceMac = dev.mac;
    hitDeviceAtr = dev.attachedToRouter;
    hitDeviceisLocal = dev.isLocalDevice;

    String _newName = hitDeviceName;

    final socket = Provider.of<dataHand>(context, listen: false);

    showDialog<void>(
      context: context,
      barrierDismissible: true, // user doesn't need to tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: SelectableText(S.of(context).deviceinfo, textScaleFactor: fontSizeFactor,),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 23,),
          backgroundColor: backgroundColor.withOpacity(0.9),
          contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 17 * fontSizeFactor),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Table(
                  defaultColumnWidth: FixedColumnWidth(250.0 * fontSizeFactor),
                  children: [
                    TableRow(children: [
                      SelectableText('Name: '),
                      TextFormField(
                        initialValue: _newName,
                        style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              //labelText: 'Testing',
                              labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.amberAccent : Colors.white),
                              focusColor: Colors.white,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            // border: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.red),
                            // ),
                              //helperText: 'Devicename',
                              ),
                        onChanged: (value) => (_newName = value),
                        validator: (value) {
                          if (value.isEmpty) {
                            return S.of(context).pleaseEnterDevicename;
                          }
                          return null;
                        },
                      ),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).type),
                      SelectableText(hitDeviceType),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).serialNumber),
                      SelectableText(hitDeviceSN),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).mtnumber),
                      SelectableText(hitDeviceMT.substring(2)),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).version),
                      SelectableText('${hitDeviceVersion} (${hitDeviceVersionDate})'),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).ipaddress),
                      SelectableText(hitDeviceIp),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).macaddress),
                      SelectableText(hitDeviceMac),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).attachedToRouter),
                      SelectableText(hitDeviceAtr.toString()),
                    ]),
                    TableRow(children: [
                      SelectableText(S.of(context).isLocalDevice ),
                      SelectableText(hitDeviceisLocal.toString()),
                    ]),
                  ],
                ),
                //Text('Rates: ' +hitDeviceRx),
                Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.public,
                            color: fontColorLight,
                          ),
                          //tooltip: S.of(context).launchWebinterface,
                          hoverColor: fontColorLight.withAlpha(50),
                          iconSize: 24.0 *fontSizeFactor,
                          onPressed: () => launchURL(hitDeviceIp),
                        ),
                        Text(S.of(context).launchWebinterface, style: TextStyle(fontSize: 14, color: fontColorLight ), textScaleFactor: fontSizeFactor, textAlign: TextAlign.center,)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.lightbulb,
                              color: fontColorLight,
                            ),
                            //tooltip: S.of(context).identifyDevice,
                            hoverColor: fontColorLight.withAlpha(50),
                            iconSize: 24.0 *fontSizeFactor,
                            onPressed: () => socket.sendXML('IdentifyDevice', mac: hitDeviceMac)
                        ),
                        Text(S.of(context).identifyDevice, style: TextStyle(fontSize: 14, color: fontColorLight ), textScaleFactor: fontSizeFactor, textAlign: TextAlign.center,)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.find_in_page,
                              color: fontColorLight,
                            ),
                            //tooltip: S.of(context).showManual,
                            iconSize: 24.0 *fontSizeFactor,
                            hoverColor: fontColorLight.withAlpha(50),
                            onPressed: () async {
                              socket.sendXML('GetManual', newValue: hitDeviceMT, valueType: 'product', newValue2: 'de', valueType2: 'language');
                              var response = await socket.recieveXML(["GetManualResponse"]);
                              setState(() {
                                openFile(response['filename']);
                              });
                            }),
                        Text(S.of(context).showManual, style: TextStyle(fontSize: 14, color: fontColorLight ), textScaleFactor: fontSizeFactor, textAlign: TextAlign.center,)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.upload_file,
                            color: fontColorLight,
                            semanticLabel: "update",
                          ),
                          //tooltip: S.of(context).factoryReset,
                          hoverColor: fontColorLight.withAlpha(50),
                          iconSize: 24.0 *fontSizeFactor,
                          onPressed: () => _handleCriticalActions(context, socket, 'ResetAdapterToFactoryDefaults', hitDevice),
                        ),
                        Text(S.of(context).factoryReset, style: TextStyle(fontSize: 14, color: fontColorLight ), textScaleFactor: fontSizeFactor, textAlign: TextAlign.center,)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: fontColorLight,
                          ),
                          //tooltip: S.of(context).deleteDevice,
                          hoverColor: fontColorLight.withAlpha(50),
                          iconSize: 24.0 *fontSizeFactor,
                          onPressed: () => _handleCriticalActions(context, socket, 'RemoveAdapter', hitDevice),
                        ),
                        Text(S.of(context).deleteDevice, style: TextStyle(fontSize: 14, color: fontColorLight ), textScaleFactor: fontSizeFactor, textAlign: TextAlign.center,)
                      ],
                    ), //ToDo Delete Device see wiki
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: fontColorLight,
              ), //Text('Bestätigen'),
              tooltip: S.of(context).confirm,
              iconSize: 35.0 * fontSizeFactor,
              onPressed: () {
                // Critical things happening here
                socket.sendXML('SetAdapterName', mac: hitDeviceMac, newValue: _newName, valueType: 'name');
                Navigator.maybeOf(context).pop();
              },
            ),
          ],
        );
      },
    );
    index++;
  }

  void _handleCriticalActions(context, socket, messageType, Device hitDevice) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(messageType),
            backgroundColor: backgroundColor.withOpacity(0.9),
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18),
            content: hitDevice.attachedToRouter ? Text(S.of(context).pleaseConfirmActionAttentionYourRouterIsConnectedToThis) : Text(S.of(context).pleaseConfirmAction),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: fontColorLight,
                ), //Text('Bestätigen'),
                iconSize: 35 * fontSizeFactor,
                tooltip: S.of(context).confirm,
                onPressed: () {
                  // Critical things happening here
                  socket.sendXML(messageType, mac: hitDevice.mac);
                  Navigator.maybeOf(context).pop();
                },
              ),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: fontColorLight,
                  ), //Text('Abbrechen'),
                  iconSize: 35 * fontSizeFactor,
                  tooltip: S.of(context).cancel,
                  onPressed: () {
                    // Cancel critical action
                    Navigator.maybeOf(context).pop();
                  }),
            ],
          );
        });
  }
}
