//
//  Action.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift

struct MainPageOnClickRefreshAction: Action {}
struct MainPageRefreshAction: Action {
  var list: [Classification]
}
