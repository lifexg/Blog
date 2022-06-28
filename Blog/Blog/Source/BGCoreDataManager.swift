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
  
  init() {
    classificationContainer = NSPersistentCloudKitContainer(name: "ClassificationModel")
    classificationContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    classificationContainer.viewContext.automaticallyMergesChangesFromParent = true
  }
}

extension ClassificationDetailModel {
  
  @nonobjc public class func fetchRequest(type: UUID) -> NSFetchRequest<ClassificationDetailModel> {
    let request = NSFetchRequest<ClassificationDetailModel>(entityName: "ClassificationDetailModel")
    request.predicate = NSPredicate(format: "classification_type = %@", type as CVarArg)
    request.sortDescriptors = [NSSortDescriptor(keyPath: \ClassificationDetailModel.sort, ascending: true)]
    return request
  }
}
