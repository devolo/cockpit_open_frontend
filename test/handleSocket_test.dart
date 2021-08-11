/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:async';

import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:test/test.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/mock-data/mock.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
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
      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1]);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0]);
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
      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1]);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57//",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0]);
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
      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1]);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0]);
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
      var mockDevice = new Device("String type","powerline:ghn", "String name", "String mac", "String ip", "String MT", "String serialno", "String version", "String versionDate", false, false, true, "http://192.168.1.57/", true, "selectedVDSL", ["ja","nein"], "modeVDSL",[0,0],[1,0],[1,1]);
      network.addDevice(mockDevice, 0);

      //create expected networkList
      var expectedNetwork = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1]);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0]);
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
      var mockDevice = new Device("String type","powerline:ghn", "String name", "String mac", "String ip", "String MT", "String serialno", "String version", "String versionDate", false, false, true, "http://192.168.1.57/", true, "selectedVDSL", ["ja","nein"], "modeVDSL",[0,0],[1,0],[1,1]);


      //create expected networkList
      var expectedNetwork = new NetworkList();
      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1]);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0]);
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

    test('Given_DataHandObjectWithNetworklist_When_callParseXMLWithFirmwareUpdateIndicationMessage_Then_setXmlResponseANDXmlDebugResponseListANDXmlResponseMapANDUpdateList',(){

      var dataHandler = DataHand(true);
      dataHandler.parseXML(networkUpdate1);

      //create expected XMLDocuments
      var xmlLength = int.parse(firmwareUpdateIndication1WithMGSOCK.substring(7, 15), radix: 16);
      var xmlSingleDoc = firmwareUpdateIndication1WithMGSOCK.substring(firmwareUpdateIndication1WithMGSOCK.indexOf('<?'), xmlLength + 13);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF"];

      dataHandler.parseXML(firmwareUpdateIndication1WithMGSOCK);

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);
      //convert XMLDocuments to String for comparing
      expect(dataHandler.xmlDebugResponseList.length, 2);
      expect(dataHandler.xmlDebugResponseList[1].toString(), XmlDocument.parse(xmlSingleDoc).toString());
      expect(dataHandler.xmlResponseMap["FirmwareUpdateIndication"].toString(), [XmlDocument.parse(xmlSingleDoc)].toString());

    });

    test('Given_DataHandObjectWithNetworklist_When_callParseXMLWithFirmwareUpdateStatusMessage_Then_setXmlResponseANDXmlDebugResponseListANDXmlResponseMapANDUpdateList',(){

      var dataHandler = DataHand(true);

      var oldUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);
      dataHandler.parseXML(networkUpdate1);

      //create expected XMLDocuments
      var xmlLength = int.parse(firmwareUpdateStatus1WithMGSOCK.substring(7, 15), radix: 16);
      var xmlSingleDoc = firmwareUpdateStatus1WithMGSOCK.substring(firmwareUpdateStatus1WithMGSOCK.indexOf('<?'), xmlLength + 13);
      var expectedUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];


      dataHandler.parseXML(firmwareUpdateStatus1WithMGSOCK);

      Device device1 = dataHandler.getNetworkList().getDeviceList().where((element) => element.mac == "B8:BE:F4:31:96:AF").first;
      expect(device1.updateState, "80");

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

      //convert XMLDocuments to String for comparing
      expect(dataHandler.xmlDebugResponseList.length, 2);
      expect(dataHandler.xmlDebugResponseList[1].toString(), XmlDocument.parse(xmlSingleDoc).toString());
      expect(dataHandler.xmlResponseMap["FirmwareUpdateStatus"].toString(), [XmlDocument.parse(xmlSingleDoc)].toString());

    });

    test('Given_DataHandObject_When_callParseXMLWithUpdateIndicationMessage_Then_XmlDebugResponseListANDXmlResponseMapANDCockpitUpdateVariable',() async{

      var dataHandler = DataHand(true);

      //create expected XMLDocuments
      var xmlLength = int.parse(updateIndication1WithMGSOCK.substring(7, 15), radix: 16);
      var xmlSingleDoc = updateIndication1WithMGSOCK.substring(updateIndication1WithMGSOCK.indexOf('<?'), xmlLength + 13);

      await dataHandler.parseXML(updateIndication1WithMGSOCK);

      expect(dataHandler.getNetworkList().cockpitUpdate, true);

      //convert XMLDocuments to String for comparing
      expect(dataHandler.xmlDebugResponseList.length, 2);
      expect(dataHandler.xmlDebugResponseList[1].toString(), XmlDocument.parse(xmlSingleDoc).toString());
      expect(dataHandler.xmlResponseMap["UpdateIndication"].toString(), [XmlDocument.parse(xmlSingleDoc)].toString());

    });

    test('Given_emptyDataHandObject_When_callParseXMLWithSetAdapterNameResponseANDIdentifyDeviceStatusResponse_Then_setXmlResponseANDXmlDebugResponseListANDXmlResponseMapInDataHandObject', () {

      var dataHandler = DataHand(true);

      //create expected XMLDocuments
      var xmlLengthChangeName = int.parse(changeNameResponse1.substring(7, 15), radix: 16);
      var xmlSingleDocChangeName = changeNameResponse1.substring(changeNameResponse1.indexOf('<?'), xmlLengthChangeName + 13);
      var xmlLengthIdentifyDevice = int.parse(identifyDeviceResponse1.substring(7, 15), radix: 16);
      var xmlSingleDocIdentifyDevice = identifyDeviceResponse1.substring(identifyDeviceResponse1.indexOf('<?'), xmlLengthIdentifyDevice + 13);

      dataHandler.parseXML(changeNameResponse1);
      dataHandler.parseXML(identifyDeviceResponse1);

      //convert XMLDocuments to String for comparing
      expect(dataHandler.xmlDebugResponseList.length, 4);
      expect(dataHandler.xmlDebugResponseList[1].toString(), XmlDocument.parse(xmlSingleDocIdentifyDevice).toString());
      expect(dataHandler.xmlDebugResponseList[3].toString(), XmlDocument.parse(xmlSingleDocChangeName).toString());
      expect(dataHandler.xmlResponseMap["SetAdapterNameStatus"].toString(), [XmlDocument.parse(xmlSingleDocChangeName)].toString());
      expect(dataHandler.xmlResponseMap["IdentifyDeviceStatus"].toString(), [XmlDocument.parse(xmlSingleDocIdentifyDevice)].toString());

    });
  });

  //TODO Possible to test?
  group('void sendXML',() {

    test('test',() async {

    });
  });

  group('Future<Map<String, dynamic>?> receiveXML(String wantedMessageTypes)',() {

    //simple check for all possible if else cases --------------------------------------------------

    test('Given__When_callReceiveXMLWithGetManualResponse_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['filename'] = 'manual-de.pdf';

      dataHandler.xmlResponseMap['GetManualResponse'] = [XmlDocument.parse(getManualResponse1)];

      var response = await dataHandler.receiveXML('GetManualResponse');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithSetAdapterNameStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['result'] = 'ok';

      dataHandler.xmlResponseMap['SetAdapterNameStatus'] = [XmlDocument.parse(setAdapterNameStatus1)];

      var response = await dataHandler.receiveXML('SetAdapterNameStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithUpdateIndication_Then_returnResponseAndSetCockpitUpdate',() async {

      var dataHandler = DataHand(true);
      var network = new NetworkList();
      dataHandler.setNetworkList(network);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['messageType'] = 'UpdateIndication';
      expectedResponse['status'] = 'downloaded_setup';
      expectedResponse['commandline'] = 'setuplauncher.exe';
      expectedResponse['workdir'] = 'testWorkDir';

      dataHandler.xmlResponseMap['UpdateIndication'] = [XmlDocument.parse(updateIndication1)];

      var response = await dataHandler.receiveXML('UpdateIndication');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

      expect(dataHandler.getNetworkList().cockpitUpdate,false);

    });

    test('Given__When_callReceiveXMLWithFirmwareUpdateIndication_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['macAddress'] = 'B8:BE:F4:31:96:AF';

      dataHandler.xmlResponseMap['FirmwareUpdateIndication'] = [XmlDocument.parse(firmwareUpdateIndication1)];

      var response = await dataHandler.receiveXML('FirmwareUpdateIndication');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithFirmwareUpdateStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['failed'] = ['B8:BE:F4:31:96:8B'];
      expectedResponse['status'] = 'complete';

      dataHandler.xmlResponseMap['FirmwareUpdateStatus'] = [XmlDocument.parse(firmwareUpdateStatus3)];

      var response = await dataHandler.receiveXML('FirmwareUpdateStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithSupportInfoGenerateStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['zipfilename'] = 'support.zip';
      expectedResponse['status'] = 'complete';
      expectedResponse['htmlfilename'] = 'support.html';
      expectedResponse['result'] = 'ok';

      dataHandler.xmlResponseMap['SupportInfoGenerateStatus'] = [XmlDocument.parse(supportInfoGenerateStatus1)];

      var response = await dataHandler.receiveXML('SupportInfoGenerateStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithResetAdapterToFactoryDefaultsStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['result'] = 'testResultEntry';

      dataHandler.xmlResponseMap['ResetAdapterToFactoryDefaultsStatus'] = [XmlDocument.parse(resetAdapterToFactoryDefaultsStatus1)];

      var response = await dataHandler.receiveXML('ResetAdapterToFactoryDefaultsStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithIdentifyDeviceStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['result'] = 'failed';

      dataHandler.xmlResponseMap['IdentifyDeviceStatus'] = [XmlDocument.parse(identifyDeviceStatus1)];

      var response = await dataHandler.receiveXML('IdentifyDeviceStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithSetNetworkPasswordStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['status'] = 'complete';
      expectedResponse['total'] = '2';
      expectedResponse['failed'] = '0';

      dataHandler.xmlResponseMap['SetNetworkPasswordStatus'] = [XmlDocument.parse(setNetworkPasswordStatus1)];

      var response = await dataHandler.receiveXML('SetNetworkPasswordStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithAddRemoteAdapterStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['result'] = 'read_pib_failed';

      dataHandler.xmlResponseMap['AddRemoteAdapterStatus'] = [XmlDocument.parse(addRemoteAdapterStatus1)];

      var response = await dataHandler.receiveXML('AddRemoteAdapterStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    test('Given__When_callReceiveXMLWithSetVDSLCompatibilityStatus_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['result'] = 'ok';

      dataHandler.xmlResponseMap['SetVDSLCompatibilityStatus'] = [XmlDocument.parse(setVDSLCompatibilityStatus1)];

      var response = await dataHandler.receiveXML('SetVDSLCompatibilityStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

    // disableStandbyStatus is not requested in the if cases => triggers the else
    test('Given__When_callReceiveXMLWithDisableStandbyStatus1_Then_returnResponse',() async {

      var dataHandler = DataHand(true);

      Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
      expectedResponse['result'] = 'ok';

      dataHandler.xmlResponseMap['DisableStandbyStatus'] = [XmlDocument.parse(disableStandbyStatus1)];

      var response = await dataHandler.receiveXML('DisableStandbyStatus');

      expect(response,expectedResponse);
      expect(dataHandler.xmlResponseMap.isEmpty,true);

    });

  // test timout case
  test('Given__When_callReceiveXMLAndTheResponseIsNotExisting_Then_returnResponse',() async {

    var dataHandler = DataHand(true);

    Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
    expectedResponse['status'] = 'timeout';

    var response = await dataHandler.receiveXML('DisableStandbyStatus');

    expect(response,expectedResponse);

  }, timeout: Timeout(Duration(minutes: 1)));

  // case when xmlResponseMap gets the needed response later
  test('Given__When_callReceiveXMLAndTheResponseIsSetLater_Then_returnResponse',() async {

    var dataHandler = DataHand(true);

    Map<String, dynamic>? expectedResponse = Map<String, dynamic>();
    expectedResponse['result'] = 'failed';

    //response where status tag = running
    dataHandler.xmlResponseMap['IdentifyDeviceStatus'] = [XmlDocument.parse(identifyDeviceStatus2)];

    Timer(Duration(seconds: 5), () {
      dataHandler.xmlResponseMap['IdentifyDeviceStatus'] = [XmlDocument.parse(identifyDeviceStatus1)];
    });

    var response = await dataHandler.receiveXML('IdentifyDeviceStatus');

    expect(response,expectedResponse);
    expect(dataHandler.xmlResponseMap.isEmpty,true);

  });
});

  group('Future<String?> findFirstElem(XmlDocument revXML, String word)',() {

    test('Given_emptyDataHandObject_When_callFindFirstElemWithExistingTag_Then_returnResponse',() async {

      var dataHandler = DataHand(true);
      
      var expectedResponse = "failed";
      
      var response = await dataHandler.findFirstElem(XmlDocument.parse(identifyDeviceStatus1), "result");

      expect(response,expectedResponse);
    });

    test('Given_emptyDataHandObject_When_callFindFirstElemWithNonExistingTag_Then_returnNull',() async {

      var dataHandler = DataHand(true);

      var response = await dataHandler.findFirstElem(XmlDocument.parse(identifyDeviceStatus1), "notExistingTag");

      expect(response,null);
    });

  });

  group('Future<String?> findFirstElem(XmlDocument revXML, String word)',() {

    test('Given_emptyDataHandObject_When_callParseConfig_Then_setConfig', () {

      //set config with different values before
      config["allow_data_collection"] = true;
      config["ignore_updates"] = true;
      config["windows_network_throttling_disabled"] = false;
      var dataHandler = DataHand(true);

      dataHandler.parseConfig(XmlDocument.parse(config3WithoutMGSOCK));

      expect(config["allow_data_collection"], false);
      expect(config["ignore_updates"], false);
      expect(config["windows_network_throttling_disabled"], true);
    });

  });

  group('void parseFWUpdateStatus(XmlDocument xmlResponse)',() {

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateStatus_Then_setUpdateListAndUpdateState', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];

      dataHandler.parseFWUpdateStatus(XmlDocument.parse(firmwareUpdateStatus1));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

      Device device1 = dataHandler.getNetworkList().getDeviceList().where((element) => element.mac == "B8:BE:F4:31:96:AF").first;
      Device device2 = dataHandler.getNetworkList().getDeviceList().where((element) => element.mac == "B8:BE:F4:31:96:8B").first;
      expect(device1.updateState, "80");
      expect(device2.updateState, "pending");

    });

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateStatus_Then_setUpdateListAndUpdateState', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF"];

      //B8:BE:F4:31:96:AF(40%) and B8:F2:F4:51:96:8B(not in Network) and B8:BE:F4:31:96:8B(complete)
      dataHandler.parseFWUpdateStatus(XmlDocument.parse(firmwareUpdateStatus2));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

      Device device1 = dataHandler.getNetworkList().getDeviceList().where((element) => element.mac == "B8:BE:F4:31:96:AF").first;
      expect(device1.updateState, "40");
      
      Device device2 = dataHandler.getNetworkList().getDeviceList().where((element) => element.mac == "B8:BE:F4:31:96:8B").first;
      expect(device2.updateState, "complete");

    });

  });

  group('void parseFWUpdateIndication(XmlDocument xmlResponse)',() {

    // devices in network1
    //<macAddress>B8:BE:F4:31:96:AF</macAddress>
    //<macAddress>B8:BE:F4:31:96:8B</macAddress>
    //<macAddress>B8:BE:F4:0A:AE:B7</macAddress>

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateIndication_Then_setUpdateList', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF"];

      dataHandler.parseFWUpdateIndication(XmlDocument.parse(firmwareUpdateIndication1));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

    });

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateIndicationWith2MacAdresses_Then_setUpdateList', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];

      dataHandler.parseFWUpdateIndication(XmlDocument.parse(firmwareUpdateIndication2));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

    });

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateIndicationWithNotExistingMacAddress_Then_setUpdateList', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];

      dataHandler.parseFWUpdateIndication(XmlDocument.parse(firmwareUpdateIndication3));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

    });

  });
  group('Future<Map<String, dynamic>?> parseUpdateIndication(XmlDocument xmlResponse)',() {

    // devices in network1
    //<macAddress>B8:BE:F4:31:96:AF</macAddress>
    //<macAddress>B8:BE:F4:31:96:8B</macAddress>
    //<macAddress>B8:BE:F4:0A:AE:B7</macAddress>

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateIndication_Then_setUpdateList', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF"];

      dataHandler.parseFWUpdateIndication(XmlDocument.parse(firmwareUpdateIndication1));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

    });

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateIndicationWith2MacAdresses_Then_setUpdateList', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];

      dataHandler.parseFWUpdateIndication(XmlDocument.parse(firmwareUpdateIndication2));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

    });

    test('Given_DataHandObjectWithNetworkListAndUpdateList_When_parseFWUpdateIndicationWithNotExistingMacAddress_Then_setUpdateList', () {

      var dataHandler = DataHand(true);
      var oldUpdateList = ["B8:BE:F4:31:96:AF"];
      dataHandler.parseXML(networkUpdate1);
      dataHandler.getNetworkList().setUpdateList(oldUpdateList);

      var expectedUpdateList = ["B8:BE:F4:31:96:AF","B8:BE:F4:31:96:8B"];

      dataHandler.parseFWUpdateIndication(XmlDocument.parse(firmwareUpdateIndication3));

      expect(dataHandler.getNetworkList().getUpdateList(), expectedUpdateList);

    });

  });

}