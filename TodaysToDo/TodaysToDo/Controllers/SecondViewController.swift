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
    }
    
    override func viewDidLayoutSubviews() {
        // チュートリアル画面を表示する
        if let firstLaunch = UserDefaults.standard.value(forKey: "firstLaunch") as? Bool {
            UserDefaults.standard.set(firstLaunch, forKey: "firstLaunch")
        } else {
            let storyboard: UIStoryboard = self.storyboard!
            let tutorialFirstViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")
            self.present(tutorialFirstViewController, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
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
        
        // Realmからデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "%@ =< startDateTime AND startDateTime < %@", getBeginingAndEndOfToday().beginingOfToday as CVarArg, getBeginingAndEndOfToday().endOfToday as CVarArg)
            todaysTodoList = realm.objects(ToDo.self).filter(predicate).sorted(byKeyPath: "startDateTime")
        } catch {
        }
        
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
        
        presentModal()
    }
    
    // モーダル表示処理
    func presentModal() {
        guard let hasEvent = UserDefaults.standard.value(forKey: "hasEvent") as! Bool? else {
            return
        }
        
        if hasEvent {
            var doneList: Results<ToDo>!
            do {
                let realm = try Realm()
                let predicate = NSPredicate(format: "done = true")
                doneList = realm.objects(ToDo.self).filter(predicate)
            } catch {
            }
            if doneList.count == 3 {
                // モーダルを表示
                performSegue(withIdentifier: "ModalSegue", sender: nil)
            }
        }
    }
}

