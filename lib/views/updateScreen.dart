import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({Key key, this.title, DeviceList deviceList}) : super(key: key);

  final String title;

  //dataHand model;

  @override
  _UpdateScreenState createState() => _UpdateScreenState(title: title);
}

class _UpdateScreenState extends State<UpdateScreen> {
  _UpdateScreenState({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text("Updates"),
        centerTitle: true,
        backgroundColor: devoloBlue,
        shadowColor: Colors.transparent,
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            if (socket.waitingResponse) const CircularProgressIndicator(),
            SizedBox(
              height: 50,
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 100.0,
              child: RaisedButton(
                  color: devoloBlue,
                  textColor: Colors.white,
                  onPressed: () async {
                    setState(() {
                      socket.sendXML('UpdateCheck');
                    });

                    var response = await socket.recieveXML();
                    print('Response: ' + response.toString());

                    response["status"] == 'none'
                        ? showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user doesn't need to tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Update'),
                                content: Text("Geräte auf dem neusten Stand."),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      size: 35,
                                      color: devoloBlue,
                                    ), //Text('Bestätigen'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            })
                        : showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user doesn't need to tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Updating'),
                                content:
                                    Text(response["status"] == 'downloaded_setup' ? 'Updates bereit zur installation' : response.toString()), //ToDo Handle error [] if updating //'Geräte werden aktualisiert... '
                                actions: <Widget>[
                                  FlatButton(
                                    child: Icon(Icons.check_circle_outline, size: 35,color: devoloBlue,),//Text('Bestätigen'),
                                    onPressed: (){
                                      // Critical things happening here
                                      socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Spacer(),
                                  FlatButton(
                                      child: Icon(Icons.cancel_outlined, size: 35,color: devoloBlue,),//Text('Abbrechen'),
                                      onPressed: (){
                                        // Cancel critical action
                                        socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'skip');
                                        Navigator.of(context).pop();
                                      }
                                  ),
                                ],
                              );
                            });
                  },
                  child: Text('Update')),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
