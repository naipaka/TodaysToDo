//
//  AppDelegate.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // 設定済みのタスクリストを取得
        var settedToDoList: Results<ToDo>!
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "startDateTime != nil AND done = false")
            settedToDoList = realm.objects(ToDo.self).filter(predicate)
        } catch {
        }
        
        for settedToDo in settedToDoList {
            
            //　通知設定に必要なクラスをインスタンス化
            let trigger: UNNotificationTrigger
            let content = UNMutableNotificationContent()
            var notificationTime = DateComponents()
            
            // トリガー設定
            var tmpDateComponents = DateComponents()
            tmpDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: settedToDo.startDateTime!)
            notificationTime.year = tmpDateComponents.year
            notificationTime.month = tmpDateComponents.month
            notificationTime.day = tmpDateComponents.day
            notificationTime.hour = tmpDateComponents.hour
            notificationTime.minute = tmpDateComponents.minute
            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
            
            // 通知内容の設定
            content.title = "タスクを始める時間です！"
            content.body = settedToDo.title
            content.sound = UNNotificationSound.default
            
            // 通知スタイルを指定
            let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
            // 通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

