//
//  ThirdViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar
import CalculateCalendarLogic

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, TabBarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarsToDoListTableView: UITableView!
    private var calendarsToDoList: Results<ToDo>!
    
    let SUNDAY_INDEX = 1
    let SATURDAY_INDEX = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        calendar.dataSource = self
        calendar.delegate = self
        calendarsToDoListTableView.delegate = self
        calendarsToDoListTableView.dataSource = self
        
        // Realmからデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "%@ =< startDateTime AND startDateTime < %@", getBeginingAndEndOfToday(Date()).beginingOfToday as CVarArg, getBeginingAndEndOfToday(Date()).endOfToday as CVarArg)
            calendarsToDoList = realm.objects(ToDo.self).filter(predicate).sorted(byKeyPath: "startDateTime")
        } catch {
        }
        calendar.reloadData()
        calendarsToDoListTableView.reloadData()
    }
    
    // 日の始まりと終わりを取得
    private func getBeginingAndEndOfToday(_ date:Date) -> (beginingOfToday: Date , endOfToday: Date) {
        let beginingOfToday = Calendar(identifier: .gregorian).startOfDay(for: date)
        let endOfToday = beginingOfToday + 24*60*60
        return (beginingOfToday, endOfToday)
    }
    
    // 祝日：true 祝日以外：false
    func isHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスの一時保存インスタンスを生成する
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // カレンダークラスのインスタンスから年月日を取得する
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // ライブラリ：CalculateCalendarLogic()を用いてカレンダーの日付が祝日かどうかを判断する
        return CalculateCalendarLogic().judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // 日曜日:1 〜 土曜日:7
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日・祝日によって日付の色を変更する
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        // 祝日：赤色
        if isHoliday(date) {
            return UIColor.red
        }
        
        // 土曜日：青色、日曜日：赤色
        let weekday = self.getWeekIdx(date)
        if weekday == SUNDAY_INDEX {
            return UIColor.red
        }
        else if weekday == SATURDAY_INDEX {
            return UIColor.blue
        }
        
        return nil
    }
    
    // 日付選択時の処理
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        // Realmからデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "%@ =< startDateTime AND startDateTime < %@", getBeginingAndEndOfToday(date).beginingOfToday as CVarArg, getBeginingAndEndOfToday(date).endOfToday as CVarArg)
            calendarsToDoList = realm.objects(ToDo.self).filter(predicate).sorted(byKeyPath: "startDateTime")
        } catch {
        }
        calendarsToDoListTableView.reloadData()
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarsToDoList.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "calendarsToDoCell", for: indexPath)
        
        // セルに表示する値を設定する
        let f = DateFormatter()
        f.timeStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        let strStartTime = f.string(from: calendarsToDoList[indexPath.row].startDateTime!)
        let strToDoTitle = calendarsToDoList[indexPath.row].title
        cell.textLabel!.text = strStartTime + " 〜　" + strToDoTitle
        
        return cell
    }
    
    // セル削除時の文言を設定
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Inboxへ"
    }
    
    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // 日付が過ぎたタスクの処理
            do {
                let realm = try Realm()
                try realm.write {
                    calendarsToDoList[indexPath.row].done = false
                    calendarsToDoList[indexPath.row].startDateTime = nil
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            } catch {
            }
            calendar.reloadData()
            calendarsToDoListTableView.reloadData()
        }
    }
    
    // タスクが設定されている日付に点マークをつける
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        var tmpCalendarsToDoList: Results<ToDo>!
        // Realmからデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "%@ =< startDateTime AND startDateTime < %@", getBeginingAndEndOfToday(date).beginingOfToday as CVarArg, getBeginingAndEndOfToday(date).endOfToday as CVarArg)
            tmpCalendarsToDoList = realm.objects(ToDo.self).filter(predicate)
        } catch {
        }
        return tmpCalendarsToDoList.count
    }
    
    // 他画面から遷移した時にTableのデータを再読み込みする
    func didSelectTab(tabBarController: TabBarController) {
        calendar.reloadData()
        calendarsToDoListTableView.reloadData()
    }
}
