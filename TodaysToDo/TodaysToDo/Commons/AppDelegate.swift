//
//  AppDelegate.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userNotification = UserNotification()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 初期ページを保存or取得する
        if let initPageIndex = UserDefaults.standard.value(forKey: "initPageIndex") as? Int {
            UserDefaults.standard.set(initPageIndex, forKey: "initPageIndex")
        } else {
            UserDefaults.standard.set(1, forKey: "initPageIndex")
        }
        
        // 初期設定
        if let hasEvent = UserDefaults.standard.value(forKey: "hasEvent") as? Bool {
            UserDefaults.standard.set(hasEvent, forKey: "hasEvent")
        } else {
            UserDefaults.standard.set(true, forKey: "hasEvent")
        }
        
        // 初期画面を設定する
        if let tabvc = self.window!.rootViewController as? UITabBarController  {
            if let initPageIndex = UserDefaults.standard.value(forKey: "initPageIndex") as? Int {
                tabvc.selectedIndex = initPageIndex
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        userNotification.setBadgeCount()
        userNotification.setUserNotification()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        userNotification.setBadgeCount()
        userNotification.setUserNotification()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        userNotification.setBadgeCount()
        userNotification.setUserNotification()
    }
    
    func applicationSignificantTimeChange(_ applicatio: UIApplication) {
        userNotification.setBadgeCount()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラートと音で通知
        completionHandler([.alert, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        
    }
}

