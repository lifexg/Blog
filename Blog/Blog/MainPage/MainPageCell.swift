//
//  BGBookMarksPageCell.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI

struct BGBookMarksPageCell: View {
  let item: Classification
  var body: some View {
    VStack {
      Text(item.name)
    }
  }
}

struct BGBookMarksPageCell_Previews: PreviewProvider {
  static var previews: some View {
    BGBookMarksPageCell(item: Classification(type: "1", name: "name", detail: []))
  }
}
