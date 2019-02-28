//
//  NSNotification+Extension.swift
//  TodaysToDo
//
//  Created by rMac on 2019/02/28.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

extension NSNotification{
    // 表示されるキーボードの最小Y座標を取得
    func getKeybordFrameMinY() -> CGFloat?{
        let keyboardFrame:NSValue? = self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keybordFrameMinY = keyboardFrame?.cgRectValue.minY
        return keybordFrameMinY
    }
    
    // キーボードの開く時間を取得
    func getShowKeyboardTime() -> TimeInterval?{
        let showKeyboardTime:TimeInterval? = self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        return showKeyboardTime
    }
}

