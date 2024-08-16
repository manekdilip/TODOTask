import Flutter
import FirebaseCore
import UIKit
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
WorkmanagerPlugin.setPluginRegistrantCallback { registry in
  GeneratedPluginRegistrant.register(with: registry)
}
            WorkmanagerPlugin.registerTask(withIdentifier: "task-identifier")
             WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "task-identifier4")
             WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "firebaseSyncPeriodic", frequency: NSNumber(value: 20 * 60))
             UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
