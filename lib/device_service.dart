import 'package:flutter/services.dart';

class DeviceService {
  static const MethodChannel _channel = MethodChannel('device_info_sensor');

  static Future<int?> getBatteryLevel() async {
    try {
      final int? batteryLevel = await _channel.invokeMethod('getBatteryLevel');
      return batteryLevel;
    } on PlatformException catch (_) {
      return null;
    }
  }

  static Future<String?> getDeviceName() async {
    try {
      final String? deviceName = await _channel.invokeMethod('getDeviceName');
      return deviceName;
    } on PlatformException catch (_) {
      return null;
    }
  }

  static Future<String?> getOSVersion() async {
    try {
      final String? osVersion = await _channel.invokeMethod('getOSVersion');
      return osVersion;
    } on PlatformException catch (_) {
      return null;
    }
  }

  static Future<bool?> toggleFlashlight(bool state) async {
    try {
      final bool? result =
          await _channel.invokeMethod('toggleFlashlight', {'state': state});
      return result;
    } on PlatformException catch (_) {
      return null;
    }
  }

  static Future<Map?> getGyroscopeData() async {
    try {
      final Map? data = await _channel.invokeMethod('getGyroscopeData');
      return data;
    } on PlatformException catch (_) {
      return null;
    }
  }
}
