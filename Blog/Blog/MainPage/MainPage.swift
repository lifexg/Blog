//
//  ContentView.swift
//  Blog
//
//  Created by fexg on 2022/6/16.
//

import SwiftUI

struct MainView: View {
  @State private var cls:[Classification] = []
  var body: some View {
    NavigationView {
      List {
        ForEach(cls) { item in
          NavigationLink {
            ClassificationList(item: item)
          } label: {
            MainPageCell(item: item)
          }
        }
      }.task {
        await cls = Classification.classifications()
      }.navigationTitle(Text("Bookmarks"))
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .previewInterfaceOrientation(.portrait)
  }
}
