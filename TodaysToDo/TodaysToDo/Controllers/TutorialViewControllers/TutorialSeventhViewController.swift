//
//  TutorialSeventhViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/04/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class TutorialSeventhViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "タスクの設定日時を変えたいときはカレンダー下の一覧から対象のタスクをスライドしてInbox画面に戻しましょう。チュートリアルは以上です！"
        //表示可能最大行数を指定
        descriptionLabel.numberOfLines = 10
        //contentsのサイズに合わせてobujectのサイズを変える
        descriptionLabel.sizeToFit()
    }
    
    @IBAction func closeButton(_ sender: Any) {
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
