//
//  ThirdViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class ThirdViewController: UIViewController,FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    let SUNDAY_INDEX = 1
    let SATURDAY_INDEX = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートの設定
        calendar.dataSource = self
        calendar.delegate = self
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
    
//    @IBAction func nextTapped(_ sender:UIButton) {
//        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
//        print("a")
//    }
//
//    @IBAction  func previousTapped(_ sender:UIButton) {
//        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
//    }
//
//    func getNextMonth(date:Date)->Date {
//        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
//    }
//
//    func getPreviousMonth(date:Date)->Date {
//        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
//    }
}
