//
//  ClassificationList.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI
import BGUI
import CoreData

struct ClassificationList: View {
   var item:ClassificationModel
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ClassificationDetailModel.sort, ascending: true)],
      animation: .default)
  private var items: FetchedResults<ClassificationDetailModel>
  
  init(item: ClassificationModel){
    self.item = item
    _items = FetchRequest(entity: ClassificationDetailModel.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ClassificationDetailModel.sort, ascending: true)], predicate:NSPredicate(format: "classification_type = %@", (item.type ?? UUID()) as CVarArg))
  }
  
  @State var showDialog = false
  var body: some View {
    List {
      ForEach(items) { item in
        NavigationLink {
          BlogContentView(webViewModel: WebViewModel(url: item.link ?? ""))
        } label: {
          ClassificationDetailCell(item: item)
        }
      }.onDelete(perform: deleteFile)
    }
    .alert(isPresented: $showDialog,
           BGTextAlert(title: "请输入名称/链接", textfields: [BGAlertTextField(placeholder: "请输入名称"), BGAlertTextField(placeholder: "请输入链接")], action:addFile))
    .navigationTitle(Text(item.name ?? ""))
    .toolbar {
      Image(systemName: "folder.badge.plus").onTapGesture {
        showDialog = true
      }
    }
    .navigationTitle(Text(item.name ?? "")).navigationBarTitleDisplayMode(.inline)
  }
}

// action
extension ClassificationList {
  
  
  func deleteFile(at indexSet: IndexSet) {
    bookMarksPageStore.dispatch(BGBookMarksPageDeleteDetailAction(item: items[indexSet.first ?? 0]))
  }

  func addFile(text: [String?]) {
    let name = text[0]
    let link = text[1]
    if let name = name, !name.isEmpty,
       let link = link, !link.isEmpty {
      let item = items.last
      bookMarksPageStore.dispatch(BGBookMarksAddClassifcationLinkAction(name: name, link: link, index: (item?.sort ?? 0)+1, item: self.item))
    }
  }
}

struct ClassificationDetailCell: View {
  let item: ClassificationDetailModel
  var body: some View {
    VStack {
      Text(item.name ?? "")
    }
  }
}


struct ClassificationList_Previews: PreviewProvider {
  static var previews: some View {
    ClassificationList(item: ClassificationModel())
  }
}
