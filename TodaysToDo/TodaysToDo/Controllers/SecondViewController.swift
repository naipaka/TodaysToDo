//
//  SecondViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todaysToDoTableView: UITableView!
    
    let startTime:[String] = ["10:00 〜", "13:00 〜", "15:00 〜"]
    let todaysToDo:[String] = ["村長の話を聞く", "防具を揃える", "近くの村へ行く"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todaysToDoTableView.delegate = self
        todaysToDoTableView.dataSource = self
        
        // tableViewにカスタムセルを登録
        todaysToDoTableView.register(UINib(nibName: "TodaysToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodaysToDoTableViewCell")
        todaysToDoTableView.tableFooterView = UIView()
        todaysToDoTableView.reloadData()
        todaysToDoTableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaysToDo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todaysToDoTableView.dequeueReusableCell(withIdentifier: "TodaysToDoTableViewCell", for: indexPath) as! TodaysToDoTableViewCell
        
        // カスタムセル内のプロパティ設定
        cell.todaysToDo.text = todaysToDo[indexPath.row]
        cell.startTime.text = startTime[indexPath.row]
        
        return cell
    }
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHigh = todaysToDoTableView.bounds.height
        let cellHigh = tableViewHigh/3
        return cellHigh
    }
}

