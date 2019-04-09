//
//  TodaysToDoTableViewCell.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TodaysToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var todaysToDoCell: UIView!
    @IBOutlet weak var todaysToDoView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var todaysToDo: UILabel!
    @IBOutlet weak var doneLine: UIView!
    
    @objc func tapTodaysToDoView(_ sender: UITapGestureRecognizer) {
        if doneLine.isHidden {
            doneLine.isHidden = false
            startTime.textColor = UIColor.white
            todaysToDo.textColor = UIColor.white
            todaysToDoView.backgroundColor = UIColor(displayP3Red: 1.03898, green: 0.745736, blue: 0.275342, alpha: 1)
        } else {
            doneLine.isHidden = true
            startTime.textColor = UIColor.black
            todaysToDo.textColor = UIColor.black
            todaysToDoView.backgroundColor = UIColor.white
        }
    }
    
    // Cellをインスタンス化した時に行うCellに対する設定メソッド
    func configure(with argTodaysToDo: ToDo) {
        // cellの形を丸枠にする
        todaysToDoView.layer.cornerRadius = 30
        // ToDoのタイトルのtextを設定する
        todaysToDo.text = argTodaysToDo.title
        // ToDoの開始時間を設定する
        startTime.text = toStringStartTime(startDateTime: argTodaysToDo.startDateTime!)
        // 赤線の初期表示
        doneLine.isHidden = true
        
        // cellをタップした時のgesture
        let tapTodaysToDoViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTodaysToDoView(_:)))
        todaysToDoView.addGestureRecognizer(tapTodaysToDoViewGestureRecognizer)
    }
    
    // 開始時間の取得
    private func toStringStartTime(startDateTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja")
        let startTime = formatter.string(from: startDateTime)
        return startTime + " 〜"
    }
    
}
