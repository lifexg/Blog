//
//  Action.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift

struct BGBookMarksPageOnClickRefreshAction: Action {}

struct BGBookMarksPageRefreshAction: Action {
  var list: [Classification]
}

struct BGBookMarksPageAddFolderAction: Action {
}

struct BGBookMarksPageAddFolderTextAlertAction: Action {
  let name: String
}

struct BGBookMarksPageDeleteAction: Action {
  let index: IndexSet
}
