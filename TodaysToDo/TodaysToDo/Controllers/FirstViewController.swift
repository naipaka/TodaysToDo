//
//  FirstViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        do{
            let realm = try Realm()
            let predicate = NSPredicate(format: "startDateTime = ''")
            todoList = realm.objects(ToDo.self).filter(predicate)
        }catch{
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
        // セル内のToDoをタップした時の処理
        let tapCellToDo: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.editToDo(_:)))
        cell.todoText.isUserInteractionEnabled = true
        cell.todoText.tag = indexPath.row
        cell.todoText.addGestureRecognizer(tapCellToDo)
        
        // カスタムセル内のプロパティ設定
        cell.todoText.text = todoList[indexPath.row].todo
        cell.todoText.adjustsFontSizeToFitWidth = true
        
        // セルの「設定」ボタン
        cell.setStartDateTime.addTarget(self, action: #selector(setStartDateTime(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.todoList[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
        }
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
                newToDo.todo = todoTextField.text!
                
                do{
                    let realm = try Realm()
                    try realm.write({ () -> Void in
                        realm.add(newToDo)
                    })
                }catch{
                }
                todoTextField.text = ""
            } else {
                // Realm内のデータを編集
                do{
                    let realm = try Realm()
                    try realm.write {
                        self.todoList[cellIndex].todo = todoTextField.text!
                    }
                }catch{
                }
                todoTextField.text = ""
                view.endEditing(true)
                showKeyboardButton.isEnabled = true
            }
        }
        todoListTableView.reloadData()
    }
    
    // ToDoの編集
    @objc func editToDo(_ sender: UITapGestureRecognizer) {
        let row = sender.view?.tag
        cellIndex = row!
        todoTextField.text = todoList[row!].todo
        addButton.setTitle("変更", for: .normal)
        todoTextField.becomeFirstResponder()
        selectKeyboard = 1
    }
    
    // ボタンのドラッグ
    @IBAction func dragingAddButton(_ sender: UIPanGestureRecognizer) {
        let addButton = sender.view!
        addButton.center = sender.location(in: self.view)
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
    @objc func setStartDateTime(_ sender: UIButton) {
        
        // ボタンが押されたcellを特定
        let cell = sender.superview?.superview?.superview?.superview as! ToDoListTableViewCell
        // cellのindex番号を取得
        let row = todoListTableView.indexPath(for: cell)?.row
        // Dateのフォーマットを設定
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "ja")
        let startDateTime = f.string(from: cell.startDateTime.getDate())
        
        // Realm内にstartDateを設定
        do{
            let realm = try Realm()
            try realm.write {
                self.todoList[row!].startDateTime = startDateTime
            }
        }catch{
        }
        
        todoListTableView.reloadData()
    }
}
