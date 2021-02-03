
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:xml/xml.dart';

class DebugScreen extends StatefulWidget {
  DebugScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DebugScreenState createState() => _DebugScreenState(title: title);
}

class _DebugScreenState extends State<DebugScreen> {
  _DebugScreenState({this.title});

  final String title;

  String printResponseList(socket){
    String ret = "";
    for(var elem in socket.xmlResponseList) {
      if(elem.runtimeType == XmlDocument) {
        ret += elem.toXmlString(pretty: true);
        ret+= "\n";
      }else{
        ret += elem.toString();
      }
      ret+= "\n";
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<dataHand>(context);
    final deviceList = Provider.of<NetworkList>(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText('Config', style: TextStyle(fontSize: 20,),),
              SelectableText(config.toString()),
              SizedBox(height: 20,),

              SelectableText('XML-Response', style: TextStyle(fontSize: 20,),),
              Expanded(child: SelectableText(socket.xmlResponseList!= null? printResponseList(socket): "nothing send yet")),
              SizedBox(height: 20,),

              SelectableText('DeviceList', style: TextStyle(fontSize: 20,),),
              Expanded(child:SelectableText(deviceList.toRealString()),),

              SelectableText('DeviceListList', style: TextStyle(fontSize: 20,),),
              Expanded(
                child:SelectableText(deviceList.getNetworkList().toString()),
              ),


            ]),
      ),
    );
  }
}