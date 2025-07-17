import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_info_sensor_app/device_service.dart';

void main() {
  const MethodChannel channel = MethodChannel('device_info_sensor');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getBatteryLevel') {
        return 85;
      }
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getBatteryLevel returns battery level from native', () async {
    final int? batteryLevel = await DeviceService.getBatteryLevel();
    expect(batteryLevel, 85);
  });
}
