//
//  Reducer.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift

func BGBookMarksPageReducer(action: Action, state: BGBookMarksPageState?) -> BGBookMarksPageState {
  var state = state ?? BGBookMarksPageState()
  switch action {
  case _ as BGBookMarksPageOnClickRefreshAction:
    state.classificationList()
  case let action as BGBookMarksPageRefreshAction:
    state.list = action.list
  case let action as BGBookMarksPageAddFolderTextAlertAction:
    var list = state.list
    list.append(Classification(type: action.name, name: action.name))
    state.list = list
  case let action as BGBookMarksPageDeleteAction:
    var list = state.list
    list.remove(atOffsets: action.index)
  default:
    break
  }
  return state
}
