//
//  Action.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation

//protocol Action {}
//
//struct MainPageOnClickRefreshAction: Action {}
//struct MainPageRefreshAction: Action {
//  var list: [Classification]
//}

enum MainPageAction {
  case onClickRefresh
  case refresh(list: [Classification])
}

