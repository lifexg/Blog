// MARK: ObservableState
import ReSwift
import Combine
import SwiftUI

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
}

extension ObservableStore: StoreSubscriber {
    
    // MARK: - <StoreSubscriber>
    public func newState(state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
