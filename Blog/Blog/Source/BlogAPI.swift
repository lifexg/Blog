//
//  BlogAPI.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import Foundation

struct ClassificationDetail: Codable {
  var title: String
  var link: String
}

extension ClassificationDetail: Identifiable {
  var id: UUID {
    UUID()
  }
}

struct Classification: Codable {
  var type: String
  var name: String
  var detail: [ClassificationDetail]?
}

extension Classification: Identifiable {
  
  var id: UUID {
    UUID()
  }
}

struct ClassData:Decodable {
  var data: [Classification]
}


extension Classification {
  static func classifications() async -> [Classification] {
    let bundle = Bundle.main
    guard let path = bundle.path(forResource: "BlogClassification", ofType: "json") else {
      return []
    }
    do {
      guard let data = try String.init(contentsOfFile: path, encoding: .utf8).data(using: .utf8)  else {
        return []
      }
      
      let model = try JSONDecoder().decode(ClassData.self, from: data)
      return model.data
    } catch {
      return []
    }
  }
}
