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

let BGBookMarksPageStore = Store<BGBookMarksPageState>(reducer: BGBookMarksPageReducer, state: BGBookMarksPageState())


struct BGBookMarksPage: View {
  @ObservedObject var store: ObservableStore<BGBookMarksPageState>
  @State var alertIsPresented: Bool = false
  @State var text: String? = ""
  @State private var showDialog = false
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
      }.alert(isPresented: $showDialog,
              BGTextAlert(title: "请输入名称",
                        message: "",
                        keyboardType: .numberPad) {addFolder(name: $0)})
      .navigationTitle(Text("书签"))
//      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Image(systemName: "folder.badge.plus").onTapGesture {
          showDialog = true
        }
      }
    }.navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
      store.dispatch(BGBookMarksPageOnClickRefreshAction())
    }.background(Color.red)
  }

  func deleteFolder(at indexSet: IndexSet) {
    self.store.dispatch(BGBookMarksPageDeleteAction.init(index: indexSet))
  }
  
  func addFolder(name: String?) {
    if let name = name {
      store.dispatch(BGBookMarksPageAddFolderTextAlertAction(name:name))
    }
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    BGBookMarksPage(store: ObservableStore(store: BGBookMarksPageStore))
  }
}

