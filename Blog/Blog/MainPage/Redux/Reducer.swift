//
//  Reducer.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift
import SwiftUI

func BGBookMarksPageReducer(action: Action, state: BGBookMarksPageState?) -> BGBookMarksPageState {
  let state = state ?? BGBookMarksPageState()
  switch action {
  case _ as BGBookMarksPageOnClickRefreshAction:
    state.classificationList()
  case let action as BGBookMarksPageAddFolderTextAlertAction:
    state.addClassification(name: action.name, index: action.index)
  case let action as BGBookMarksPageDeleteAction:
    state.deleteClassification(item: action.item)
  case let action as BGBookMarksAddClassifcationLinkAction:
    state.addClassificationDetail(name: action.name, type: action.item.type ?? UUID(), link: action.link, index: action.index)
  case let action as BGBookMarksPageDeleteDetailAction:
    state.deleteClassificationDetail(item: action.item)
  case let action as BGBookMarksPageEditFolderNameAction:
    state.editClassificationFolderName(item: action.item, name: action.name)
  default:
    break
  }
  return state
}
