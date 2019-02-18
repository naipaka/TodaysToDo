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
    var submitFormY:CGFloat = 0.0
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
        
        // Buttonにジェスチャーを追加
        let tapButton: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addToDo(_:)))
        self.addButton.isUserInteractionEnabled = true
        self.addButton.addGestureRecognizer(tapButton)
        
        // Realmからデータを取得
        do{
            let realm = try Realm()
            let predicate = NSPredicate(format: "startDate = ''")
            todoList = realm.objects(ToDo.self).filter(predicate)
        }catch{
        }
        // tableViewにカスタムセルを登録
        todoListTableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDoListTableViewCell")
        todoListTableView.tableFooterView = UIView()
        todoListTableView.reloadData()
        
        // 通知センターの取得
        let notification =  NotificationCenter.default
        
        // keyboardのframe変化時
        notification.addObserver(self,
                                 selector: #selector(self.keyboardChangeFrame(_:)),
                                 name: UIResponder.keyboardDidChangeFrameNotification,
                                 object: nil)
        
        // keyboard登場時
        notification.addObserver(self,
                                 selector: #selector(self.keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification,
                                 object: nil)
        
        // keyboard退場時
        notification.addObserver(self,
                                 selector: #selector(self.keyboardDidHide(_:)),
                                 name: UIResponder.keyboardDidHideNotification,
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
        cell.todoText.text = todoList[indexPath.row].ToDo
        cell.todoText.adjustsFontSizeToFitWidth = true
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
                newToDo.ToDo = todoTextField.text!
                
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
                        self.todoList[cellIndex].ToDo = todoTextField.text!
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
        todoTextField.text = todoList[row!].ToDo
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
        addButton.setTitle("追加", for: .normal)
        todoTextField.becomeFirstResponder()
        showKeyboardButton.isEnabled = false
        selectKeyboard = 1
    }
    
    // キーボード退出
    @IBAction func closeKeyboard(_ sender: Any) {
        todoTextField.text = ""
        view.endEditing(true)
        showKeyboardButton.isEnabled = true
        selectKeyboard = 0
    }
    
    // キーボードのフレーム変化時の処理
    @objc func keyboardChangeFrame(_ notification: NSNotification) {
        if selectKeyboard == 1 {
            // keyboardのframeを取得
            let userInfo = (notification as NSNotification).userInfo!
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            // submitFormの最大Y座標と、keybordの最小Y座標の差分を計算
            let diff = self.submitForm.frame.maxY -  keyboardFrame.minY
            
            if (diff > 0) {
                //submitFormのbottomの制約に差分をプラス
                self.submitFormBottom.constant += diff
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // キーボード登場時の処理
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // 現在のsubmitFormの最大Y座標を保存
        submitFormY = self.submitForm.frame.maxY
    }
    
    //キーボードが退場時の処理
    @objc func keyboardDidHide(_ notification: NSNotification) {
        //submitFormのbottomの制約を元に戻す
        self.submitFormBottom.constant = -submitFormY
        self.view.layoutIfNeeded()
    }


}

