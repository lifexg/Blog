//
//  ClassificationList.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI
import BGUI

struct ClassificationList: View {
  let item:Classification
  @State var showDialog = false
  var body: some View {
    List {
      let list = item.detail ?? []
      ForEach(list) { item in
        NavigationLink {
          BlogContentView(webViewModel: WebViewModel(url: item.link))
        } label: {
          ClassificationDetailCell(item: item)
        }
      }.onDelete(perform: deleteFile)
    }
    .alert(isPresented: $showDialog,
           BGTextAlert(title: "请输入名称/链接", textfields: [BGAlertTextField(placeholder: "请输入名称"), BGAlertTextField(placeholder: "请输入链接")], action:addFile))
    .navigationTitle(Text("书签"))
    .toolbar {
      Image(systemName: "folder.badge.plus").onTapGesture {
        showDialog = true
      }
    }
    .navigationTitle(Text(item.name)).navigationBarTitleDisplayMode(.inline)
  }
}

// action
extension ClassificationList {
  
  
  func deleteFile(at indexSet: IndexSet) {
    bookMarksPageStore.dispatch(BGBookMarksPageDeleteAction.init(index: indexSet))
  }

  func addFile(text: [String?]) {
    let name = text[0]
    let link = text[1]
    if let name = name, !name.isEmpty,
       let link = link, !link.isEmpty {
      bookMarksPageStore.dispatch(BGBookMarksAddClassifcationLinkAction(name: name, link: link))
    }
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
    ClassificationList(item: Classification(type: "", name: "ceshi", detail: [ClassificationDetail(title: "hahah", link: "https://www.baidu.com")]))
  }
}
