/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

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

      var device = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2_05.02.2020","",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);

      expect(device.version, "5.7.2");
      expect(device.versionDate, "05.02.2020");

    });

    test('Given__When_callDeviceConstructorWithNormalVersion_Then_createDeviceWithCorrectVersion', () {

      var device = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","05.02.2020",false,true,true,"http://192.168.137.213/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);

      expect(device.version, "5.7.2");
      expect(device.versionDate, "05.02.2020");

    });

  });

  group('factory Device.fromXML(XmlElement element, bool islocalDevice)', () {

    test('Given_deviceXML_When_callDevice.fromXML_Then_createDevice', () {

      var expectedDevice = new Device("Magic 2 WiFi 2-1","powerline:ghn","Study Room","B8:BE:F4:31:96:AF","192.168.1.56","MT3082","1811269791000709","5.7.2","2021-03-05",false,true,true,"192.168.1.56/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[0,0],[1,0],[1,1]);
      var dataratePair1 = new DataratePair(double.parse("4.46453333333333319e+02").round(), double.parse("7.20000000000000018e+00").round());
      var dataratePair2 = new DataratePair(double.parse("3.18240000000000009e+02").round(), double.parse("5.65706666666666592e+02").round());
      expectedDevice.speeds = {"B8:BE:F4:0A:AE:B7": dataratePair1, "B8:BE:F4:31:96:8B": dataratePair2};

      var device2 = new Device("Magic 2 LAN 1-1","powerline:ghn","Gateway2","B8:BE:F4:0A:AE:B7","192.168.1.41","MT3005","1807044980025550","7.10.2.77","2021-04-01",true,false,true,"192.168.1.41/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"1",[1,0],[0,0],[1,1]);
      var dataratePair3 = new DataratePair(double.parse("2.98080000000000041e+02").round(), double.parse("8.28853333333333353e+02").round());
      var dataratePair4 = new DataratePair(double.parse("2.94719999999999970e+02").round(), double.parse("3.70133333333333326e+02").round());
      device2.speeds = {"B8:BE:F4:31:96:8B": dataratePair3, "B8:BE:F4:31:96:AF": dataratePair4};

      var device3 = new Device("Magic 2 WiFi 2-1","powerline:ghn","devolo-700","B8:BE:F4:31:96:8B","192.168.1.57","MT3082","1811269791000700","5.6.1","2020-10-23",false,false,true,"192.168.1.57/",true,"mimo_vdsl17a",["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],"0",[1,0],[1,1],[0,0]);
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

  group('String toRealString()', () {

    test('Given Device When toRealString is called Then DeviceString returns', () {
      //ARRANGE - Initialisation
      final dev = Device("Magic 1 WiFi 2-1","powerline:ghn", "devolo-045", "B8:BE:F4:00:08:B5", "192.168.178.137", "MT3064", "1807255601000045", "5.3.2", "2020-06-05", false, false, true,"http://192.168.137.213/", true, "siso_vdsl17a", ["siso_vdsl17a", "siso_full", "siso_vdsl35b"], "0",[0,0],[1,1],[0,0]);
      final deviceString = "Name: devolo-045,\n type: Magic 1 WiFi 2-1,\n typeEnum: DeviceType.dtWiFiPlus,\n networkType: powerline:ghn,\n mac: B8:BE:F4:00:08:B5,\n ip: 192.168.178.137,\n version: 5.3.2,\n version_date: 2020-06-05,\n MT: MT3064,\n serialno: 1807255601000045,\n remoteDevices: [],\n speeds: {},\n attachedToRouter: false,\n isLocalDevice: false,\n webinterfaceAvailable: true,\n webinterfaceURL: http://192.168.137.213/,\n identifyDeviceAvailable: true,\n UpdateStatus: 0,\n SelectedVDSL: siso_vdsl17a,\n SupportedVDSL: [siso_vdsl17a, siso_full, siso_vdsl35b],\n ModeVDSL: 0,\n disable_leds: [0, 0],\n disable_standby: [1, 1],\n disable_traffic: [0, 0]\n";

      //ACT - Execute
      String devStr = dev.toRealString();

      //ASSETS - Observation
      expect(devStr, deviceString);
    });

    test('Given device xmlElement When toRealString is called Then DeviceString returns', () {
      //ARRANGE - Initialisation
      String devXML = '''<?xml version="1.0"?> <item class_id="9" tracking_level="0" version="0">
					<type>Magic 1 WiFi 2-1</type>
					<name>devolo-045</name>
					<network></network>
					<version>5.3.2</version>
					<date>2020-06-05</date>
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
						<count>4</count>
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
              <first>disable_standby</first>
              <second>
                <count>1</count>
                <item_version>0</item_version>
                <item>
                  <first>state</first>
                  <second>1</second>
                </item>
              </second>
				    </item>
						<item>
							<first>vdsl_compat</first>
							<second>
								<count>3</count>
								<item_version>0</item_version>
								<item>
									<first>mode</first>
									<second>0</second>
								</item>
								<item>
									<first>selected_profile</first>
									<second>siso_vdsl17a</second>
								</item>
								<item>
									<first>supported_profiles</first>
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
				</item>''';
      final doc = XmlDocument.parse(devXML);
      final devElement = doc.getElement("item");
      final dev = Device.fromXML(devElement!, false);
      final deviceString = "Name: devolo-045,\n type: Magic 1 WiFi 2-1,\n typeEnum: DeviceType.dtWiFiPlus,\n networkType: powerline:ghn,\n mac: B8:BE:F4:00:08:B5,\n ip: 192.168.178.137,\n version: 5.3.2,\n version_date: 2020-06-05,\n MT: MT3064,\n serialno: 1807255601000045,\n remoteDevices: [],\n speeds: {},\n attachedToRouter: false,\n isLocalDevice: false,\n webinterfaceAvailable: true,\n webinterfaceURL: 192.168.178.137/,\n identifyDeviceAvailable: true,\n UpdateStatus: 0,\n SelectedVDSL: siso_vdsl17a,\n SupportedVDSL: [siso_vdsl17a, siso_full, siso_vdsl35b],\n ModeVDSL: 0,\n disable_leds: [0, 0],\n disable_standby: [1, 1],\n disable_traffic: [0, 0]\n";

      //ACT - Execute
      String devStr = dev.toRealString();

      //ASSETS - Observation
      expect(devStr, deviceString);
    });

  });

}