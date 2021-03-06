//
//  ToDo.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import RealmSwift

class ToDo: Object {
    // todoのタイトル
    @objc dynamic var title = ""
    // 開始日時
    @objc dynamic var startDateTime: Date?
    // 追加日時
    @objc dynamic var addDate = ""
    // 実行済み
    @objc dynamic var done = false
}
