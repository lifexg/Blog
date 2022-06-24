//
//  Reducer.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation

typealias Reducer = (MainPageAction, MainPageState) -> MainPageState

func mainPageReducer(action: MainPageAction, state: MainPageState) -> MainPageState {
  var state = state
  switch action {
  case .onClickRefresh:
    state.classificationList()
  case .refresh(let list):
    state.list = list
  }
  return state
}

//typealias Reducer<ReducerStateType> = (_ action:Action, _ state: ReducerStateType?) -> ReducerStateType
//
//func mainPageReducer(action: Action, state: MainPageState?) -> MainPageState {
//  var state = state ?? MainPageState()
//  switch action {
//  case _ as MainPageOnClickRefreshAction:
//    state.classificationList()
//  case let action as MainPageRefreshAction:
//    state.list = action.list
//  default:
//    break
//  }
//  return state
//}
