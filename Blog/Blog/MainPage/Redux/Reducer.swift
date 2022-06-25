//
//  Reducer.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift

func mainPageReducer(action: Action, state: MainPageState?) -> MainPageState {
  var state = state ?? MainPageState()
  switch action {
  case _ as MainPageOnClickRefreshAction:
    state.classificationList()
  case let action as MainPageRefreshAction:
    state.list = action.list
  default:
    break
  }
  return state
}
