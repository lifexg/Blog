//
//  ContentView.swift
//  Blog
//
//  Created by fexg on 2022/6/16.
//

import SwiftUI

let mainPageStore = MainPageStore(state: MainPageState(), reducer: mainPageReducer)

struct MainView: View {
  @EnvironmentObject var store: MainPageStore
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
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
          Image(systemName: "arrow.clockwise").onTapGesture {
            store.dispatch(action: .onClickRefresh)
          }
        }
    }.onAppear {
      store.dispatch(action: .onClickRefresh)
    }
  }
}

//let mainPageStore = Store<MainPageState>(state: MainPageState(), reducer: mainPageReducer)
//
//struct MainView: View {
////  @State private var cls:[Classification] = []
//  @EnvironmentObject var store: Store<MainPageState>
//  var body: some View {
//    NavigationView {
//      List {
//        ForEach(store.state?.list ?? []) { item in
//          NavigationLink {
//            ClassificationList(item: item)
//          } label: {
//            MainPageCell(item: item)
//          }
//        }
//      }.navigationTitle(Text("Bookmarks"))
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//          Image(systemName: "arrow.clockwise").onTapGesture {
//            store.dispatch(action: MainPageOnClickRefreshAction())
//          }
//        }
//    }.onAppear {
//      store.dispatch(action: MainPageOnClickRefreshAction())
//    }
//  }
//}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView().environmentObject(mainPageStore)
  }
}
