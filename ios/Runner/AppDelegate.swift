import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      if(!UserDefaults.standard.bool(forKey: "Notification")) {
          UIApplication.shared.cancelAllLocalNotifications()
          UserDefaults.standard.set(true, forKey: "Notification")
      }

    let channelName = "culi_notifications"
    let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController.binaryMessenger)

    methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case "getTimeZoneName":
                let name = NSTimeZone.system.identifier
                print(name)
                result(name)
            default:
                return
            }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
