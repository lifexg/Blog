//
//  Store.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation

class MainPageStore: ObservableObject {
  
  private let reducer: Reducer
  @Published public var state: MainPageState

  init(state: MainPageState, reducer: @escaping Reducer) {
    self.state = state
    self.reducer = reducer
  }
  
  func dispatch(action: MainPageAction) {
    self.state = self.reducer(action, state)
  }
}

extension MainPageState {
  func classificationList() {
    Task {
      let list = await Classification.classifications()
      mainPageStore.dispatch(action: .refresh(list: list))
    }
  }
}
