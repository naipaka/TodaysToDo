//
//  TodaysToDoTableViewCell.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

protocol TodaysToDoTableViewCellDelegate {
    // cellをタップした時の処理
    func didTappedTodaysToDoCell(_ cell: TodaysToDoTableViewCell, _ done: Bool)
}

class TodaysToDoTableViewCell: UITableViewCell {

    @IBOutlet weak private var todaysToDoCell: UIView!
    @IBOutlet weak private var todaysToDoView: UIView!
    @IBOutlet weak private var startTime: UILabel!
    @IBOutlet weak private var todaysToDo: UILabel!
    @IBOutlet weak private var doneLine: UIView!
    private var todaysToDoTableViewCellDelegate: TodaysToDoTableViewCellDelegate?
    
    override func awakeFromNib() {
        // doneLineの位置を調整する
        doneLine.frame =
            CGRect(x:((todaysToDoCell.bounds.width-320)/2),
                   y:((todaysToDoView.frame.maxY + todaysToDoView.frame.minY)/2),
                   width:todaysToDoCell.bounds.width,
                   height:10)
    }
    
    // cellをタップした時の処理
    @objc func tapTodaysToDoView(_ sender: UITapGestureRecognizer) {
        if doneLine.isHidden {
        self.todaysToDoTableViewCellDelegate?.didTappedTodaysToDoCell(self, true)
        } else {
        self.todaysToDoTableViewCellDelegate?.didTappedTodaysToDoCell(self, false)
        }
    }
    
    // Cellをインスタンス化した時に行うCellに対する設定メソッド
    func configure(with argTodaysToDo: ToDo, argDone: Bool, delegate: TodaysToDoTableViewCellDelegate) {
        // 引数delegateに処理をDelegateする設定をする
        todaysToDoTableViewCellDelegate = delegate
        // cellの形を丸枠にする
        todaysToDoView.layer.cornerRadius = 35
        // ToDoのタイトルのtextを設定する
        todaysToDo.text = argTodaysToDo.title
        // ToDoの開始時間を設定する
        startTime.text = toStringStartTime(startDateTime: argTodaysToDo.startDateTime!)
        
        
        // 実行状況に応じてセルのデザインを変える
        if argDone {
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
