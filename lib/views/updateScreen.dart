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
    var deviceList = Provider.of<DeviceList>(context);

    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        title: new Text("Updates"),
        centerTitle: true,
        backgroundColor: devoloBlue,
        shadowColor: Colors.transparent,
      ),
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch ,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  Text('aktuelle Version', style: TextStyle(color: Colors.white),),
                  Text('neue Version', style: TextStyle(color: Colors.white),),
                ],),
              SizedBox(
                height: 20,
              ),
              Expanded(
                //height: 350,
                child: ListView.separated(
                  //padding: const EdgeInsets.all(8),
                  itemCount: deviceList.getDeviceList().length,
                  itemBuilder: (BuildContext context, int index) {
                    var device = deviceList.getDeviceList()[index];
                    return ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.devices),
                      trailing: Icon(Icons.check_circle_outline,color: Colors.green,),
                      subtitle: Text('${device.type}'),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        SelectableText(device.name, style: TextStyle(fontWeight: FontWeight.bold),),
                          SelectableText('${device.version}'),
                          SelectableText('---'), //ToDo somehow get new FW version

                      ],),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: 100.0,
                height: 50.0,
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
                              content: Text("Cockpit Software auf dem neusten Stand."),
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
                              title: Text('Update'),
                              content: Text(response["status"] == 'downloaded_setup' ? 'Update bereit zur Installation' : response.toString()),
                              //ToDo Handle error [] if updating //'Geräte werden aktualisiert... '
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.check_circle_outline,
                                    size: 35,
                                    color: devoloBlue,
                                  ),//Text('Bestätigen'),
                                  tooltip: "Installieren",
                                  onPressed: () {
                                    // Critical things happening here
                                    socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'execute');
                                    Navigator.of(context).pop();
                                  },
                                ),
                                Spacer(),
                                IconButton(
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      size: 35,
                                      color: devoloBlue,
                                    ), //Text('Abbrechen'),
                                    tooltip: "Abbrechen",
                                    onPressed: () {
                                      // Cancel critical action
                                      socket.sendXML('UpdateResponse', valueType: 'action', newValue: 'skip');
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            );
                          });
                    },
                    child: Row(children: [
                      Icon(Icons.download_rounded),
                      Text(' Update Cockpit '),
                      if (socket.waitingResponse) const CircularProgressIndicator(),
                    ],)),
              ),],
          ),
        ),
      ),
    );
  }
}
