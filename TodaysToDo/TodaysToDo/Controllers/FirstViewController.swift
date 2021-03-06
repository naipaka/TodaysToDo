//
//  FirstViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ToDoListTableViewCellDelegate, TabBarDelegate, UNUserNotificationCenterDelegate {

    // キーボード出現ボタン
    @IBOutlet weak var showKeyboardButton: UIButton!
    // 追加フォーム
    @IBOutlet weak var submitForm: UIView!
    // 追加フォームのtextField
    @IBOutlet weak var todoTextField: UITextField!
    // 追加フォームの追加ボタン
    @IBOutlet weak var addButton: UIButton!
    // 追加フォームの最小y座標
    @IBOutlet weak var submitFormBottom: NSLayoutConstraint!
    // todoListのテーブル
    @IBOutlet weak var todoListTableView: UITableView!
    
    var todoList: Results<ToDo>!
    // 送信フォームの最小Y座標
    var submitFormY:CGFloat = -50
    // カスタムセルの高さ
    let cellHeigh:CGFloat = 150
    // カスタムセルの行番号
    var cellIndex:Int = 0
    // textKeyboard(1)かDataPickerKeyborad(0)の判断
    var selectKeyboard = 0
    // 1日に設定できるタスクの最大数
    private static let maxToDoListCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        // tableViewをスワイプ時、keyboardを下げる
        todoListTableView.keyboardDismissMode = .onDrag
        
        // Buttonにジェスチャーを追加
        let tapButton: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addToDo(_:)))
        self.addButton.isUserInteractionEnabled = true
        self.addButton.addGestureRecognizer(tapButton)
        
        // Realmからデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "startDateTime = nil")
            todoList = realm.objects(ToDo.self).filter(predicate)
        } catch {
        }
        // tableViewにカスタムセルを登録
        todoListTableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDoListTableViewCell")
        todoListTableView.tableFooterView = UIView()
        todoListTableView.reloadData()
        
        // 通知センターの登録
        registerNotification()
    }
    
    private func registerNotification() {
        // 通知センターの取得
        let notification =  NotificationCenter.default
        
        // keyboard登場前
        notification.addObserver(self,
                                 selector: #selector(self.willShowSubmitForm(_:)),
                                 name: UIResponder.keyboardWillShowNotification,
                                 object: nil)
        // keyboard退場前
        notification.addObserver(self,
                                 selector: #selector(self.willHideSubmitForm(_:)),
                                 name: UIResponder.keyboardWillHideNotification,
                                 object: nil)
    }
    
    // 画面が表示される直前にtableViewを更新
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoListTableView.reloadData()
    }
    
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoListTableView.dequeueReusableCell(withIdentifier: "ToDoListTableViewCell", for: indexPath) as! ToDoListTableViewCell
        // TableviewCellDelegateをselfで受け取る設定をし、ToDoのデータを渡す。
        cell.configure(with: todoList[indexPath.row], delegate: self)
        
        return cell
    }
    
    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.todoList[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            } catch {
            }
        }
        // ToDoの編集中に編集対象のタスクを削除するとエラーになる
        // そのため、削除した際は、キーボードを下げる処理を実装
        todoTextField.text = ""
        todoListTableView.reloadData()
        view.endEditing(true)
    }
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeigh
    }
    
    // ToDoの追加および変更
    @objc func addToDo(_ sender: UITapGestureRecognizer) {
        if todoTextField.text != ""  {
            if addButton.titleLabel?.text == "追加" {
                
                let newToDo = ToDo()
                newToDo.title = todoTextField.text!
                
                do {
                    let realm = try Realm()
                    try realm.write({ () -> Void in
                        realm.add(newToDo)
                    })
                } catch {
                }
                todoTextField.text = ""
            } else {
                // Realm内のデータを編集
                do {
                    let realm = try Realm()
                    try realm.write {
                        self.todoList[cellIndex].title = todoTextField.text!
                    }
                } catch {
                }
                todoTextField.text = ""
                view.endEditing(true)
                showKeyboardButton.isEnabled = true
            }
        }
        todoListTableView.reloadData()
    }
    
    // ToDoの編集
    @objc func didTappedToDoTitle(_ cell: ToDoListTableViewCell) {
        guard let row = todoListTableView.indexPath(for: cell)?.row else {
            return
        }
        cellIndex = row
        todoTextField.text = todoList[row].title
        addButton.setTitle("変更", for: .normal)
        selectKeyboard = 1
        todoTextField.becomeFirstResponder()
    }
    
    // キーボード出現
    @IBAction func showKeyboard(_ sender: Any) {
        selectKeyboard = 1
        addButton.setTitle("追加", for: .normal)
        todoTextField.becomeFirstResponder()
    }
    
    // キーボード退出
    @IBAction func hideKeyboard(_ sender: Any) {
        todoTextField.text = ""
        view.endEditing(true)
    }
    
    // submitFormを追従出現させる
    @objc func willShowSubmitForm(_ notification: NSNotification) {
        if selectKeyboard == 1 {
            let showKeyboardTime = notification.getShowKeyboardTime()
            let keybordFrameMinY = notification.getKeybordFrameMinY()
            let submitFormMaxY = self.submitForm.frame.maxY
            let diff = submitFormMaxY - keybordFrameMinY!
            
            self.view.layoutIfNeeded()
            self.submitFormBottom.constant += diff
            UIView.animate(withDuration: showKeyboardTime!, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        showKeyboardButton.isEnabled = false
    }
    
    // submitFormを追従退場させる
    @objc func willHideSubmitForm(_ notification: NSNotification) {
        let showKeyboardTime = notification.getShowKeyboardTime()
        
        self.view.layoutIfNeeded()
        self.submitFormBottom.constant = submitFormY
        UIView.animate(withDuration: showKeyboardTime!,animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        showKeyboardButton.isEnabled = true
        selectKeyboard = 0
    }
    
    // レコードに日付を設定する
    @objc func didTappedStartDateTimeButton(_ cell: ToDoListTableViewCell, _ startDateTime: DatePickerKeyboard) {
        guard let row = todoListTableView.indexPath(for: cell)?.row else {
            return
        }
        
        if isOldDate(startDateTime){
            // 過去日に設定した時アラートを表示する
            dispCanNotSetOldDateAlert()
            return
        } else if isMaxToDoListCount(cell, startDateTime){
            // レコードに日付が設定できなければアラートを表示する
            dispCanNotSetMaxCountAlert()
            return
        }
        
        // Realm内にstartDateを設定
        do {
            let realm = try Realm()
            try realm.write {
                self.todoList[row].startDateTime = startDateTime.getDate()
            }
        } catch {
        }
        
        todoListTableView.reloadData()
        
        // 初めてのタスク追加時に通知の許可を得る
        getAllowNotification()
    }
    
    // 設定する日時が過去日：true
    func isOldDate(_ startDateTime: DatePickerKeyboard) -> Bool{
        // 設定しようとしている日の始まりと今日の始まりを取得
        let startDate = Calendar(identifier: .gregorian).startOfDay(for: startDateTime.getDate())
        let startToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        
        return startDate < startToday
    }
    
    // 設定しようとしている日にすでに設定されているタスク数が最大数：true
    func isMaxToDoListCount(_ cell: ToDoListTableViewCell, _ startDateTime: DatePickerKeyboard) -> Bool{
        // 設定しようとしている日にすでに設定されているタスクを格納するためのインスタンス
        var tmpToDoList: Results<ToDo>!
        
        // 設定しようとしている日の始まりと終わりを取得
        let startDate = Calendar(identifier: .gregorian).startOfDay(for: startDateTime.getDate())
        let nextDate = startDate + 24*60*60
        
        // 設定しようとしている日に設定されているタスクを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "%@ =< startDateTime AND startDateTime < %@", startDate as CVarArg, nextDate as CVarArg)
            tmpToDoList = realm.objects(ToDo.self).filter(predicate)
        } catch {
        }
        
        // 1日に設定できるタスクの限界数 >= 現在設定されているタスク数：true
        // それ以外：false
        return tmpToDoList.count >= FirstViewController.maxToDoListCount
    }
    
    // 過去の日時に設定しようとした時のアラート表示メソッド
    func dispCanNotSetOldDateAlert() {
        let alertController:UIAlertController = UIAlertController(
            title: "過去には設定できません！",
            message: "託せる相手は未来の自分だけ。",
            preferredStyle:  UIAlertController.Style.alert
        )
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "再設定", style: UIAlertAction.Style.cancel) { (action: UIAlertAction) in
            // 設定をキャンセルする
            return
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 日付を設定できない時のアラート表示メソッド
    func dispCanNotSetMaxCountAlert() {
        let alertController:UIAlertController = UIAlertController(
            title: "１つ１つを着実に！",
            message: "同じ日に設定できるタスクは\n３つまでです！",
            preferredStyle:  UIAlertController.Style.alert
        )
        
        let goCalendarPageAction: UIAlertAction = UIAlertAction(title: "Calendarへ", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            // Calendar画面へ遷移する
            let UINavigationController = self.tabBarController?.viewControllers?[2];
            self.tabBarController?.selectedViewController = UINavigationController;
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "再設定", style: UIAlertAction.Style.cancel) { (action: UIAlertAction) in
            // 設定をキャンセルする
            return
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(goCalendarPageAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 他画面から遷移した時にTableのデータを再読み込みする
    func didSelectTab(tabBarController: TabBarController) {
        // 日付が過ぎたタスクの処理
        do {
            let realm = try Realm()
            // 未達成の場合
            let oldPredicate = NSPredicate(format: "done = false AND startDateTime < %@", Calendar(identifier: .gregorian).startOfDay(for: Date()) as CVarArg)
            let oldTodoList = realm.objects(ToDo.self).filter(oldPredicate)
            for oldToDo in oldTodoList {
                try realm.write {
                    oldToDo.startDateTime = nil
                }
            }
            
            // 達成済みの場合
            let donePredicate = NSPredicate(format: "done = true AND startDateTime < %@", Calendar(identifier: .gregorian).startOfDay(for: Date()) as CVarArg)
            let doneTodoList = realm.objects(ToDo.self).filter(donePredicate)
            for doneToDo in doneTodoList {
                try realm.write {
                    realm.delete(doneToDo)                }
            }
            
        } catch {
        }
        todoListTableView.reloadData()
    }
    
    // 初めてタスクを追加した時に通知の許可を取得
    func getAllowNotification() {
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                if granted {
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                } else {
                }
            })
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
}
