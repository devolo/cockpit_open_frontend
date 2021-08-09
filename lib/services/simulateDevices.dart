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

    bool isDeviceAtRouter;
    if (deviceType == DeviceType.dtLanMini || deviceType == DeviceType.dtLanPlus) {
      isDeviceAtRouter = true;
    } else {
      isDeviceAtRouter = false;
    }

    Device device = new Device("Type: " + describeEnum(deviceType), // type
        "powerline:ghn", // networkType
        "Simulated " + device() + " getRandomDeviceName", // name
        "FF:FF:FF:FF:FF", // MAC address
        "255.255.255.255", // IP address
        "MT9999", // MT number
        "9999999999999999", // Serial number
        "9.9.9", // Version
        "1900-01-01", // Version date
        isDeviceAtRouter, // Is device at Router?
        true, // Is local device?
        false, // Is a web interface available?
        false, // Is identify device available?
        "mimo_vdsl17a", // VDSL settings
        ["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],
        "1",
        [0,0], // Disable LEDs
        [1,0], // Disable Standby
        [1,1]); // Disable traffic

    return device;
  }
}
