//
//  SecondViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, TodaysToDoTableViewCellDelegate, TabBarDelegate {

    @IBOutlet weak var todaysToDoTableView: UITableView!
    
    var todaysTodoList: Results<ToDo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todaysToDoTableView.delegate = self
        todaysToDoTableView.dataSource = self
        
        // Realmからデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "%@ =< startDateTime AND startDateTime < %@", getBeginingAndEndOfToday().beginingOfToday as CVarArg, getBeginingAndEndOfToday().endOfToday as CVarArg)
            todaysTodoList = realm.objects(ToDo.self).filter(predicate).sorted(byKeyPath: "startDateTime")
        } catch {
        }
        
        // tableViewにカスタムセルを登録
        todaysToDoTableView.register(UINib(nibName: "TodaysToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodaysToDoTableViewCell")
        todaysToDoTableView.tableFooterView = UIView()
        todaysToDoTableView.allowsSelection = false
        
        // 通知センターの登録
        registerNotification()
    }
    
    // 今日の始まりと終わりを取得
    private func getBeginingAndEndOfToday() -> (beginingOfToday: Date , endOfToday: Date) {
        let beginingOfToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let endOfToday = beginingOfToday + 24*60*60
        return (beginingOfToday, endOfToday)
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaysTodoList.count
    }
    
    // cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todaysToDoTableView.dequeueReusableCell(withIdentifier: "TodaysToDoTableViewCell", for: indexPath) as! TodaysToDoTableViewCell
        
        // 実行状況を取得
        let isDone = todaysTodoList[indexPath.row].done
        
        // cellのインスタンス化時の設定
        cell.configure(with: todaysTodoList[indexPath.row], argDone: isDone, delegate: self)
        
        return cell
    }
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHigh = todaysToDoTableView.bounds.height
        let cellHigh = tableViewHigh/3
        return cellHigh
    }
    
    // 他画面から遷移した時にTableのデータを再読み込みする
    func didSelectTab(tabBarController: TabBarController) {
        todaysToDoTableView.reloadData()
    }
    
    // タスクがタップされた時の処理
    func didTappedTodaysToDoCell(_ cell: TodaysToDoTableViewCell, _ argDone: Bool) {
        guard let row = todaysToDoTableView.indexPath(for: cell)?.row else {
            return
        }
        // Realm内のデータを編集
        do {
            let realm = try Realm()
            try realm.write {
                self.todaysTodoList[row].done = argDone
            }
        } catch {
        }
        todaysToDoTableView.reloadData()
    }
    
    // バッチを設定する
    @objc func setBadgeCount(_ notification: NSNotification){
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
        print("aaaaaaaaaaaaaaaaaaaaa")
        UIApplication.shared.applicationIconBadgeNumber = notDoneToDoListCount
    }
    
    // 通知センターの登録
    private func registerNotification() {
        // 通知センターの取得
        let notification =  NotificationCenter.default
        
        // アプリが終了する直前
        notification.addObserver(
            self,
            selector: #selector(self.setBadgeCount(_:)),
            name:UIApplication.willTerminateNotification,
            object: nil)
        
        // アプリがバックグラウンドになるとき
        notification.addObserver(
            self,
            selector: #selector(self.setBadgeCount(_:)),
            name:UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
}

