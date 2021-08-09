/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';

class DeviceSimulator {
  List<String> deviceNames = ["Living Room", "Kitchen", "Home Office", "Balcony", "Children's Room", "Bedroom 1", "Bedroom 2"];
  var randomNumberGenerator = new Random();

  String getRandomDeviceName() {
    int nDeviceNames = deviceNames.length;
    int randomIndex = randomNumberGenerator.nextInt(nDeviceNames);

    return deviceNames[randomIndex];
  }

  // Creates one LAN device and multiple WiFi devices as default
  Device createDevice(int deviceNumber, [DeviceType? deviceType]) {
    if (deviceType == null) {
      deviceType = deviceNumber == 1 ? DeviceType.dtLanMini : DeviceType.dtWiFiMini;
    }

    Device device = new Device("Type: " + describeEnum(deviceType), // type
        "powerline:ghn", // networkType
        "Simulated " + getRandomDeviceName() + " device", // name
        "A8:A8:A8:A8:A8", // MAC address
        "192.168.1.1", // IP address
        "MT2000", // MT number
        "1811269791000709", // Serial number
        "5.7.2", // Version
        "2021-03-05", // Version date
        false, // Is device at Router?
        true, // Is local device?
        true, // Is a web interface available?
        true, // Is identify device available?
        "mimo_vdsl17a", // VDSL settings
        ["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],
        "1",
        [0,0], // Disable LEDs
        [1,0], // Disable Standby
        [1,1]); // Disable traffic

    return device;
  }
}
