//
//  AppDelegate.swift
//  BWM
//
//  Created by obozhdi on 10/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import GoogleMaps
import FacebookCore
import NotificationCenter
import UserNotifications
import SwiftyUserDefaults
import Kingfisher
import Flurry_iOS_SDK
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyDTSvi_smtlLvAfBggIVnEWzoTRRyGREBQ")
        
        let builder = FlurrySessionBuilder.init().withIncludeBackgroundSessions(inMetrics: true)
        
        Flurry.startSession("YD85T6DCRYRTZGM9NXY6", with: builder!
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))

        IAPHelper.shared.updatePurchasesInfo()
        self.registerForPushNotifications()
        if let value = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL {
            if value.host == "chat",
                let uid = Int(value.lastPathComponent){
                Store.shared.deepLinkChatUserId = uid
            }
        }
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            
            LocationManager.shared.updateSignificant()
            if Defaults[.liveTracking] == true {
                LocationManager.shared.sendLocationUpdate()

                let content = UNMutableNotificationContent()
                content.body = "Live location tracking still enabled"
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let theError = error {
                        print(theError)
                    }
                }
            }
        }
        else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }

        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            if let message = MessagePN(JSON: notification) {
                Store.shared.receivedMessagePushNotification = message
            }
            
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
            scheme.localizedCaseInsensitiveCompare("com.bwm_app.bookwithme") == .orderedSame {
        }
        else {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return true
    }
    
    //MARK: - Push notifications
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        Defaults[.pnToken] = token
        FlurryMessaging.setDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let _ = userInfo[Constants.Key.accountId],
        let aps = userInfo[Constants.Key.aps] as? [AnyHashable: Any],
            let count = aps[Constants.Key.badge] as? Int {
            UIApplication.shared.applicationIconBadgeNumber = count
            NotificationCenter.default.post(name: NSNotification.Name(Constants.Notification.newMessage), object: nil, userInfo: [Constants.Key.messageCount: count])
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
