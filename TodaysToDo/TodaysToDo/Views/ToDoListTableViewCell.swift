//
//  ToDoListTableViewCell.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

protocol ToDoListTableViewCellDelegate {
    // セル内容の設定
    func setCellContents(_ cell: ToDoListTableViewCell, _ toDoTitle: UILabel)
    // タスクの名前をタップした時の処理
    func didTappedToDoTitle(_ cell: ToDoListTableViewCell)
    // 「設定」ボタンタップ時の処理
    func didTappedStartDateTimeButton(_ cell: ToDoListTableViewCell, _ startDateTime: DatePickerKeyboard)
}

class ToDoListTableViewCell: UITableViewCell {

    @IBOutlet weak private var toDoTitle: UILabel!
    @IBOutlet weak private var startDateTime: DatePickerKeyboard!
    var toDoListTableViewCellDelegate: ToDoListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapToDoTitleGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapToDoTitle(_:)))
        toDoTitle.addGestureRecognizer(tapToDoTitleGesture)
        toDoTitle.adjustsFontSizeToFitWidth = true
        toDoTitle.isUserInteractionEnabled = true
        self.toDoListTableViewCellDelegate?.setCellContents(self, toDoTitle)
    }
    
    @objc func tapToDoTitle(_ sender: UITapGestureRecognizer) {
        self.toDoListTableViewCellDelegate?.didTappedToDoTitle(self)
    }
    
    @IBAction func tapStartDateTimeButton(_ sender: UIButton) {
        self.toDoListTableViewCellDelegate?.didTappedStartDateTimeButton(self, startDateTime)
    }
}
