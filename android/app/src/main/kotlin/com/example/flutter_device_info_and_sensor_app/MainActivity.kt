package com.example.flutter_device_info_and_sensor_app

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager

class MainActivity: FlutterActivity(), SensorEventListener {
  private val CHANNEL = "device_info_sensor"

  private var sensorManager: SensorManager? = null
  private var gyroData = mapOf<String, Double>("x" to 0.0, "y" to 0.0, "z" to 0.0)
  private var flashlightOn = false

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // SensorManager setup for gyro
    sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->

      when(call.method) {
        "getBatteryLevel" -> {
          val batteryLevel = getBatteryLevel()
          if (batteryLevel != -1) {
            result.success(batteryLevel)
          } else {
            result.error("UNAVAILABLE", "Battery level not available.", null)
          }
        }
        "getDeviceName" -> result.success(Build.MODEL)
        "getOSVersion" -> result.success(Build.VERSION.RELEASE)

        "toggleFlashlight" -> {
          val state = call.argument<Boolean>("state") ?: false
          val success = toggleFlashlight(state)
          result.success(success)
        }

        "getGyroscopeData" -> {
          registerGyroListener()
          result.success(gyroData)
        }

        else -> result.notImplemented()
      }
    }
  }

  private fun getBatteryLevel(): Int {
    val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
  }

  private fun toggleFlashlight(state: Boolean): Boolean {
    val cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
    try {
      val cameraId = cameraManager.cameraIdList[0]
      cameraManager.setTorchMode(cameraId, state)
      flashlightOn = state
      return true
    } catch (e: CameraAccessException) {
      e.printStackTrace()
      return false
    }
  }

  private fun registerGyroListener() {
    val gyroSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
    if (gyroSensor != null) {
      sensorManager?.registerListener(this, gyroSensor, SensorManager.SENSOR_DELAY_NORMAL)
    }
  }

  override fun onSensorChanged(event: SensorEvent?) {
    if (event?.sensor?.type == Sensor.TYPE_GYROSCOPE) {
      gyroData = mapOf(
        "x" to event.values[0].toDouble(),
        "y" to event.values[1].toDouble(),
        "z" to event.values[2].toDouble())
      // Optional: unregister after one read to avoid continuous updates:
      sensorManager?.unregisterListener(this)
    }
  }

  override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
    // No-op
  }
}

