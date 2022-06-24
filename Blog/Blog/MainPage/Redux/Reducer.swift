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
