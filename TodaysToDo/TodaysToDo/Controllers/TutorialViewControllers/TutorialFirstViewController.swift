//
//  FirstViewController.swift
//  UIScrolllView_carousel
//
//  Created by rMac on 2019/04/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TutorialFirstViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Inbox画面ではタスクを思いつく度どんどん追加していきましょう！真ん中のボタンを押すことでタスクを追加することができます。"
        //表示可能最大行数を指定
        descriptionLabel.numberOfLines = 10
        //contentsのサイズに合わせてobujectのサイズを変える
        descriptionLabel.sizeToFit()
    }
}
