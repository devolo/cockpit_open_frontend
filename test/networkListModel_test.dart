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

      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
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

    test('Given_networkListObject_When_callSetUpdateList_Then_setUpdateList', () {

      var network = NetworkList();

      network.setUpdateList(["test1","test2"]);

      expect(network.getUpdateList(),["test1","test2"]);

    });
  });

  group('List<List<Device>> getNetworkList()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetNetworkList_Then_returnNetworkList', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

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

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var deviceList = network.getAllDevices();

      expect(compareDeviceList(deviceList,[device1,device2,device3]), true);

    });
  });

  group('List<Device> getNetworkListLength()', () {

    test('Given_networkListObjectWithNetworkList_When_callGetNetworkListLength_Then_networkListLength', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

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

      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      var pivotDevice = network.getPivotDevice();

      expect(compareDevice(pivotDevice!, device2),true);

    });

    test('Given_networkListObjectWithNetworkListWithoutPivotDevice_When_callGetPivotDevice_Then_returnNoDevice', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
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

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);

      var localDevice = network.getLocalDevice();

      expect(localDevice!, device1);

    });

    test('Given_networkListObjectWithNetworkListWithoutLocalDevice_When_callGetLocalDevice_Then_returnNoDevice', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
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

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);

      var localDevice = network.getLocalDevice();

      expect(localDevice, null);

    });
  });

  group('String getNetworkType(networkIndex)', () {

    test('Given_networkListObjectWithNetworkList_When_callGetNetworkType_Then_returnNetworkType', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

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

      var device4 = new Device("dLAN pro 1200+ WiFi ac","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var device5 = new Device("unknowntype","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");

      device1.remoteDevices.add(device2);
      device1.remoteDevices.add(device3);

      network.addDevice(device1,0);
      network.addDevice(device2,0);
      network.addDevice(device3,0);
      network.addDevice(device4,1);
      network.addDevice(device5,2);

      var networkType0 = network.getNetworkType(0);
      var networkType1 = network.getNetworkType(1);
      var networkType2 = network.getNetworkType(2);


      expect(networkType0, "Magic");
      expect(networkType1, "dLAN");
      expect(networkType2, "PLC");

    });
  });

  group('void setDeviceList(List<Device> devList)', () {

    test('Given_networkListObjectWithNetworkList_When_callSetDeviceList_Then_setDeviceListAtSelectedIndex', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 1;

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

      var device4 = new Device("testDevice","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");

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

  group('addDevice(Device device, int whichNetworkIndex)', () {

    test('Given_networkListObjectWithNetworkList_When_callAddDevice_Then_setDeviceAtSelectedIndex', () {

      var network = NetworkList();
      network.selectedNetworkIndex = 0;

      var device1 = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      device1.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      network.setDeviceList([device1]);

      network.selectedNetworkIndex = 1;

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      var device4 = new Device("testDevice","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");

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


      network.addDevice(device1,0);
      network.addDevice(device2,1);
      network.addDevice(device3,1);

      network.clearNetworkList();

      expect(network.getDeviceList(), []);
      expect(network.getNetworkList(), []);

    });
  });

  //TODO - tested later as Caroline is changing the method
  group('String toRealString()', () {

    test('Given__When__Then_', () {

    });
  });
}