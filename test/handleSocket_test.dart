import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:test/test.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/mock-data/mock.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/compareFunctions.dart';


void main() {
  //parseXML

  //null input or ""
  //testing different xml messages (existing one and no existing)

  // what is the general outpur?
  // null -> return

  group('parseXML',() {
    test('parseXML - null input', () {

      //compare two objects directly -> does not work | workaround would be to implement a function in the class that does compare two objects.
      // Than you would only need in the expect Method to check if the compare method returns true

      var network = new NetworkList();

      var dataHandler = DataHand(true);
      dataHandler.parseXML(null);

      expect(compareNetworkList(network, dataHandler.getDeviceList()), true);

      //check manually if every attribute of the objects are equal with multiple expects
      // Than you would only need in the expect Method to check if the compare method returns true

    });

    test('parseXML - empty string input', () {

      var network = new NetworkList();

      var dataHandler = DataHand(true);
      var emptyString = "";
      dataHandler.parseXML(emptyString);



    });

    //check for config | is it still a unit test?
    test('parseXML - config input', () {

      var network = new NetworkList();

      var dataHandler = DataHand(true);
      dataHandler.parseXML(config1);

      expect(config["allow_data_collection"], true);
      expect(config["ignore_updates"], false);
      expect(config["windows_network_throttling_disabled"], true);
    });

    // delete old network list and creates new one
    test('parseXML - networkupdate input', () {


      /*
      var network = new NetworkList();
      var oldDevice = new Device("String type", "String name", "String mac", "String ip", "String MT", "String serialno", "String version", "String versionDate", false, false, true, true, "selectedVDSL", ["ja","nein"], "modeVDSL");
      network.addDevice(oldDevice, 0);

      var expectedNetwork = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round())
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round())

      device2.speeds = {B8:BE:F4:31:96:8B: Instance of 'DataratePair', B8:BE:F4:31:96:AF: Instance of 'DataratePair'};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");


      var dataHandler = DataHand(true);
      dataHandler.setDeviceList(network);

      dataHandler.parseXML(networkUpdate1);
*/

    });

    test('parseXML - config and networkupdate input', () {

    });

    test('parseXML - unknwown input', () {

      //xmlDebugResponse List check
      //xmlResponseMap
    });
  });
}