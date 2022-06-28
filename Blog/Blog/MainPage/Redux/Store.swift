//
//  Store.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift

extension BGBookMarksPageState {
  func classificationList() {
    Task {
      let list = await Classification.classifications()
      DispatchQueue.main.async {
        do {
          let context = BGCoreDataManager.shared.classificationContainer.viewContext
          let detailContext = BGCoreDataManager.shared.classificationDetailContainer.viewContext
        
          let classification = try context.fetch(ClassificationModel.fetchRequest())
          if classification.isEmpty {
            list.enumerated().forEach { (offset, item) in
              let type = UUID()
              let newItem = ClassificationModel(context: context)
              newItem.type = type
              newItem.name = item.name
              newItem.sort = Int64(offset)
              item.detail?.enumerated().forEach { (offset, detail) in
                let newItem = ClassificationDetailModel(context: context)
                newItem.type = UUID()
                newItem.name = detail.title
                newItem.classification_type = type
                newItem.link = detail.link
                newItem.sort = Int64(offset)
              }
            }
            try context.save()
            try detailContext.save()
          } else {
            print("nil")
//            let detailClassification = try context.fetch(ClassificationDetailModel.fetchRequest())
//            classification.forEach { item in
//              context.delete(item)
//            }
//            detailClassification.forEach { item in
//              detailContext.delete(item)
////              print(item.classification_type)
//            }
//            try context.save()
//            try detailContext.save()
          }
        } catch {
        }
      }
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
}

extension ObservableStore: StoreSubscriber {
    
    // MARK: - <StoreSubscriber>
    
    public func newState(state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
