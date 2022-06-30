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
import CoreServices
let bookMarksPageStore = Store<BGBookMarksPageState>(reducer: BGBookMarksPageReducer, state: nil)

struct BGBookMarksPage: View {
  @ObservedObject var store: ObservableStore<BGBookMarksPageState>
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ClassificationDetailModel.sort, ascending: true)],
      animation: .default)
  private var items: FetchedResults<ClassificationModel>

  @State private var showDialog = false
  
  @State private var showEditDialog = false
  @State private var tempItem: ClassificationModel?
  var body: some View {
    NavigationView {
      List {
          ForEach(items) { item in
            NavigationLink {
              ClassificationList(item: item).environment(\.managedObjectContext, BGCoreDataManager.shared.classificationContainer.viewContext)
            } label: {
              if #available(iOS 15.0, *) {
                BGBookMarksPageCell(item: item).swipeActions(edge: .trailing, allowsFullSwipe: true) {
                  Button(action: {
                    deleteFolder(at: item)
                  },label: {Label("Delete", systemImage: "trash")})
                  Button(action: {
                    tempItem = item
                    showEditDialog = true
                  },label: {Label("Edit", systemImage: "square.and.pencil")})
                }.tint(.red)
              } else {
                BGBookMarksPageCell(item: item)
              }
            }
          }.onDelete(perform: deleteFolder)
      }
      .alert(isPresented: $showDialog,
              BGTextAlert(title: "请输入名称",
                          textfields: [BGAlertTextField(placeholder: "请输入名称",content: nil)],
                          action: addFolder))
      .alert(isPresented: $showEditDialog,
              BGTextAlert(title: "请输入名称",
                          textfields: [BGAlertTextField(placeholder: "请输入名称",content: tempItem?.name)],
                          action: editFolder))
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
  
  func deleteFolder(at item: ClassificationModel) {
    self.store.dispatch(BGBookMarksPageDeleteAction(item: item))
  }


  func addFolder(text: [String?]) {
    if let name = text[0], !name.isEmpty {
      store.dispatch(BGBookMarksPageAddFolderTextAlertAction(name: name, index: (items.last?.sort ?? 0)+1))
    }
  }
  
  func editFolder(text: [String?]) {
    if let name = text[0], !name.isEmpty,
    let tempItem = tempItem {
      store.dispatch(BGBookMarksPageEditFolderNameAction(item: tempItem, name: name))
    }
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    BGBookMarksPage(store: ObservableStore(store: bookMarksPageStore)).environment(\.managedObjectContext, BGCoreDataManager.shared.classificationContainer.viewContext)
  }
}

