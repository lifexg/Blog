//
//  Store.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift

extension MainPageState {
  func classificationList() {
    Task {
      let list = await Classification.classifications()
      mainPageStore.dispatch(MainPageRefreshAction(list: list))
    }
  }
}

// MARK: ObservableState

public class ObservableStore<State>: ObservableObject {

    // MARK: Public properties
    
    @Published public var state: State
    
    // MARK: Private properties
    
    private var store: Store<State>
    
    // MARK: Lifecycle
    
    public init(store: Store<State>) {
        self.store = store
        self.state = store.state
        
        store.subscribe(self)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    // MARK: Public methods
    
    public func dispatch(_ action: Action) {
        store.dispatch(action)
    }
    
    public func dispatch(_ action: Action) -> () -> Void {
        {
            self.store.dispatch(action)
        }
    }
}

extension ObservableStore: StoreSubscriber {
    
    // MARK: - <StoreSubscriber>
    
    public func newState(state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
