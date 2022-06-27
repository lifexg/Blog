//
//  ContentView.swift
//  Blog
//
//  Created by fexg on 2022/6/16.
//

import SwiftUI
import ReSwift
import Combine
import BGUI

let bookMarksPageStore = Store<BGBookMarksPageState>(reducer: BGBookMarksPageReducer, state: BGBookMarksPageState())


struct BGBookMarksPage: View {
  @ObservedObject var store: ObservableStore<BGBookMarksPageState>
  @State private var showDialog = false
//  @State private var text: String? = ""
  var body: some View {
    NavigationView {
      List {
        ForEach(store.state.list) { item in
          NavigationLink {
            ClassificationList(item: item)
          } label: {
            BGBookMarksPageCell(item: item)
          }
        }.onDelete(perform: deleteFolder)
      }
//      .textFieldAlert(isPresented: $showDialog) { () -> TextFieldAlert in
//        TextFieldAlert(title: "Alert Title", message: "Alert Message", text: self.$text)}
      .alert(isPresented: $showDialog,
              BGTextAlert(title: "请输入名称",
                          textfields: [BGAlertTextField(placeholder: "请输入名称")],
                          action: addFolder))
      .navigationTitle(Text("书签"))
//      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Image(systemName: "folder.badge.plus").onTapGesture {
          showDialog = true
        }
      }
    }
//    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear(perform: loadData)
  }

}

// action
extension BGBookMarksPage {
  
  func loadData() {
    store.dispatch(BGBookMarksPageOnClickRefreshAction())
  }
  
  func deleteFolder(at indexSet: IndexSet) {
    self.store.dispatch(BGBookMarksPageDeleteAction.init(index: indexSet))
  }

  func addFolder(text: [String?]) {
    if let name = text[0], !name.isEmpty {
      store.dispatch(BGBookMarksPageAddFolderTextAlertAction(name:name))
    }
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    BGBookMarksPage(store: ObservableStore(store: bookMarksPageStore))
  }
}

