//
//  ToDoListTableViewCell.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell {

    @IBOutlet weak var todoText: UILabel!
    @IBOutlet weak var startDateTime: DatePickerKeyboard!
    @IBOutlet weak var setStartDateTime: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
