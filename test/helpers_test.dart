/*
Copyright © 2023, devolo GmbH
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/mock-data/mock.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {

  group('List<XmlNode> findElements(List<XmlNode> remotes, String searchString)', () {

    // deleted at one item the macAdresses
    test('Given_When_callFindElements_Then_returnXmlNodeList', () {

      XmlDocument dataRatesXML = XmlDocument.parse(modifiedDataRates);
      List<XmlNode> dataRatesXMLChilds = dataRatesXML.getElement('dataRates')!.children;

      List<XmlNode> dataRatesElements = findElements(dataRatesXMLChilds,"macAddress");

      expect(dataRatesElements.length, 5);
    });
  });

  group('DeviceType getDeviceType(String deviceType)', () {

    test('Given_When_callGetDeviceType_Then_returnDeviceType', () {

      DeviceType deviceType1 = getDeviceType("dLAN pro 1200+ WiFi ac");
      DeviceType deviceType2 = getDeviceType("dLAN 1200+");
      DeviceType deviceType3 = getDeviceType("Magic 2 WiFi 2-1");
      DeviceType deviceType4 = getDeviceType("dLAN 1000 mini");
      DeviceType deviceType5 = getDeviceType("1200 DINrail");
      DeviceType deviceType6 = getDeviceType("WiFi Repeater+ ac");

      expect(deviceType1, DeviceType.dtWiFiPlus);
      expect(deviceType2, DeviceType.dtLanPlus);
      expect(deviceType3, DeviceType.dtWiFiPlus);
      expect(deviceType4, DeviceType.dtLanMini);
      expect(deviceType5, DeviceType.dtDINrail);
      expect(deviceType6, DeviceType.dtRepeater);
    });
  });

}