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
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "【Todays ToDo画面】今日に設定されたタスクが表示されます。1日に入れられるタスクは３つまでです！一日に３つできれば十分なのです。"
        //表示可能最大行数を指定
        descriptionLabel.numberOfLines = 10
        //contentsのサイズに合わせてobujectのサイズを変える
        descriptionLabel.sizeToFit()
        
        skipButton.layer.cornerRadius = 10
    }
    
    @IBAction func skip(_ sender: UIButton) {
        dispCloseTutorialAlert()
    }
    
    // 日付を設定できない時のアラート表示メソッド
    func dispCloseTutorialAlert() {
        let alertController:UIAlertController = UIAlertController(
            title: "チュートリアルを終了しますか？",
            message: "チュートリアルは設定からいつでも見返せます。",
            preferredStyle:  UIAlertController.Style.alert
        )
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK！", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            // 画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { (action: UIAlertAction) in
            // 設定をキャンセルする
            return
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
