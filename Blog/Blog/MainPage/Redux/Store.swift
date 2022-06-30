//
//  Store.swift
//  Blog
//
//  Created by fexg on 2022/6/24.
//

import Foundation
import ReSwift
import ReSwiftExtention
import CoreData

extension BGBookMarksPageState {
  func classificationList() {
    let key = "iCloudInitedKey"
    if !NSUbiquitousKeyValueStore.default.bool(forKey: key) {
      NSUbiquitousKeyValueStore.default.set(true, forKey: key)
      NSUbiquitousKeyValueStore.default.synchronize()
    } else {
      return
    }

    Task {
      let list = await Classification.classifications()
      DispatchQueue.main.async {
        do {
          let context = BGCoreDataManager.shared.classificationContainer.viewContext
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
          } else {
//            print("nil")
//            let detailClassification = try context.fetch(ClassificationDetailModel.fetchRequest())
//            classification.forEach { item in
//              context.delete(item)
//            }
//            detailClassification.forEach { item in
//              context.delete(item)
//            }
//            try context.save()
          }
        } catch {
          assertionFailure()
        }
      }
    }
  }
  
  func addClassification(name: String, index: Int64) {
    let context = BGCoreDataManager.shared.classificationContainer.viewContext
    let type = UUID()
    let newItem = ClassificationModel(context: context)
    newItem.type = type
    newItem.name = name
    newItem.sort = index
    do {
      try context.save()
    } catch {
      assertionFailure()
    }
  }
  
  func deleteClassification(item: ClassificationModel) {
    do {
      let context = BGCoreDataManager.shared.classificationContainer.viewContext
      let classification = try context.fetch(ClassificationDetailModel.fetchRequest(type: item.type ?? UUID()))
      context.delete(item)
      classification.forEach { item in
        context.delete(item)
      }
      try context.save()
    } catch {
      assertionFailure()
    }
  }
  
  func addClassificationDetail(name: String, type:UUID, link: String, index: Int64) {
    let detailContext = BGCoreDataManager.shared.classificationContainer.viewContext
    let newItem = ClassificationDetailModel(context: detailContext)
    newItem.type = UUID()
    newItem.name = name
    newItem.classification_type = type
    newItem.link = link
    newItem.sort = index
    do {
      try detailContext.save()
    } catch {
      assertionFailure()
    }
  }
  
  func deleteClassificationDetail(item: ClassificationDetailModel) {
    let context = BGCoreDataManager.shared.classificationContainer.viewContext
    context.delete(item)
    do {
      try context.save()
    } catch {
      assertionFailure()
    }
  }
  
  func editClassificationFolderName(item: ClassificationModel, name: String) {
    let context = BGCoreDataManager.shared.classificationContainer.viewContext
    item.name = name
    do {
      try context.save()
    } catch {
      assertionFailure()
    }
  }
  
  func editClassificationDetail(item: ClassificationDetailModel) {
    let context = BGCoreDataManager.shared.classificationContainer.viewContext
    do {
      try context.save()
    } catch {
      assertionFailure()
    }
  }

}

