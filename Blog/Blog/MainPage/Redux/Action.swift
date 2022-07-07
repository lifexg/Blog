//
//  Action.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift

struct BGBookMarksPageOnClickRefreshAction: Action {}

struct BGBookMarksPageAddFolderAction: Action {
}

struct BGBookMarksPageAddFolderTextAlertAction: Action {
  let name: String
  let index: Int64
}

struct BGBookMarksPageDeleteAction: Action {
  let item: ClassificationModel
}

struct BGBookMarksAddClassifcationLinkAction: Action {
  let name: String
  let link: String
  let index: Int64
  let item: ClassificationModel
}

struct BGBookMarksPageDeleteDetailAction: Action {
  let item: ClassificationDetailModel
}

struct BGBookMarksPageEditFolderNameAction: Action {
  let item: ClassificationModel
  let name: String
}

struct BGBookMarksPageEditDetailAction: Action {
  let item: ClassificationDetailModel
}

struct BGBookMarksPageReadDetailAction: Action {
  let name: String
  let link: String
}
