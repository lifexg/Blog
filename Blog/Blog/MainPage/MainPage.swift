//
//  ContentView.swift
//  Blog
//
//  Created by fexg on 2022/6/16.
//

import SwiftUI
import ReSwiftExtention
import ReSwift
import Combine
import BGUI
import CoreData

let bookMarksPageStore = Store<BGBookMarksPageState>(reducer: BGBookMarksPageReducer, state: nil)

struct BGBookMarksPage: View {
  @ObservedObject var store: ObservableStore<BGBookMarksPageState>
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ClassificationDetailModel.sort, ascending: true)],
      animation: .default)
  private var items: FetchedResults<ClassificationModel>

  @State private var showDialog = false
  var body: some View {
    NavigationView {
      List {
          ForEach(items) { item in
            NavigationLink {
              ClassificationList(item: item).environment(\.managedObjectContext, BGCoreDataManager.shared.classificationContainer.viewContext)
            } label: {
              BGBookMarksPageCell(item: item)
            }
          }.onDelete(perform: deleteFolder)
      }
      .alert(isPresented: $showDialog,
              BGTextAlert(title: "请输入名称",
                          textfields: [BGAlertTextField(placeholder: "请输入名称")],
                          action: addFolder))
      .navigationTitle(Text("书签"))
      .toolbar {
        Image(systemName: "folder.badge.plus").onTapGesture {
          showDialog = true
        }
      }
    }
    .onAppear(perform: loadData)
  }

}

// action
extension BGBookMarksPage {
  func loadData() {
    store.dispatch(BGBookMarksPageOnClickRefreshAction())
  }
  
  func deleteFolder(at indexSet: IndexSet) {
    self.store.dispatch(BGBookMarksPageDeleteAction(item: items[indexSet.first ?? 0]))
  }

  func addFolder(text: [String?]) {
    if let name = text[0], !name.isEmpty {
      store.dispatch(BGBookMarksPageAddFolderTextAlertAction(name: name, index: (items.last?.sort ?? 0)+1))
    }
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    BGBookMarksPage(store: ObservableStore(store: bookMarksPageStore)).environment(\.managedObjectContext, BGCoreDataManager.shared.classificationContainer.viewContext)
  }
}

