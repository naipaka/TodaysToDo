//
//  TutorialFifthViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/04/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TutorialFifthViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "タスクが完了した時は対象のタスクをタップしましょう！日付が変わった時、完了済みになっているタスクは削除され、未完了のタスクはInbox画面に戻されます。"
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
