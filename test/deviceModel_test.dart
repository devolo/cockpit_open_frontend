import 'package:cockpit_devolo/mock-data/mock.dart';
import 'package:cockpit_devolo/models/dataRateModel.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cockpit_devolo/shared/compareFunctions.dart';
import 'package:xml/xml.dart';

void main() {

  // only testing the behaviour of the parameter version as it´s handling is a bit more complicated
  group('Device Constructor', () {

    test('Given__When_callDeviceConstructorWithUnderscoreVersion_Then_createDeviceWithCorrectVersion', () {

      var device = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2_05.02.2020","",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");

      expect(device.version, "5.7.2");
      expect(device.version_date, "05.02.2020");

    });

    test('Given__When_callDeviceConstructorWithNormalVersion_Then_createDeviceWithCorrectVersion', () {

      var device = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","05.02.2020",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");

      expect(device.version, "5.7.2");
      expect(device.version_date, "05.02.2020");

    });

  });

  group('factory Device.fromXML(XmlElement element, bool islocalDevice)', () {

    test('Given_deviceXML_When_callDevice.fromXML_Then_createDevice', () {

      var expectedDevice = new Device("Magic 2 WiFi 2-1","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      expectedDevice.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1");
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0");
      var dataratePair5 = new DataratePair(double.parse("8.28853333333333353e+02").round(), double.parse("2.98080000000000041e+02").round());
      var dataratePair6 = new DataratePair(double.parse("5.65706666666666592e+02").round(), double.parse("3.18240000000000009e+02").round());
      device3.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair5, "B8:BE:F4:31:96:AF": dataratePair6};

      expectedDevice.remoteDevices.add(device2);
      expectedDevice.remoteDevices.add(device3);

      XmlDocument deviceXMLDocument = XmlDocument.parse(deviceXML);
      XmlElement deviceXMLElement = deviceXMLDocument.findElements('item').first;

      Device device = Device.fromXML(deviceXMLElement, true);

      expect(compareDevice(device, expectedDevice), true);
    });


  });

  //TODO - Caroline worked on the method
  group('String toRealString()', () {

    test('Given_When_Then_', () {

    });

  });

}