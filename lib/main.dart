import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'sensor_info_screen.dart';

void main() {
  runApp(DeviceInfoSensorApp());
}

class DeviceInfoSensorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Info & Sensor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeChooser(),
    );
  }
}

class HomeChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Info & Sensor App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Dashboard Screen'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DashboardScreen())),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('Sensor Info Screen'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SensorInfoScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
