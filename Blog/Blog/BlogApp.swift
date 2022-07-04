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
  //  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @Environment(\.scenePhase) private var scenePhase
  var body: some Scene {
    WindowGroup {
      BGBookMarksPage(store: ObservableStore(store: bookMarksPageStore))
        .environment(\.managedObjectContext, BGCoreDataManager.shared.classificationContainer.viewContext)
//        .onOpenURL { url in
//          BlogContentView(webViewModel: WebViewModel(url: url.absoluteString))
//        }
    }
  }
}
