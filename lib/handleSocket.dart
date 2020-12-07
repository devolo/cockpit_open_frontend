import 'dart:io';  //only for non-web apps!!!
import 'dart:async';
import 'package:xml/xml.dart'  as xml;
import 'package:xml_parser/xml_parser.dart';
import 'deviceClass.dart';

Socket socket;
//String xmlData; //maybe final?
dynamic xmlLength;

void handleSocket() {
  Socket.connect("localhost", 24271).then((Socket sock) {
    socket = sock;
    socket.listen(dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false);
  }).catchError((Object e) {  // was AsyncError before ???
    print("Unable to connect: $e");
  });
  //Connect standard in to the socket
  stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
}

void dataHandler(data){
  String xmlData = new String.fromCharCodes(data).trim();
  //print(xmlData);
  parseXML(xmlData);
}

void errorHandler(error, StackTrace trace){
  print(error);
  return(error);
}

void doneHandler(){
  socket.destroy();
}

void parseXML(String xmlData) {
  /*final backendXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<!DOCTYPE boost_serialization>
<boost_serialization signature="serialization::archive" version="13">
<Message class_id="0" tracking_level="0" version="0">
        <MessageType>NetworkUpdate</MessageType>
        <LocalDeviceList class_id="1" tracking_level="0" version="0">
                <count>1</count>
                <item_version>0</item_version>
                <item class_id="2" tracking_level="0" version="0">
                        <type>Magic 2 LAN 1-1</type>
                        <name>devolo-340</name>
                        <network></network>
                        <version>7.8.5.47</version>
                        <date>2020-06-05</date>
                        <product>MT2999</product>
                        <serialno>1806154350000340</serialno>
                        <classes class_id="3" tracking_level="0" version="0">
                                <count>0</count>
                                <item_version>0</item_version>
                        </classes>
                        <states class_id="4" tracking_level="0" version="0">
                                <count>2</count>
                                <item_version>0</item_version>
                                <item class_id="5" tracking_level="0" version="0">
                                        <first>gateway</first>
                                        <second>38:10:D5:66:32:DE</second>
                                </item>
                                <item>
                                        <first>network_type</first>
                                        <second>powerline:ghn</second>
                                </item>
                        </states>
                        <actions class_id="6" tracking_level="0" version="0">
                                <count>3</count>
                                <item_version>0</item_version>
                                <item class_id="7" tracking_level="0" version="0">
                                        <first>identify_device</first>
                                        <second>
                                                <count>1</count>
                                                <item_version>0</item_version>
                                                <item>
                                                        <first>state</first>
                                                        <second>0</second>
                                                </item>
                                        </second>
                                </item>
                                <item>
                                        <first>vdsl_compat</first>
                                        <second>
                                                <count>2</count>
                                                <item_version>0</item_version>
                                                <item>
                                                        <first>state</first>
                                                        <second>mimo_vdsl17a</second>
                                                </item>
                                                <item>
                                                        <first>supported</first>
                                                        <second>mimo_vdsl17a siso_full siso_vdsl17a siso_vdsl35b mimo_full mimo_vdsl35b</second>
                                                </item>
                                        </second>
                                </item>
                                <item>
                                        <first>web_interface</first>
                                        <second>
                                                <count>1</count>
                                                <item_version>0</item_version>
                                                <item>
                                                        <first>url</first>
                                                        <second>http://192.168.178.139/</second>
                                                </item>
                                        </second>
                                </item>
                        </actions>
                        <macAddress>30:D3:2D:EE:8D:A1</macAddress>
                        <ipAddress>192.168.178.139</ipAddress>
                        <remotes class_id="8" tracking_level="0" version="0">
                                <count>2</count>
                                <item_version>0</item_version>
                                <item class_id="9" tracking_level="0" version="0">
                                        <type>Magic 1 WiFi 2-1</type>
                                        <name></name>
                                        <network></network>
                                        <version>5.4.0</version>
                                        <date></date>
                                        <product>MT3064</product>
                                        <serialno>1807255601000045</serialno>
                                        <classes>
                                                <count>1</count>
                                                <item_version>0</item_version>
                                                <item>wlan</item>
                                        </classes>
                                        <states>
                                                <count>1</count>
                                                <item_version>0</item_version>
                                                <item>
                                                        <first>network_type</first>
                                                        <second>powerline:ghn</second>
                                                </item>
                                        </states>
                                        <actions>
                                                <count>3</count>
                                                <item_version>0</item_version>
                                                <item>
                                                        <first>identify_device</first>
                                                        <second>
                                                                <count>1</count>
                                                                <item_version>0</item_version>
                                                                <item>
                                                                        <first>state</first>
                                                                        <second>0</second>
                                                                </item>
                                                        </second>
                                                </item>
                                                <item>
                                                        <first>vdsl_compat</first>
                                                        <second>
                                                                <count>2</count>
                                                                <item_version>0</item_version>
                                                                <item>
                                                                        <first>state</first>
                                                                        <second>siso_vdsl17a</second>
                                                                </item>
                                                                <item>
                                                                        <first>supported</first>
                                                                        <second>siso_vdsl17a siso_full siso_vdsl35b</second>
                                                                </item>
                                                        </second>
                                                </item>
                                                <item>
                                                        <first>web_interface</first>
                                                        <second>
                                                                <count>1</count>
                                                                <item_version>0</item_version>
                                                                <item>
                                                                        <first>url</first>
                                                                        <second>http://192.168.178.137/</second>
                                                                </item>
                                                        </second>
                                                </item>
                                        </actions>
                                        <macAddress>B8:BE:F4:00:08:B5</macAddress>
                                        <ipAddress>192.168.178.137</ipAddress>
                                </item>
                                <item>
                                        <type>Magic 1 WiFi 2-1</type>
                                        <name>AP-unten</name>
                                        <network></network>
                                        <version>5.6.0</version>
                                        <date>2020-06-26</date>
                                        <product>MT3064</product>
                                        <serialno>1807255601000215</serialno>
                                        <classes>
                                                <count>1</count>
                                                <item_version>0</item_version>
                                                <item>wlan</item>
                                        </classes>
                                        <states>
                                                <count>1</count>
                                                <item_version>0</item_version>
                                                <item>
                                                        <first>network_type</first>
                                                        <second>powerline:ghn</second>
                                                </item>
                                        </states>
                                        <actions>
                                                <count>3</count>
                                                <item_version>0</item_version>
                                                <item>
                                                        <first>identify_device</first>
                                                        <second>
                                                                <count>1</count>
                                                                <item_version>0</item_version>
                                                                <item>
                                                                        <first>state</first>
                                                                        <second>0</second>
                                                                </item>
                                                        </second>
                                                </item>
                                                <item>
                                                        <first>vdsl_compat</first>
                                                        <second>
                                                                <count>2</count>
                                                                <item_version>0</item_version>
                                                                <item>
                                                                        <first>state</first>
                                                                        <second>siso_vdsl17a</second>
                                                                </item>
                                                                <item>
                                                                        <first>supported</first>
                                                                        <second>siso_vdsl17a siso_full siso_vdsl35b</second>
                                                                </item>
                                                        </second>
                                                </item>
                                                <item>
                                                        <first>web_interface</first>
                                                        <second>
                                                                <count>1</count>
                                                                <item_version>0</item_version>
                                                                <item>
                                                                        <first>url</first>
                                                                        <second>http://192.168.178.136/</second>
                                                                </item>
                                                        </second>
                                                </item>
                                        </actions>
                                        <macAddress>B8:BE:F4:00:0C:07</macAddress>
                                        <ipAddress>192.168.178.136</ipAddress>
                                </item>
                        </remotes>
                        <dataRates class_id="10" tracking_level="0" version="0">
                                <count>6</count>
                                <item_version>0</item_version>
                                <item class_id="11" tracking_level="0" version="0">
                                        <first class_id="12" tracking_level="0" version="0">
                                                <first class_id="13" tracking_level="0" version="0">
                                                        <macAddress>30:D3:2D:EE:8D:A1</macAddress>
                                                </first>
                                                <second>
                                                        <macAddress>B8:BE:F4:00:08:B5</macAddress>
                                                </second>
                                        </first>
                                        <second class_id="14" tracking_level="0" version="0">
                                                <txRate>2.91306666666666672e+02</txRate>
                                                <rxRate>3.32906666666666638e+02</rxRate>
                                        </second>
                                </item>
                                <item>
                                        <first>
                                                <first>
                                                        <macAddress>30:D3:2D:EE:8D:A1</macAddress>
                                                </first>
                                                <second>
                                                        <macAddress>B8:BE:F4:00:0C:07</macAddress>
                                                </second>
                                        </first>
                                        <second>
                                                <txRate>1.66506666666666661e+02</txRate>
                                                <rxRate>1.96479999999999990e+02</rxRate>
                                        </second>
                                </item>
                                <item>
                                        <first>
                                                <first>
                                                        <macAddress>B8:BE:F4:00:08:B5</macAddress>
                                                </first>
                                                <second>
                                                        <macAddress>30:D3:2D:EE:8D:A1</macAddress>
                                                </second>
                                        </first>
                                        <second>
                                                <txRate>3.32906666666666638e+02</txRate>
                                                <rxRate>2.91306666666666672e+02</rxRate>
                                        </second>
                                </item>
                                <item>
                                        <first>
                                                <first>
                                                        <macAddress>B8:BE:F4:00:08:B5</macAddress>
                                                </first>
                                                <second>
                                                        <macAddress>B8:BE:F4:00:0C:07</macAddress>
                                                </second>
                                        </first>
                                        <second>
                                                <txRate>1.19786666666666662e+02</txRate>
                                                <rxRate>9.15199999999999960e+01</rxRate>
                                        </second>
                                </item>
                                <item>
                                        <first>
                                                <first>
                                                        <macAddress>B8:BE:F4:00:0C:07</macAddress>
                                                </first>
                                                <second>
                                                        <macAddress>30:D3:2D:EE:8D:A1</macAddress>
                                                </second>
                                        </first>
                                        <second>
                                                <txRate>1.96479999999999990e+02</txRate>
                                                <rxRate>1.66506666666666661e+02</rxRate>
                                        </second>
                                </item>
                                <item>
                                        <first>
                                                <first>
                                                        <macAddress>B8:BE:F4:00:0C:07</macAddress>
                                                </first>
                                                <second>
                                                        <macAddress>B8:BE:F4:00:08:B5</macAddress>
                                                </second>
                                        </first>
                                        <second>
                                                <txRate>9.15199999999999960e+01</txRate>
                                                <rxRate>1.19786666666666662e+02</rxRate>
                                        </second>
                                </item>
                        </dataRates>
                </item>
        </LocalDeviceList>
</Message>
</boost_serialization>''';*/
  print("Entering parseXML______________________________________________________________________");

  if(xmlData == null) {
    final emptyXml = '''<?xml version="1.0" ?>
<metadata>
</metadata>'''; //TODO Shitty workaround
    print("Empty String");
    final document = XmlDocument.fromString(emptyXml);
    //return document;
  }

  xmlLength = xmlData.substring(7,15); // cut the head in front of recieved xml (example: MSGSOCK00001f63) first 7 bytes-> Magicword; next 8 bytes -> message length
  xmlLength = int.parse(xmlLength, radix: 16);  // parse HexSting to int  //print("XmlLength: " + xmlLength.toString());
  xmlData = xmlData.substring(xmlData.indexOf('<?'), xmlLength+13); //why 13? I dont know -_(o.O)_-
  XmlDocument document = XmlDocument.fromString(xmlData);
  //final document = XmlDocument.parse(xmlData);

print(document);
  if(document.getElementWhere(name: 'LocalDeviceList') == null) {return;} //
    var item = document.getElementWhere(name: 'LocalDeviceList').getElementWhere(name: 'item',);
    Device device = Device.fromXML(item);
  print(device.type);
    for( var dev in device.remoteDevices){
      print(dev.type);
    }
  //return document;
}