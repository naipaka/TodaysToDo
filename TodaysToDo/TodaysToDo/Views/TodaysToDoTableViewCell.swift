//
//  TodaysToDoTableViewCell.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TodaysToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var todaysToDoCell: UIView!
    @IBOutlet weak var todaysToDoView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var todaysToDo: UILabel!
    @IBOutlet weak var doneLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneLine.isHidden = true
        todaysToDoView.layer.cornerRadius = 30
        
        let tapTodaysToDoViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTodaysToDoView(_:)))
        todaysToDoView.addGestureRecognizer(tapTodaysToDoViewGestureRecognizer)
    }
    
    @objc func tapTodaysToDoView(_ sender: UITapGestureRecognizer) {
        if doneLine.isHidden {
            doneLine.isHidden = false
            startTime.textColor = UIColor.white
            todaysToDo.textColor = UIColor.white
            todaysToDoView.backgroundColor = UIColor(displayP3Red: 1.03898, green: 0.745736, blue: 0.275342, alpha: 1)
        } else {
            doneLine.isHidden = true
            startTime.textColor = UIColor.black
            todaysToDo.textColor = UIColor.black
            todaysToDoView.backgroundColor = UIColor.white
        }
    }
    
}
