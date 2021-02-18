import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';

class AddDeviceScreen extends StatefulWidget {
  AddDeviceScreen({Key key, this.title, NetworkList deviceList}) : super(key: key);

  final String title;
  dataHand model;

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState(title: title);
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  _AddDeviceScreenState({this.title});

  final String title;
  String _newPw;
  String _newTest;
  List<Image> optimizeImages = loadOptimizeImages();
  Image _currImage;
  int _index = 0;

  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    _currImage = optimizeImages.first;
    final socket = Provider.of<dataHand>(context);
    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text(S.of(context).help, style: TextStyle(color: fontColorLight), textScaleFactor: fontSizeFactor,),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(image: AssetImage('assets/addDevice1.png')),
                  Image(image: AssetImage('assets/addDevice2.png')),
                  Image(image: AssetImage('assets/addDevice3.png')),
                  Image(image: AssetImage('assets/addDevice4.png')),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SelectableText(
                S.of(context).addDeviceInstructionText,
                style: TextStyle(color: Colors.white),
                //textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: true),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  child: Text(S.of(context).openOptimization),
                  color: secondColor,
                  textColor: fontColorDark,
                  onPressed: () {
                    _optimiseAlert(context);
                  }),
              SizedBox(
                height: 20,
              ),
              // TextFormField(
              //   //TODO sendXml find out Device Mac connected to Internet + Password formfield (hidden)
              //   initialValue: _newTest,
              //   style: TextStyle(color: Colors.white),
              //   decoration: InputDecoration(labelText: 'Testing', labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.amberAccent : Colors.white)
              //       //helperText: 'Devicename',
              //       ),
              //   onChanged: (value) => (_newPw = value),
              //   validator: (value) {
              //     if (value.isEmpty) {
              //       return 'Bitte neues Passwort eintragen';
              //     }
              //     return null;
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _optimiseAlert(context) {
    //ToDo not working yet, switch _index and rebuild
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(child: Text(S.of(context).optimizationHelp, style: TextStyle(color: fontColorLight),)),
              backgroundColor: backgroundColor.withOpacity(0.9),
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              content: StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
                return
                  Stack(
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios, color: fontColorLight,),
                              onPressed: () {
                                print("back");
                                setState(() {
                                  if(_index > 0){
                                  _index--;
                                  _currImage = optimizeImages[_index];}
                                  else{return null;}
                                });
                              },
                            ),
                            Container(
                              child: _currImage,
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios, color: fontColorLight,),
                              onPressed: () {
                                print("forward");
                                setState(() {
                                  if(_index < optimizeImages.length-1){
                                  _index++;
                                  _currImage = optimizeImages[_index];}
                                  else{return null;}
                                });
                              },
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
