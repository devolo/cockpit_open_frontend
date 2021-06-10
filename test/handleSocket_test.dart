import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:test/test.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/mock-data/mock.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/compareFunctions.dart';
import 'package:xml/xml.dart';


void main() {

  group('Future<void> dataHandler(data) async',() {

    test('Given_emptyDataHandObject_When_callDataHandlerWithConfigMessage_Then_configIsSet',(){

      config["allow_data_collection"] = false;
      config["ignore_updates"] = true;
      config["windows_network_throttling_disabled"] = false;
      var dataHandler = DataHand(true);

      dataHandler.dataHandler(config2);

      expect(config["allow_data_collection"], true);
      expect(config["ignore_updates"], false);
      expect(config["windows_network_throttling_disabled"], true);

    });
  });

  //TODO Possible/Needed to test?
  group('void errorHandler(error, StackTrace trace)',() {

    test('test',() async {

      /*
      var dataHandler = DataHand();
      await Future.delayed(const Duration(seconds: 2), (){});
      dataHandler.doneHandler();

      expect(dataHandler.socket.isEmpty,true);
      */
    });
  });

  //TODO Possible/Needed to test?
  group('void doneHandler()',() {

    test('test',() async {

      /*
      var dataHandler = DataHand();
      await Future.delayed(const Duration(seconds: 2), (){});
      dataHandler.doneHandler();

      expect(dataHandler.socket.isEmpty,true);
      */
    });
  });

  group('void setNetworkList(NetworkList networkList)',() {

    test('Given_emptyDataHandObject_When_callSetNetworkListWithMockNetworkList_Then_networkListInDataHandObjectIsSet',(){

      //create networkList
      var networkList = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      networkList.addDevice(device1,0);
      networkList.addDevice(device2,0);
      networkList.addDevice(device3,0);

      var dataHandler = DataHand(true);

      dataHandler.setNetworkList(networkList);

      expect(compareNetworkList(networkList, dataHandler.getNetworkList()), true);

    });
  });

  group('NetworkList getNetworkList()',() {

    test('Given_DataHandObjectWithMockNetworkList_When_callGetNetworkList_Then_returnNetworkList',(){

      //create networkList
      var networkList = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      networkList.addDevice(device1,0);
      networkList.addDevice(device2,0);
      networkList.addDevice(device3,0);

      var dataHandler = DataHand(true);
      dataHandler.setNetworkList(networkList);

      expect(compareNetworkList(networkList, dataHandler.getNetworkList()), true);

    });
  });

  group('NetworkList getNetworkList()',() {

    test('Given_DataHandObjectWithMockNetworkList_When_callGetNetworkList_Then_returnNetworkList',(){

      //create networkList
      var networkList = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      networkList.addDevice(device1,0);
      networkList.addDevice(device2,0);
      networkList.addDevice(device3,0);

      var dataHandler = DataHand(true);
      dataHandler.setNetworkList(networkList);

      expect(compareNetworkList(networkList, dataHandler.getNetworkList()), true);

    });
  });

  group('Future<void> parseXML(String? rawData)',() {

    test('Given_emptyDataHandObject_When_callParseXMLWithNull_Then_noChangesOnDataHandObject', () {

      var network = new NetworkList();
      var dataHandler = DataHand(true);

      dataHandler.parseXML(null);

      expect(compareNetworkList(network, dataHandler.getNetworkList()), true);

    });

    test('Given_emptyDataHandObject_When_callParseXMLWithEmptyString_Then_noChangesOnDataHandObject', () {

      var network = new NetworkList();
      var dataHandler = DataHand(true);

      var emptyString = "";
      dataHandler.parseXML(emptyString);

      expect(compareNetworkList(network, dataHandler.getNetworkList()), true);

    });

    test('Given_emptyDataHandObject_When_callParseXMLWithConfigMessage_Then_setConfig', () {

      //set config with different values before
      config["allow_data_collection"] = false;
      config["ignore_updates"] = true;
      config["windows_network_throttling_disabled"] = false;
      var dataHandler = DataHand(true);

      dataHandler.parseXML(config1);

      expect(config["allow_data_collection"], true);
      expect(config["ignore_updates"], false);
      expect(config["windows_network_throttling_disabled"], true);
    });

    test('Given_DataHandObjectWithMockNetworklist_When_callParseXMLWithNetworkUpdateMessage_Then_setNetworkListInDataHandObject', () {

      //create mock networkList
      var network = new NetworkList();
      var mockDevice = new Device("String type", "String name", "String mac", "String ip", "String MT", "String serialno", "String version", "String versionDate", false, false, true, true, "selectedVDSL", ["ja","nein"], "modeVDSL");
      network.addDevice(mockDevice, 0);

      //create expected networkList
      var expectedNetwork = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      expectedNetwork.addDevice(device1,0);
      expectedNetwork.addDevice(device2,0);
      expectedNetwork.addDevice(device3,0);

      var dataHandler = DataHand(true);
      dataHandler.setNetworkList(network);

      dataHandler.parseXML(networkUpdate1);

      expect(compareNetworkList(dataHandler.getNetworkList(), expectedNetwork),true);

    });

    test('Given_DataHandObjectWithMockNetworklist_When_callParseXMLWithNetworkUpdateMessageANDConfigMessage_Then_setNetworkListInDataHandObjectANDConfig', () {

      //set config with different values before
      config["allow_data_collection"] = false;
      config["ignore_updates"] = true;
      config["windows_network_throttling_disabled"] = false;

      //create mock networkList
      var network = new NetworkList();
      var mockDevice = new Device("String type", "String name", "String mac", "String ip", "String MT", "String serialno", "String version", "String versionDate", false, false, true, true, "selectedVDSL", ["ja","nein"], "modeVDSL");
      network.addDevice(mockDevice, 0);

      //create expected networkList
      var expectedNetwork = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      expectedNetwork.addDevice(device1,0);
      expectedNetwork.addDevice(device2,0);
      expectedNetwork.addDevice(device3,0);

      var dataHandler = DataHand(true);
      dataHandler.setNetworkList(network);

      dataHandler.parseXML(networkUpdate1);
      dataHandler.parseXML(config1);

      expect(config["allow_data_collection"], true);
      expect(config["ignore_updates"], false);
      expect(config["windows_network_throttling_disabled"], true);

      expect(compareNetworkList(dataHandler.getNetworkList(), expectedNetwork),true);
    });

    //TODO
    test('FirmwareUpdateIndicationMessage as parameter',(){

    });

    //TODO
    test('FirmwareUpdateStatus as parameter',(){

    });

    test('Given_emptyDataHandObject_When_callParseXMLWithSetAdapterNameResponseANDIdentifyDeviceStatusResponse_Then_setXmlResponseANDXmlDebugResponseListANDXmlResponseMapInDataHandObject', () {

      var dataHandler = DataHand(true);

      //create expected XMLDocuments
      var xmlLengthChangeName = int.parse(changeNameResponse1.substring(7, 15), radix: 16);
      var xmlSingleDocChangeName = changeNameResponse1.substring(changeNameResponse1.indexOf('<?'), xmlLengthChangeName + 13);
      var xmlLengthIdentifyDevice = int.parse(identifyDeviceReponse1.substring(7, 15), radix: 16);
      var xmlSingleDocIdentifyDevice = identifyDeviceReponse1.substring(identifyDeviceReponse1.indexOf('<?'), xmlLengthIdentifyDevice + 13);

      dataHandler.parseXML(changeNameResponse1);
      dataHandler.parseXML(identifyDeviceReponse1);

      //convert XMLDocuments to String for comparing
      expect(dataHandler.xmlResponse.toString(), XmlDocument.parse(xmlSingleDocIdentifyDevice).toString());
      expect(dataHandler.xmlDebugResponseList.length, 4);
      expect(dataHandler.xmlDebugResponseList[1].toString(), XmlDocument.parse(xmlSingleDocIdentifyDevice).toString());
      expect(dataHandler.xmlDebugResponseList[3].toString(), XmlDocument.parse(xmlSingleDocChangeName).toString());
      expect(dataHandler.xmlResponseMap["SetAdapterNameStatus"].toString(), [XmlDocument.parse(xmlSingleDocChangeName)].toString());
      expect(dataHandler.xmlResponseMap["IdentifyDeviceStatus"].toString(), [XmlDocument.parse(xmlSingleDocIdentifyDevice)].toString());

    });
  });
}