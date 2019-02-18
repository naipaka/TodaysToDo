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
    // ToDo
    @objc dynamic var ToDo = ""
    // 開始日時
    @objc dynamic var startDate = ""
    // 追加日時
    @objc dynamic var addDate = ""
}
