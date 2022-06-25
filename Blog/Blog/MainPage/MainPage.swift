//
//  ContentView.swift
//  Blog
//
//  Created by fexg on 2022/6/16.
//

import SwiftUI
import ReSwift

let mainPageStore = Store<MainPageState>(reducer: mainPageReducer, state: MainPageState())


struct MainView: View {
  @ObservedObject var store: ObservableStore<MainPageState>
  var body: some View {
    NavigationView {
      
      List {
        ForEach(store.state.list) { item in
          NavigationLink {
            ClassificationList(item: item)
          } label: {
            MainPageCell(item: item)
          }
        }
      }.navigationTitle(Text("Bookmarks"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          Image(systemName: "arrow.clockwise").onTapGesture {
            store.dispatch(MainPageOnClickRefreshAction())
          }
        }
    }.onAppear {
      store.dispatch(MainPageOnClickRefreshAction())
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(store: ObservableStore(store: mainPageStore))
  }
}
