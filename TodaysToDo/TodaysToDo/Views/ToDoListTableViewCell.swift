//
//  ToDoListTableViewCell.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

protocol ToDoListTableViewCellDelegate {
    // タスクの名前をタップした時の処理
    func didTappedToDoTitle(_ cell: ToDoListTableViewCell)
    // 「設定」ボタンタップ時の処理
    func didTappedStartDateTimeButton(_ cell: ToDoListTableViewCell, _ startDateTime: DatePickerKeyboard)
}

class ToDoListTableViewCell: UITableViewCell {

    @IBOutlet weak private var toDoTitle: UILabel!
    @IBOutlet weak private var startDateTime: DatePickerKeyboard!
    private var todo: ToDo?
    private var toDoListTableViewCellDelegate: ToDoListTableViewCellDelegate?
    
    @objc func tapToDoTitle(_ sender: UITapGestureRecognizer) {
        self.toDoListTableViewCellDelegate?.didTappedToDoTitle(self)
    }
    
    @IBAction func tapStartDateTimeButton(_ sender: UIButton) {
        self.toDoListTableViewCellDelegate?.didTappedStartDateTimeButton(self, startDateTime)
    }
    
    // Cellをインスタンス化した時に行うCellに対する設定メソッド
    func configure(with todo: ToDo, delegate: ToDoListTableViewCellDelegate) {
        // 引数delegateに処理をDelegateする設定をする
        toDoListTableViewCellDelegate = delegate
        // セルのToDoデータをcellのインスタンスに保持する
        self.todo = todo
        
        // ToDoのタイトルのtextを設定する
        toDoTitle.text = todo.title
        // ToDoのタイトルの文字の大きさを幅に合わせるように設定する
        toDoTitle.adjustsFontSizeToFitWidth = true
        // ToDoのタイトルをタップ可能に設定する。
        toDoTitle.isUserInteractionEnabled = true
        
        // タップした時の処理を設定する
        let tapToDoTitleGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapToDoTitle(_:)))
        // ToDoのタイトルに設定したGestureを設定する
        toDoTitle.addGestureRecognizer(tapToDoTitleGesture)
    }
}
