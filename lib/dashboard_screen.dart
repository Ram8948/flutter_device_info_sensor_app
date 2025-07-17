import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'device_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? _battery;
  String? _deviceName;
  String? _osVersion;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeviceInfo();
  }

  Future<void> _fetchDeviceInfo() async {
    setState(() {
      _loading = true;
    });
    final battery = await DeviceService.getBatteryLevel();
    final deviceName = await DeviceService.getDeviceName();
    final osVersion = await DeviceService.getOSVersion();

    setState(() {
      _battery = battery;
      _deviceName = deviceName;
      _osVersion = osVersion;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: _loading
            ? Lottie.asset('assets/loading.json', width: 150, height: 150)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Battery Level: ${_battery ?? "Unknown"}%',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Device Name: ${_deviceName ?? "Unknown"}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('OS Version: ${_osVersion ?? "Unknown"}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _fetchDeviceInfo,
                    child: Text('Refresh'),
                  ),
                ],
              ),
      ),
    );
  }
}
