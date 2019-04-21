//
//  ThirdViewController.swift
//  UIScrolllView_carousel
//
//  Created by rMac on 2019/04/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TutorialThirdViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "タスクを左にスワイプすることで削除することができます。Inbox画面でしか追加したタスクを削除できません！"
        //表示可能最大行数を指定
        descriptionLabel.numberOfLines = 10
        //contentsのサイズに合わせてobujectのサイズを変える
        descriptionLabel.sizeToFit()
    }
}
