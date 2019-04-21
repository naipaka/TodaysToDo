//
//  UserNotification.swift
//  TodaysToDo
//
//  Created by rMac on 2019/04/17.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import UserNotifications
import RealmSwift

class UserNotification {
    
    // 通知設定を行う
    func setUserNotification() {
        // 設定済みのタスクリストを取得
        var settedToDoList: Results<ToDo>!
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        // 全てのpendingな通知を削除する
        center.removeAllPendingNotificationRequests()
        
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "done = false AND startDateTime > %@", Date() as CVarArg)
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
            let identifier = NSUUID().uuidString
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            // 通知をセット
            center.add(request, withCompletionHandler: nil)
        }
    }
    
    // バッチを設定する
    func setBadgeCount(){
        let notDoneToDoList: Results<ToDo>!
        var notDoneToDoListCount = 0
        // Realmからデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "done = false AND %@ =< startDateTime AND startDateTime < %@", getBeginingAndEndOfToday().beginingOfToday as CVarArg, getBeginingAndEndOfToday().endOfToday as CVarArg)
            notDoneToDoList = realm.objects(ToDo.self).filter(predicate).sorted(byKeyPath: "startDateTime")
            notDoneToDoListCount = notDoneToDoList.count
        } catch {
        }
        UIApplication.shared.applicationIconBadgeNumber = notDoneToDoListCount
    }
    
    // 今日の始まりと終わりを取得
    private func getBeginingAndEndOfToday() -> (beginingOfToday: Date , endOfToday: Date) {
        let beginingOfToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let endOfToday = beginingOfToday + 24*60*60
        return (beginingOfToday, endOfToday)
    }
}
