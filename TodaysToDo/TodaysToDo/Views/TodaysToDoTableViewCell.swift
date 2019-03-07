//
//  TodaysToDoTableViewCell.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TodaysToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var todaysToDoView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var todaysToDo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
