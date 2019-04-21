//
//  SettingViewController.swift
//  TodaysToDo
//
//  Created by rMac on 2019/04/14.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingTableViewController: UITableViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var initPageCell: UITableViewCell!
    @IBOutlet weak var initPageLabel: UILabel!
    @IBOutlet weak var eventCell: UITableViewCell!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var tutorialCell: UITableViewCell!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var requestMailCell: UITableViewCell!
    @IBOutlet weak var requestReviewCell: UITableViewCell!
    @IBOutlet weak var twitterAccountOfDeveloperCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アプリのバージョン
        if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            versionLabel.text = version
        }
        
        // 「起動時の初期画面」セルがタップされた時のgestureをinitLabelに設定
        let tapInitPageLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeInitPage(_:)))
        initPageCell.addGestureRecognizer(tapInitPageLabel)
        
        guard let initPageIndex = UserDefaults.standard.value(forKey: "initPageIndex") as! Int? else {
            return
        }
        
        if initPageIndex == 1 {
            initPageLabel.text = "TodaysToDo"
        } else if initPageIndex == 2 {
            initPageLabel.text = "Calendar"
        } else {
            initPageLabel.text = "Inbox"
        }
        
        // 「タスク完了時のイベント」セルがタップされた時のgestureをisEventLabelに設定
        let tapEventLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeEventLabel(_:)))
        eventCell.addGestureRecognizer(tapEventLabel)
        
        guard let hasEvent = UserDefaults.standard.value(forKey: "hasEvent") as! Bool? else {
            return
        }
        
        if hasEvent {
            eventLabel.text = "表示"
        } else {
            eventLabel.text = "非表示"
        }
        
        // 「チュートリアルをみる」セルがタップされた時のgestureをisEventLabelに設定
        let tapTutorialCell: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTutorialPage(_:)))
        tutorialCell.addGestureRecognizer(tapTutorialCell)
        
        // 「ご意見・ご要望」セルが押された時のgesture
        let tapRequestMailCell: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sendRequestMail(_:)))
        requestMailCell.addGestureRecognizer(tapRequestMailCell)
        
        // 「アプリを評価する」セルが押された時のgesture
        let tapRequestReviewCell: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(requestReview(_:)))
        requestReviewCell.addGestureRecognizer(tapRequestReviewCell)
        
        // 「開発者のTwitter」セルが押された時のgesture
        let tapTwitterAccountOfDeveloperCell: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTwitter(_:)))
        twitterAccountOfDeveloperCell.addGestureRecognizer(tapTwitterAccountOfDeveloperCell)
    }
    
    // セッションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // セッション内のセルの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // それぞれのセクションにいくつセルがあるかを返す
        switch section {
        case 0: // 「一般」のセクション
            return 3
        case 1: // 「アプリについて」のセクション
            return 4
        default:
            return 0
        }
    }
    
    // 初期画面を変更する
    @objc func changeInitPage(_ sender: UITapGestureRecognizer) {
        guard let initPageIndex = UserDefaults.standard.value(forKey: "initPageIndex") as! Int? else {
            return
        }
        
        if initPageIndex == 1 {
            initPageLabel.text = "Calendar"
            UserDefaults.standard.set(2, forKey: "initPageIndex")
        } else if initPageIndex == 2 {
            initPageLabel.text = "Inbox"
            UserDefaults.standard.set(0, forKey: "initPageIndex")
        } else {
            initPageLabel.text = "TodaysToDo"
            UserDefaults.standard.set(1, forKey: "initPageIndex")
        }
    }
    
    @objc func changeEventLabel(_ sender: UITapGestureRecognizer) {
        guard let hasEvent = UserDefaults.standard.value(forKey: "hasEvent") as! Bool? else {
            return
        }
        
        if hasEvent {
            eventLabel.text = "非表示"
            UserDefaults.standard.set(false, forKey: "hasEvent")
        } else {
            eventLabel.text = "表示"
            UserDefaults.standard.set(true, forKey: "hasEvent")
        }
    }
    
    @objc func openTutorialPage(_ sender: UITapGestureRecognizer) {
        
        let storyboard: UIStoryboard = self.storyboard!
        
        let tutorialFirstViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")
        
        self.present(tutorialFirstViewController, animated: true, completion: nil)
    }
    
    // メーラーを起動する
    @objc func sendRequestMail(_ sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["naipakalab@gmail.com"]) // 宛先アドレス
            mail.setSubject("お問い合わせ") // 件名
            mail.setMessageBody("ご意見・ご要望をお書きください。", isHTML: false) // 本文
            present(mail, animated: true, completion: nil)
        } else {
            print("送信できません")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書き保存")
        case .sent:
            print("送信成功")
        default:
            print("送信失敗")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // セルがタップされた時の処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // アプリページを開く
    @objc func requestReview(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://itunes.apple.com/app/id1460136681?action=write-review") else { return }
        UIApplication.shared.open(url)
        }
    
    // twitterを開く
    @objc func openTwitter(_ sender: UITapGestureRecognizer) {
        
        if UIApplication.shared.canOpenURL(URL(string: "twitter://")!) {
            guard let twitterUrl = URL(string: "twitter://user?id=1062642312633667584") else { return }
            UIApplication.shared.open(twitterUrl)
        } else {
            guard let url = URL(string: "https://twitter.com/naipakapaka") else { return }
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
    
}
