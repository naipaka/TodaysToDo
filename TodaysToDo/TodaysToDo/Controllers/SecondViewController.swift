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
            todaysTodoList = realm.objects(ToDo.self).filter(predicate)
        } catch {
        }
        
        // tableViewにカスタムセルを登録
        todaysToDoTableView.register(UINib(nibName: "TodaysToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodaysToDoTableViewCell")
        todaysToDoTableView.tableFooterView = UIView()
        todaysToDoTableView.allowsSelection = false
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
        
        // cellのインスタンス化時の設定
        cell.configure(with: todaysTodoList[indexPath.row], delegate: self)
        
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
    }
}

