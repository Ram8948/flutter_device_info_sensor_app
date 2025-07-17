import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'device_service.dart';

class SensorInfoScreen extends StatefulWidget {
  @override
  State<SensorInfoScreen> createState() => _SensorInfoScreenState();
}

class _SensorInfoScreenState extends State<SensorInfoScreen> {
  bool _flashOn = false;
  bool _loading = false;
  Map? _gyroData;

  Future<void> _toggleFlashlight() async {
    setState(() {
      _loading = true;
    });
    final result = await DeviceService.toggleFlashlight(!_flashOn);
    setState(() {
      _flashOn = result ?? _flashOn;
      _loading = false;
    });
  }

  Future<void> _readGyroscope() async {
    setState(() {
      _loading = true;
    });
    final data = await DeviceService.getGyroscopeData();
    setState(() {
      _gyroData = data;
      _loading = false;
    });
  }

  Widget _buildGyroData() {
    if (_gyroData == null) return Container();
    return Text(
      'Gyroscope Data:\n x=${_gyroData!['x']}\n y=${_gyroData!['y']}\n z=${_gyroData!['z']}',
      style: TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Info'),
      ),
      body: Center(
        child: _loading
            ? Lottie.asset('assets/toggle_flash.json', width: 150, height: 150)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SwitchListTile(
                    title: Text('Flashlight'),
                    value: _flashOn,
                    onChanged: (val) => _toggleFlashlight(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Read Gyroscope'),
                    onPressed: _readGyroscope,
                  ),
                  SizedBox(height: 20),
                  _buildGyroData(),
                ],
              ),
      ),
    );
  }
}
