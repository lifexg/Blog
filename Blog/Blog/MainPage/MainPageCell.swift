//
//  MainPageCell.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI

struct MainPageCell: View {
  let item: Classification
  var body: some View {
    VStack {
      Text(item.name)
    }
  }
}

struct MainPageCell_Previews: PreviewProvider {
  static var previews: some View {
    MainPageCell(item: Classification(type: "1", name: "name", detail: []))
  }
}
