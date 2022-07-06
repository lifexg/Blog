//
//  BGClassificationList.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI
import BGUI
import CoreData

struct BGClassificationList: View {
   var item:ClassificationModel
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ClassificationDetailModel.sort, ascending: true)],
      animation: .default)
  private var items: FetchedResults<ClassificationDetailModel>
  
  init(item: ClassificationModel){
    self.item = item
    _items = FetchRequest(entity: ClassificationDetailModel.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ClassificationDetailModel.sort, ascending: true)], predicate:NSPredicate(format: "classification_type = %@", (item.type ?? UUID()) as CVarArg))
  }
  
  @State private var showEditDialog = false
  @State private var tempItem: ClassificationDetailModel?

  @State var showDialog = false
  var body: some View {
    List {
      ForEach(items) { item in
        NavigationLink {
          BGContentView(webViewModel: WebViewModel(url: item.link ?? ""))
        } label: {
          
          if #available(iOS 15.0, *) {
            ClassificationDetailCell(item: item).swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(action: {
                deleteFile(at: item)
              },label: {Label("Delete", systemImage: "trash")})
              Button(action: {
                tempItem = item
                showEditDialog = true
              },label: {Label("Edit", systemImage: "square.and.pencil")})
            }.tint(.red)
          } else {
            ClassificationDetailCell(item: item)
          }

        }
      }.onDelete(perform: deleteFile)
    }
    .alert(isPresented: $showEditDialog,
            BGTextAlert(title: "请输入名称/链接",
                        textfields: [BGAlertTextField(placeholder: "请输入名称", content: tempItem?.name), BGAlertTextField(placeholder: "请输入链接",content: tempItem?.link)],
                        action: editFolder))
    .alert(isPresented: $showDialog,
           BGTextAlert(title: "请输入名称/链接", textfields: [BGAlertTextField(placeholder: "请输入名称",content: nil), BGAlertTextField(placeholder: "请输入链接",content: nil)], action:addFile))
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
extension BGClassificationList {
  
  
  func deleteFile(at indexSet: IndexSet) {
    bookMarksPageStore.dispatch(BGBookMarksPageDeleteDetailAction(item: items[indexSet.first ?? 0]))
  }
  
  func deleteFile(at item: ClassificationDetailModel) {
    bookMarksPageStore.dispatch(BGBookMarksPageDeleteDetailAction(item: item))
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
  
  func  editFolder(text: [String?]) {
    let name = text[0]
    let link = text[1]
    if let name = name, !name.isEmpty,
       let link = link, !link.isEmpty,
       let item = tempItem {
      item.name = name
      item.link = link
      bookMarksPageStore.dispatch(BGBookMarksPageEditDetailAction(item:item))
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


struct BGClassificationList_Previews: PreviewProvider {
  static var previews: some View {
    BGClassificationList(item: ClassificationModel())
  }
}
