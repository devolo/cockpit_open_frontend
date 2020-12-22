import 'package:cockpit_devolo/handleSocket.dart';
import 'package:cockpit_devolo/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'deviceModel.dart';
import 'DrawOverview.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({Key key, this.title, dataHand model}) : super(key: key);

  final String title;
  //dataHand model;


  @override
  _UpdateScreenState createState() => _UpdateScreenState(title: title);
}

class _UpdateScreenState extends State<UpdateScreen> {
  _UpdateScreenState({this.title});

  final String title;
  bool _updating = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<dataHand>(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: devoloBlue,
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            if(_updating == true)
              const CircularProgressIndicator(),
            SizedBox(height: 50,),
            ButtonTheme(
              minWidth: 200.0,
              height: 100.0,
            child: RaisedButton(
              color: devoloBlue,
                textColor: Colors.white,
                onPressed: () {
                  _updating = true;
                  model.sendXML('UpdateCheck');
                  showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user doesn't need to tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Updating..'),
                          //content: Text('Bitte Aktion bestätigen. \n'+ model.xmlResponse.toString(),),
                          content: Text(model.recieveXML(model.xmlResponse)[0] == 'none'? 'Gerät auf dem neusten Stand.': 'Gerät wird aktuallisiert...'),
                          actions: <Widget>[
                            FlatButton(
                              child: Icon(Icons.check_circle_outline, size: 35,color: devoloBlue,),//Text('Bestätigen'),
                              onPressed: (){
                                // Critical things happening here
                                //model.sendXML(messageType, mac: mac);
                                setState(() {
                                  _updating = false;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Text('Update')
            ),),
            SizedBox(height: 20,),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
