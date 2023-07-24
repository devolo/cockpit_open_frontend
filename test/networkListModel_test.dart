/*
Copyright © 2023, devolo GmbH
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cockpit_devolo/shared/compareFunctions.dart';

void main() {

  group('List<Device> getDeviceList()', () {

    test('Given_networkListObjectWithEmptyNetworkList_When_callGetDeviceList_Then_returnEmptyList', () {

      var network = NetworkList();

      var deviceList = network.getDeviceList();

      expect(compareDeviceList(deviceList,[]), true);

    });

    test('Given_networkListObjectWithNetworkList_When_callGetDeviceListWithFalseNetworkIndex_Then_returnNetworkList[0]', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 2;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[1,1],"","","",false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      device1.remoteDevices.add(device2);

      network.addDevice(device1,0);
      network.addDevice(device2,1);


      var deviceList = network.getDeviceList();

      expect(compareDeviceList(deviceList,[device1]), true);

    });

    test('Given_networkListObjectWithNetworkList_When_callGetDeviceList_Then_returnNetworkList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[1,1],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var deviceList = network.getDeviceList();
      
      expect(compareDeviceList(deviceList,[device2,device3]), true);

    });
  });

  group('List<String> getUpdateList()', () {

    test('Given_networkListObjectWithUpdateMacsList_When_callGetUpdateList_Then_returnUpdateList', () {

      var network = NetworkList();
      network.setUpdateList(["test1","test2"]);

      var updateList = network.getUpdateList();

      expect(updateList,["test1","test2"]);

    });
  });

  group('void setUpdateList(List<String> updateList)', () {

    test('Given_networkListObject_When_callSetUpdateList_Then_setUpdateListANDcheckedUpdateMacs', () {

      var network = NetworkList();

      network.setUpdateList(["test1","test2"]);

      expect(network.getUpdateList(),["test1","test2"]);
      expect(network.getCheckedUpdateMacs(),["test1","test2"]);
      expect(network.getPrivacyWarningMacs(),[]);
    });

    test('Given_networkListObject_When_callSetUpdateList_Then_setUpdateListANDcheckedUpdateMacsANDprivacyWarningMacs', () {

      var network = NetworkList();

      network.setUpdateList(["test1","test2"],privacyWarningMacs: ["test3"]);

      expect(network.getUpdateList(),["test1","test2"]);
      expect(network.getCheckedUpdateMacs(),["test1","test2"]);
      expect(network.getPrivacyWarningMacs(),["test3"]);
    });
  });

  group('List<List<Device>> getNetworkList()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetNetworkList_Then_returnNetworkList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var networkList = network.getNetworkList();

      expect(compareListOfDeviceList(networkList,[[device1],[device2,device3]]), true);

    });
  });

  group('List<Device> getAllDevices()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetGetAllDevices_Then_returnDeviceList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var deviceList = network.getAllDevices();

      expect(compareDeviceList(deviceList,[device1,device2,device3]), true);

    });
  });

  group('List<Device> getAllDevicesFilteredByState()', () {

    test('Given_networkListObjectWithNetworkListAndUpdateList_When_callGetAllDevicesFilteredByState_Then_returnFilteredDeviceList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;
      network.setUpdateList(["B8:BE:F4:0A:AE:B7","B8:BE:F4:31:96:8A"]); //device2 and device 4

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("dLAN pro 1200+ WiFi ac","powerline:hpav","devolo-700","B8:BE:F4:31:96:8A","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[0,0],[1,0],[1,1],"","","", false);
      var device5 = new Device("unknowntype","powerline:hpav","devolo-700","B8:BE:F4:31:96:8C","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","", false);

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);
      device4.remoteDevices.add(device5);

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);
      network.addDevice(device4,2);
      network.addDevice(device5,2);

      var deviceList = network.getAllDevicesFilteredByState();

      expect(compareDeviceList(deviceList,[device2,device4,device1,device3,device5]), true);

    });
  });

  group('List<Device> getNetworkListLength()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetNetworkListLength_Then_networkListLength', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var networkLength = network.getNetworkListLength();

      expect(networkLength,2);

    });
  });

  group('List<Device> getPivotDevice()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetPivotDevice_Then_returnPivotDevice', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var pivotDevice = network.getPivotDevice();

      expect(compareDevice(pivotDevice!, device2),true);

    });

    test('Given_networkListObjectWithNetworkListWithoutPivotDevice_When_callGetPivotDevice_Then_returnNoDevice', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",false,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var pivotDevice = network.getPivotDevice();

      expect(pivotDevice, null);

    });
  });

  group('List<Device> getLocalDevice()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetLocalDevice_Then_returnLocalDevice', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);

      var localDevice = network.getLocalDevice();

      expect(localDevice!, device1);

    });

    test('Given_networkListObjectWithNetworkListWithoutLocalDevice_When_callGetLocalDevice_Then_returnNoDevice', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,false,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);

      var localDevice = network.getLocalDevice();

      expect(localDevice, null);

    });
  });

  group('List<Device> getLocalDevices()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetLocalDevice_Then_returnLocalDevice', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,true,true,"192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);
      network.addDevice(device4,1);

      var localDevices = network.getLocalDevices();

      expect(compareDeviceList(localDevices, [device1,device4]), true);

    });

    test('Given_networkListObjectWithNetworkListWithoutLocalDevice_When_callGetLocalDevice_Then_returnEmptyList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,false,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);

      var localDevice = network.getLocalDevices();

      expect(localDevice, []);

    });
  });

  group('List<String> getNetworkName(networkIndex))', () {

    test('Given_networkListObjectWithNetworkList_When_callGetNetworkName_Then_returnNetworkName', ()
    {
      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("dLAN pro 1200+ WiFi ac","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[0,0],[1,0],[1,1],"","","", false);
      var device5 = new Device("unknowntype","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","", false);

      var device6 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B9","192.168.1.134","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,true,true,"169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair7 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair8 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);
      network.addDevice(device4,1);
      network.addDevice(device5,2);
      network.addDevice(device6,3);

      network.fillNetworkNames();

      expect(network.getNetworkName(network.selectedNetworkIndex), "Magic Network");
      expect(network.getNetworkName(1), "dLAN Network");
      expect(network.getNetworkName(2), "PLC Network");
      expect(network.getNetworkName(3), "Magic Network 2");

    });
  });

  group('String fillNetworkNames()', () {

    test('Given_networkListObjectWithNetworkList_When_callFillNetworkNames_Then_setNetworkNamesList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("dLAN pro 1200+ WiFi ac","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[0,0],[1,0],[1,1],"","","", false);
      var device5 = new Device("unknowntype","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","", false);

      var device6 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B9","192.168.1.134","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,true,true,"169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair7 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair8 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      var device7 = new Device("WiFi Repeater+ ac","wifi:other","RepeaterName","B8:BE:F4:0A:AE:B9","192.168.1.134","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,true,true,"169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);
      network.addDevice(device4,1);
      network.addDevice(device5,2);
      network.addDevice(device6,3);
      network.addDevice(device7,4);

      network.fillNetworkNames();

      expect(network.getNetworkNames(), ["Magic Network", "dLAN Network" , "PLC Network", "Magic Network 2", "Repeater Network"]);
    });
  });

  group('void setDeviceList(List<Device> devList)', () {

    test('Given_networkListObjectWithNetworkList_When_callSetDeviceList_Then_setDeviceListAtSelectedIndex', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("testDevice","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[0,0],[1,0],[1,1],"","","", false);

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device4,0);
      network.addDevice(device1,1);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      network.setDeviceList([device3,device2]);

      expect(compareDeviceList(network.getDeviceList(), [device3,device2]), true);

    });
  });

  group('Device getDeviceByMac(String mac)',(){
    test('Given_networkListObjectWithNetworkList_When_callGetDeviceByMac_Then_returnDevice',(){

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      network.setDeviceList([device1]);

      network.selectedNetworkIndex = 1;

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("testDevice","powerline:ghn","devolo-700","B8:BE:F4:31:96:8C","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[0,0],[1,0],[1,1],"","","", false);

      device2.remoteDevices.add(device3);

      network.addDevice(device3,0);
      network.addDevice(device2,0);
      network.addDevice(device4,1);

      Device? returnedDevice = network.getDeviceByMac("B8:BE:F4:31:96:8C"); // mac of device 4
      Device? returnedDevice2 = network.getDeviceByMac("B8:BE:F4:65:96:8B"); //mac is not existing

      expect(compareDevice(returnedDevice!, device4), true);
      expect(returnedDevice2, null);

    });
  });

  group('addDevice(Device device, int whichNetworkIndex)', () {

    test('Given_networkListObjectWithNetworkList_When_callAddDevice_Then_setDeviceAtSelectedIndex', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      network.setDeviceList([device1]);

      network.selectedNetworkIndex = 1;

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("testDevice","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[0,0],[1,0],[1,1],"","","", false);

      device2.remoteDevices.add(device3);

      network.addDevice(device3,0);
      network.addDevice(device2,0);
      network.addDevice(device4,1);

      network.selectedNetworkIndex = 0;
      expect(compareDeviceList(network.getDeviceList(), [device2,device1,device3]), true);

      network.selectedNetworkIndex = 1;
      expect(compareDeviceList(network.getDeviceList(), [device4]), true);

      expect(compareDeviceList(network.getAllDevices(), [device2,device1,device3,device4]), true);

    });
  });

  group('void clearDeviceList()', () {

    test('Given_networkListObjectWithNetworkList_When_callClearDeviceList_Then_returnEmptyDeviceList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);

      network.clearDeviceList();

      expect(network.getDeviceList(), []);

    });
  });

  group('void clearNetworkList()', () {

    test('Given_networkListObjectWithNetworkList_When_callClearNetworkList_Then_returnEmptyNetworkList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","", false);

      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0],"","","", false);
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};


      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      network.clearNetworkList();

      expect(network.getDeviceList(), []);
      expect(network.getNetworkList(), []);

    });
  });

  group('String selectedNetworkListToRealString()', () {

    test('Given networkList When selectedNetworkListToRealString is called Then NetworkString returns', () {
      //ARRANGE - Initialisation
      final networkList = NetworkList();
      networkList.selectedNetworkIndex = 0;

      final dev1 = Device("Magic 2 LAN 1-1", "powerline:ghn","devoloLAN", "30:D3:2D:EE:8D:A1", "192.168.178.139", "MT2999", "1806154350000340", "7.8.5.47", "2020-06-05", true, true, true,"192.168.178.139/", true, "mimo_vdsl17a", ["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"], "0",[0,0],[1,0],[1,1],"","","", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      dev1.speeds = {"B8:BE:F4:00:0C:07": dataratePair1};

      final dev2 = Device("Magic 1 WiFi 2-1", "powerline:ghn","AP-Unten2", "B8:BE:F4:00:0C:07", "192.168.178.136", "MT3064", "1807255601000215", "5.8.0.N1077", "2021-04-06", false, false, true,"192.168.178.136/", true, "siso_vdsl17a", ["siso_vdsl17a", "siso_full", "siso_vdsl35b"], "1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      dev2.speeds = {"30:D3:2D:EE:8D:A1": dataratePair3, "B8:BE:F4:00:08:B5": dataratePair4};


      networkList.addDevice(dev1,0);
      networkList.addDevice(dev2,0);
      print(dev1.toRealString());
      print(dev2.toRealString());

      final expectNetworkStr = '''Name: devoloLAN,
 type: Magic 2 LAN 1-1,
 typeEnum: DeviceType.dtLanPlus,
 networkType: powerline:ghn,
 mac: 30:D3:2D:EE:8D:A1,
 ip: 192.168.178.139,
 version: 7.8.5.47,
 version_date: 2020-06-05,
 MT: MT2999,
 serialno: 1806154350000340,
 remoteDevices: [],
 speeds: {B8:BE:F4:00:0C:07: Instance of 'DataratePair'},
 attachedToRouter: true,
 isLocalDevice: true,
 webinterfaceAvailable: true,
 webinterfaceURL: 192.168.178.139/,
 identifyDeviceAvailable: true,
 UpdateStatus: 0,
 SelectedVDSL: mimo_vdsl17a,
 SupportedVDSL: [mimo_vdsl17a, siso_full, siso_vdsl17a, siso_vdsl35b, mimo_full, mimo_vdsl35b],
 ModeVDSL: 0,
 disable_leds: [0, 0],
 disable_standby: [1, 0],
 disable_traffic: [1, 1],
 ipConfigMac: ,
 ipConfigAddress: ,
 ipConfigNetmask: ,
 incomplete: false
 
Name: AP-Unten2,
 type: Magic 1 WiFi 2-1,
 typeEnum: DeviceType.dtWiFiPlus,
 networkType: powerline:ghn,
 mac: B8:BE:F4:00:0C:07,
 ip: 192.168.178.136,
 version: 5.8.0.N1077,
 version_date: 2021-04-06,
 MT: MT3064,
 serialno: 1807255601000215,
 remoteDevices: [],
 speeds: {30:D3:2D:EE:8D:A1: Instance of 'DataratePair', B8:BE:F4:00:08:B5: Instance of 'DataratePair'},
 attachedToRouter: false,
 isLocalDevice: false,
 webinterfaceAvailable: true,
 webinterfaceURL: 192.168.178.136/,
 identifyDeviceAvailable: true,
 UpdateStatus: 0,
 SelectedVDSL: siso_vdsl17a,
 SupportedVDSL: [siso_vdsl17a, siso_full, siso_vdsl35b],
 ModeVDSL: 1,
 disable_leds: [1, 0],
 disable_standby: [0, 0],
 disable_traffic: [1, 1],
 ipConfigMac: ,
 ipConfigAddress: ,
 ipConfigNetmask: ,
 incomplete: false
 
''';

      //ACT - Execute
      String networkStr = networkList.selectedNetworkListToRealString();
      print(networkStr);

      //ASSETS - Observation
      expect(networkStr, expectNetworkStr);
    });

    test('Given empty networkList When selectedNetworkListToRealString is called Then Empty String returns', () {
      //ARRANGE - Initialisation
      final networkList = NetworkList();
      networkList.selectedNetworkIndex = 0;

      //ACT - Execute
      String networkStr = networkList.selectedNetworkListToRealString();

      //ASSETS - Observation
      expect(networkStr, "");
    });
  });

  group('String networkListToRealString()', () {

    test('Given networkList When networkListToRealString is called Then NetworkString returns', () {
      //ARRANGE - Initialisation
      final networkList = NetworkList();
      networkList.selectedNetworkIndex = 0;

      final dev1 = Device("Magic 2 LAN 1-1","powerline:ghn", "devoloLAN", "30:D3:2D:EE:8D:A1", "192.168.178.139", "MT2999", "1806154350000340", "7.8.5.47", "2020-06-05", true, true, true,"192.168.178.139/", true, "mimo_vdsl17a", ["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"], "0",[0,0],[1,0],[1,1],"","","", false);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      dev1.speeds = {"B8:BE:F4:00:0C:07": dataratePair1};

      final dev2 = Device("Magic 1 WiFi 2-1","powerline:ghn", "AP-Unten2", "B8:BE:F4:00:0C:07", "192.168.178.136", "MT3064", "1807255601000215", "5.8.0.N1077", "2021-04-06", false, false, true,"192.168.178.136/", true, "siso_vdsl17a", ["siso_vdsl17a", "siso_full", "siso_vdsl35b"], "1",[1,0],[0,0],[1,1],"","","", false);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      dev2.speeds = {"30:D3:2D:EE:8D:A1": dataratePair3, "B8:BE:F4:00:08:B5": dataratePair4};


      networkList.addDevice(dev1,0);
      networkList.addDevice(dev2,1);
      print(dev1.toRealString());
      print(dev2.toRealString());

      final expectNetworkStr = '''Name: devoloLAN,
 type: Magic 2 LAN 1-1,
 typeEnum: DeviceType.dtLanPlus,
 networkType: powerline:ghn,
 mac: 30:D3:2D:EE:8D:A1,
 ip: 192.168.178.139,
 version: 7.8.5.47,
 version_date: 2020-06-05,
 MT: MT2999,
 serialno: 1806154350000340,
 remoteDevices: [],
 speeds: {B8:BE:F4:00:0C:07: Instance of 'DataratePair'},
 attachedToRouter: true,
 isLocalDevice: true,
 webinterfaceAvailable: true,
 webinterfaceURL: 192.168.178.139/,
 identifyDeviceAvailable: true,
 UpdateStatus: 0,
 SelectedVDSL: mimo_vdsl17a,
 SupportedVDSL: [mimo_vdsl17a, siso_full, siso_vdsl17a, siso_vdsl35b, mimo_full, mimo_vdsl35b],
 ModeVDSL: 0,
 disable_leds: [0, 0],
 disable_standby: [1, 0],
 disable_traffic: [1, 1],
 ipConfigMac: ,
 ipConfigAddress: ,
 ipConfigNetmask: ,
 incomplete: false
 
Name: AP-Unten2,
 type: Magic 1 WiFi 2-1,
 typeEnum: DeviceType.dtWiFiPlus,
 networkType: powerline:ghn,
 mac: B8:BE:F4:00:0C:07,
 ip: 192.168.178.136,
 version: 5.8.0.N1077,
 version_date: 2021-04-06,
 MT: MT3064,
 serialno: 1807255601000215,
 remoteDevices: [],
 speeds: {30:D3:2D:EE:8D:A1: Instance of 'DataratePair', B8:BE:F4:00:08:B5: Instance of 'DataratePair'},
 attachedToRouter: false,
 isLocalDevice: false,
 webinterfaceAvailable: true,
 webinterfaceURL: 192.168.178.136/,
 identifyDeviceAvailable: true,
 UpdateStatus: 0,
 SelectedVDSL: siso_vdsl17a,
 SupportedVDSL: [siso_vdsl17a, siso_full, siso_vdsl35b],
 ModeVDSL: 1,
 disable_leds: [1, 0],
 disable_standby: [0, 0],
 disable_traffic: [1, 1],
 ipConfigMac: ,
 ipConfigAddress: ,
 ipConfigNetmask: ,
 incomplete: false
 
''';

      //ACT - Execute
      String networkStr = networkList.networkListToRealString();
      print(networkStr);

      //ASSETS - Observation
      expect(networkStr, expectNetworkStr);
    });

    test('Given empty networkList When networkListToRealString is called Then Empty String returns', () {
      //ARRANGE - Initialisation
      final networkList = NetworkList();
      networkList.selectedNetworkIndex = 0;

      //ACT - Execute
      String networkStr = networkList.networkListToRealString();

      //ASSETS - Observation
      expect(networkStr, "");
    });
  });
}