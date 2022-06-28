//
//  BGCoreDataManager.swift
//  Blog
//
//  Created by fexg on 2022/6/28.
//

import Foundation
import CoreData

struct BGCoreDataManager {
  static let shared = BGCoreDataManager()
  
  let classificationContainer: NSPersistentCloudKitContainer
  let classificationDetailContainer: NSPersistentCloudKitContainer
  
  init() {
    classificationContainer = NSPersistentCloudKitContainer(name: "ClassificationModel")
    classificationContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    classificationContainer.viewContext.automaticallyMergesChangesFromParent = true
    
    classificationDetailContainer = NSPersistentCloudKitContainer(name: "ClassificationDetailModel")
    classificationDetailContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    classificationDetailContainer.viewContext.automaticallyMergesChangesFromParent = true
  }
}
