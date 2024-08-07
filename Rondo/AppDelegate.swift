//
//  AppDelegate.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import UIKit
import UserNotifications
import Leanplum
import CleverTapSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let context = AppContext()
    var window: UIWindow?
    
    var notificationOptions: UNNotificationPresentationOptions = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        application.applicationIconBadgeNumber = 0
        
        Leanplum.setLogLevel(LeanplumLogLevel.debug)
        
        let ctCallback = CleverTapInstanceCallback(callback: { cleverTapInstance in
            Log.print("CleverTapInstance created")
            // Enable IP location
            cleverTapInstance.enableDeviceNetworkInfoReporting(true)
            cleverTapInstance.setPushNotificationDelegate(self)
        })
        Leanplum.addCleverTapInstance(callback: ctCallback)
        
        // Start Leanplum
        do {
            try context.start(with: context.app, environment: context.env) { success in
                Log.print("Leanplum started \(success ? "successfully" : "unsuccessfully").")
            }
        } catch {
            // add alert
            Log.print("Unexpected error: \(error).")
        }
        
        window?.rootViewController = TabViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(notificationOptions)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension UIApplication {
    var appDelegate: AppDelegate {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        
        assertionFailure("Failed to get AppDelegate")
        
        return AppDelegate()
    }
}

extension AppDelegate: CleverTapPushNotificationDelegate {
    public func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        let extras = customExtras ?? [:]
        Log.print("Push Notification Tapped with Custom Extras: \(extras)")
    }
}
