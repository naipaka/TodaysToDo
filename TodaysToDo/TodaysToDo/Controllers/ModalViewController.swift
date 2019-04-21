//
//  ModalViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/04/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet weak var congratulationsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景を半透明にする
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        congratulationsView.layer.cornerRadius = 25
    }
    
    @IBAction func closeModalView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
