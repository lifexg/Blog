//
//  ClassificationList.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI

struct ClassificationList: View {
  let item:Classification
  var body: some View {
    List {
      let list = item.detail ?? []
      ForEach(list) { item in
        NavigationLink {
        } label: {
          ClassificationDetailCell(item: item)
        }
      }
    }
    .navigationTitle(Text(item.name)).navigationBarTitleDisplayMode(.inline)
  }
}

struct ClassificationDetailCell: View {
  let item: ClassificationDetail
  var body: some View {
    VStack {
      Text(item.title)
    }
  }
}


struct ClassificationList_Previews: PreviewProvider {
  static var previews: some View {
    ClassificationList(item: Classification(type: "", name: "ceshi", detail: [ClassificationDetail(title: "hahah", link: "")]))
  }
}
