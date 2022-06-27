//
//  BlogAPI.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import Foundation

struct ClassificationDetail: Codable, Identifiable {
  var title: String
  var link: String
  var id = UUID()
  
  enum CodingKeys: String, CodingKey
  {
    case title
    case link
  }
}


struct Classification: Codable, Identifiable {
  var id = UUID()
  var type: String
  var name: String
  var detail: [ClassificationDetail]?
  
  enum CodingKeys: String, CodingKey
  {
    case type
    case name
    case detail
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
