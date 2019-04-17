//
//  AppDelegate.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

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


}

