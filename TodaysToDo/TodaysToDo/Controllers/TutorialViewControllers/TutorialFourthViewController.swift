//
//  TutorialFourthViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/04/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TutorialFourthViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Todays ToDo画面では「今日」に設定されたタスクが表示されます。1日に入れられるタスクは３つまでです！一度にたくさんは危険なのです。"
        //表示可能最大行数を指定
        descriptionLabel.numberOfLines = 10
        //contentsのサイズに合わせてobujectのサイズを変える
        descriptionLabel.sizeToFit()
    }
}
