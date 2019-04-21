//
//  TabBarDelegate.swift
//  TodaysToDo
//
//  Created by rMac on 2019/04/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

@objc protocol TabBarDelegate {
    func didSelectTab(tabBarController: TabBarController)
}
