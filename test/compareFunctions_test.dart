/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/shared/compareFunctions.dart';
import 'package:test/test.dart';

void main() {

  group('bool compareDataratePair(DataratePair first, DataratePair other)', () {

    test('Given_2differentDataratePairs_When_callCompareDataratePair_Then_returnFalse', () {

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("5.65706666666666592e+02").round());

      expect(compareDataratePair(dataratePair1, dataratePair2), false);
    });

    test('Given_2equalDataratePairs_When_callCompareDataratePair_Then_returnTrue', () {

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());

      expect(compareDataratePair(dataratePair1, dataratePair2), true);
    });
  });

  group('bool compareSpeedRates(Map<String, DataratePair>? rates1, Map<String, DataratePair>? rates2)', () {

    test('Given_speedRatesWithDifferentDataRatesWhen_callCompareSpeedRates_Then_returnFalse', () {

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var speedRates1 = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var dataratePair3 = new DataratePair(double.parse("7.46453343333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var speedRates2 = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      expect(compareSpeedRates(speedRates1, speedRates2), false);
    });

    test('Given_speedRatesWithDifferentMacAdresses_callCompareSpeedRates_Then_returnFalse', () {

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var speedRates1 = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var speedRates2 = {"B8:BE:F4:7M:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      expect(compareSpeedRates(speedRates1, speedRates2), false);
    });

    test('Given_identicalSpeedRates_callCompareSpeedRates_Then_returnTrue', () {

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var speedRates1 = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var speedRates2 = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      expect(compareSpeedRates(speedRates1, speedRates2), true);
    });
  });

  group('bool compareDevice(Device first, Device other)', () {

    test('Given_devicesWithDifferentVdslList_callCompareDevice_Then_returnFalse', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};


      expect(compareDevice(device1, device2), false);
    });

    test('Given_devicesWithDifferentSpeeds_callCompareDevice_Then_returnFalse', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"","","");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"","","");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:54:8B": dataratePair4};


      expect(compareDevice(device1, device2), false);
    });

    test('Given_devicesWithDifferentRemoteDevices(DataRates)_callCompareDevice_Then_returnFalse', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("8.18240000890000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      expect(compareDevice(device1, device2), false);
    });

    test('Given_identicalDevices_callCompareDevice_Then_returnTrue', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      expect(compareDevice(device1, device2), true);
    });

  });

  group('bool compareNetworkList(NetworkList first, NetworkList other)', () {

    test('Given_NetworkListsWithDifferentLength_compareNetworkList_Then_returnFalse', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1],"","","");
      var device3 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");

      var network1 = new NetworkList();
      network1.addDevice(device1,0);
      network1.addDevice(device2,0);
      network1.addDevice(device3,1);

      var network2 = new NetworkList();
      network2.addDevice(device1,0);
      network2.addDevice(device2,0);

      expect(compareNetworkList(network1, network2), false);
    });

    test('Given_NetworkListsWithDifferentSpeedRatesInRemoteDevice_compareNetworkList_Then_returnFalse', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("8.18240000000000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      var device3 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");
      var device4 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");

      var network1 = new NetworkList();
      network1.addDevice(device1,0);
      network1.addDevice(device1_1,0);
      network1.addDevice(device3,1);

      var network2 = new NetworkList();
      network2.addDevice(device2,0);
      network2.addDevice(device2_1,0);
      network2.addDevice(device4,1);

      expect(compareNetworkList(network1, network2), false);
    });

    test('Given_identicalNetworkLists_compareNetworkList_Then_returnTrue', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");

      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      var device3 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");
      var device4 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");

      var network1 = new NetworkList();
      network1.addDevice(device1,0);
      network1.addDevice(device1_1,0);
      network1.addDevice(device3,1);

      var network2 = new NetworkList();
      network2.addDevice(device2,0);
      network2.addDevice(device2_1,0);
      network2.addDevice(device4,1);

      expect(compareNetworkList(network1, network2), true);
    });
  });

  group('bool compareDeviceList(List<Device> first, List<Device> other)', () {

    test('Given_deviceListsWithDifferentTypeInOneDevice_When_callCompareDeviceList_Then_returnFalse', () {
      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");

      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      var device3 = new Device("Magic 2 TESTENTRY 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");
      var device4 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");

      var deviceList1 = [device1,device1_1,device3];
      var deviceList2 = [device2,device2_1,device4];

      expect(compareDeviceList(deviceList1, deviceList2),false);

    });

    test('Given_identicalDeviceLists_When_callCompareDeviceList_Then_returnTrue', () {
      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      var device3 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");
      var device4 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");

      var deviceList1 = [device1,device1_1,device3];
      var deviceList2 = [device2,device2_1,device4];

      expect(compareDeviceList(deviceList1, deviceList2),true);

    });
  });

  group('bool compareListOfDeviceList(List<List<Device>> first, List<List<Device>> other)', () {

    test('Given_ListOfDeviceListsWithDifferentSpeedRatesInRemoteDevice_compareListOfDeviceList_Then_returnFalse', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("8.18240000000000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      var device3 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");
      var device4 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");

      var deviceList1 = [[device1,device1_1],[device3]];
      var deviceList2 = [[device2,device2_1],[device4]];

      expect(compareListOfDeviceList(deviceList1, deviceList2), false);
    });

    test('Given_identicalListOfDeviceLists_compareListOfDeviceList_Then_returnTrue', () {

      var device1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device1_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device1_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      device1.remoteDevices.add(device1_1);

      var device2 = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1],"E4:B9:7A:DE:00:94","192.168.0.1","255.255.255.0");
      var dataratePair3 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair4 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device2.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair3, "B8:BE:F4:31:96:8B": dataratePair4};

      var device2_1 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"http://169.254.8.209/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[0,0],[1,1],"","","");
      var dataratePair7 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair8 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device2_1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair7, "B8:BE:F4:31:96:AF": dataratePair8};

      device2.remoteDevices.add(device2_1);

      var device3 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");
      var device4 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"http://169.254.8.113/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[1,1],[0,0],"","","");

      var deviceList1 = [[device1,device1_1],[device3]];
      var deviceList2 = [[device2,device2_1],[device4]];

      expect(compareListOfDeviceList(deviceList1, deviceList2), true);
    });

  });

}

