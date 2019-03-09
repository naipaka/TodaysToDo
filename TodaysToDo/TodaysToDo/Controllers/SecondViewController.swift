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
        cell.doneLine.isHidden = true
        cell.todaysToDoView.layer.cornerRadius = 30
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchDoneFlg(_:)))
        cell.todaysToDoView.addGestureRecognizer(tap)
        
        return cell
    }
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHigh = todaysToDoTableView.bounds.height
        let cellHigh = tableViewHigh/3
        return cellHigh
    }
    
    // セルタップ時の処理
    @objc func switchDoneFlg(_ sender: UITapGestureRecognizer){
        
        guard let todaysToDoView = sender.view else {
            return
        }
        guard let cell = todaysToDoView.superview?.superview as? TodaysToDoTableViewCell else {
            return
        }
        
        // セルの背景色と実行線の切り替え
        if cell.doneLine.isHidden {
            cell.doneLine.isHidden = false
            cell.startTime.textColor = UIColor.white
            cell.todaysToDo.textColor = UIColor.white
            todaysToDoView.backgroundColor = UIColor(displayP3Red: 1.03898, green: 0.745736, blue: 0.275342, alpha: 1)
        } else {
            cell.doneLine.isHidden = true
            cell.startTime.textColor = UIColor.black
            cell.todaysToDo.textColor = UIColor.black
            todaysToDoView.backgroundColor = UIColor.white
        }
    }
}

