import UIKit
import Flutter
import AVFoundation
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "device_info_sensor"
  private let motionManager = CMMotionManager()
  private var isFlashlightOn = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "getBatteryLevel":
        self?.receiveBatteryLevel(result: result)
      case "getDeviceName":
        result(UIDevice.current.name)
      case "getOSVersion":
        result(UIDevice.current.systemVersion)
      case "toggleFlashlight":
        if let args = call.arguments as? [String: Any], let state = args["state"] as? Bool {
          self?.toggleFlashlight(state: state, result: result)
        } else {
          result(FlutterError(code: "BAD_ARGS", message: "Missing 'state'", details: nil))
        }
      case "getGyroscopeData":
        self?.getGyroscopeData(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func receiveBatteryLevel(result: FlutterResult) {
    UIDevice.current.isBatteryMonitoringEnabled = true
    let level = Int(UIDevice.current.batteryLevel * 100)
    if level < 0 {
      result(FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil))
    } else {
      result(level)
    }
  }

  private func toggleFlashlight(state: Bool, result: FlutterResult) {
    guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
      result(false)
      return
    }
    do {
      try device.lockForConfiguration()
      if state {
        try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
      } else {
        device.torchMode = .off
      }
      device.unlockForConfiguration()
      isFlashlightOn = state
      result(true)
    } catch {
      result(false)
    }
  }

  private func getGyroscopeData(result: FlutterResult) {
    if motionManager.isGyroAvailable {
      motionManager.gyroUpdateInterval = 0.1
      motionManager.startGyroUpdates()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        if let data = self.motionManager.gyroData {
          let dict: [String: Double] = ["x": data.rotationRate.x, "y": data.rotationRate.y, "z": data.rotationRate.z]
          result(dict)
          self.motionManager.stopGyroUpdates()
        } else {
          result(FlutterError(code: "NO_DATA", message: "Gyroscope data unavailable", details: nil))
        }
      }
    } else {
      result(FlutterError(code: "UNAVAILABLE", message: "Gyroscope not available", details: nil))
    }
  }
}
