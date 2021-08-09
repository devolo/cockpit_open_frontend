/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:io';
import 'package:cockpit_devolo/models/deviceModel.dart';

class DeviceSimulator {

  Device createDevice(int deviceNumber) {
    Device device = new Device("Simulated device" + deviceNumber.toString(),
        "powerline:ghn",
        "Living Room",
        "A8:A8:A8:A8:A8",
        "192.168.1.1",
        "MT2000",
        "1811269791000709",
        "5.7.2","2021-03-05",
        false,
        true,
        true,
        true,
        "mimo_vdsl17a",
        ["mimo_vdsl17a", "siso_full", "siso_vdsl17a", "siso_vdsl35b", "mimo_full", "mimo_vdsl35b"],
        "1",
        [0,0],
        [1,0],
        [1,1]);

    return device;
  }
}
