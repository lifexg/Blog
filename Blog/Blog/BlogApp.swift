//
//  BlogApp.swift
//  Blog
//
//  Created by fexg on 2022/6/16.
//

import SwiftUI
import ReSwiftExtention

@main
struct BlogApp: App {
  var body: some Scene {
    WindowGroup {
      BGBookMarksPage(store: ObservableStore(store: bookMarksPageStore))
        .environment(\.managedObjectContext, BGCoreDataManager.shared.classificationContainer.viewContext)
    }
  }
}
