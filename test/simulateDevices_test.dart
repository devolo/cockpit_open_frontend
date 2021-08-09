import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cockpit_devolo/shared/globals.dart' as deviceSimulatorConfig;
import 'package:cockpit_devolo/services/simulateDevices.dart';

void main() {
  group('Device simulator', () {
    test("is disabled in production code", () {
      expect(deviceSimulatorConfig.simulatedDevices, false);
    });

    test("uses the default setup of having one LAN device and several WiFi devices", () {
      DeviceSimulator ds = new DeviceSimulator();
      Device firstDevice = ds.createDevice(1);
      Device thirdDevice = ds.createDevice(3);

      expect(firstDevice.typeEnum == DeviceType.dtLanMini, true);
      expect(thirdDevice.typeEnum == DeviceType.dtWiFiMini, true);
    });
  });
}
