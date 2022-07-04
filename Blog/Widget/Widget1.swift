//
//  Store.swift
//  WidgetExtension
//
//  Created by fexg on 2022/7/1.
//

import Foundation
import WidgetKit
import SwiftUI
import Intents

struct Poster {
  let author: String
  let content: String
  var posterImage: UIImage? = UIImage(named: "plan_collect")
}

struct PosterEntry: TimelineEntry {
  let date: Date
  let poster: Poster
}

struct PosterData {
  static func getTodayPoster(completion: @escaping (Result<Poster, Error>) -> Void) {
    let url = URL(string: "https://nowapi.navoinfo.cn/get/now/today")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard error==nil else{
        completion(.failure(error!))
        return
      }
      let poster=posterFromJson(fromData: data!)
      completion(.success(poster))
    }
    task.resume()
  }
  
  static func posterFromJson(fromData data:Data) -> Poster {
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    guard let result = json["result"] as? [String: Any] else{
      return Poster(author: "Now", content: "加载失败")
    }
    
    let author = result["author"] as! String
    let content = result["celebrated"] as! String
    let posterImage = result["poster_image"] as! String
    
    //图片同步请求
    var image: UIImage? = nil
    if let imageData = try? Data(contentsOf: URL(string: posterImage)!) {
      image = UIImage(data: imageData)
    }
    
    return Poster(author: author, content: content, posterImage: image)
  }
  
}

struct PosterProvider: TimelineProvider {
  // 占位视图
  func placeholder(in context: Context) -> PosterEntry {
    PosterEntry(date: Date(), poster: Poster(author: "author", content: "content"))
  }
  // 编辑屏幕在左上角选择添加Widget、第一次展示时会调用该方法
  func getSnapshot(in context: Context, completion: @escaping (PosterEntry) -> ()) {
    PosterData.getTodayPoster { result in
      let poster: Poster
      if case .success(let fetchedData) = result{
        poster = fetchedData
      }else{
        poster=Poster(author: "Now", content: "Now格言");
      }
      
      let entry = PosterEntry(date: Date(), poster: poster)
      completion(entry)
    }
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let currentDate = Date()
    //设定1小时更新一次数据
    let updateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
    
    PosterData.getTodayPoster { result in
      let poster: Poster
      if case .success(let fetchedData) = result{
        poster = fetchedData
      }else{
        poster=Poster(author: "Now", content: "Now格言");
      }
      
      let entry = Entry(date: currentDate, poster: poster)
      let timeline = Timeline(entries: [entry], policy: .after(updateDate))
      completion(timeline)
    }
  }
  
}


struct NowPosterWidgetEntryView : View {
  var entry: PosterProvider.Entry
  var body: some View {
    ZStack{
      if let image = entry.poster.posterImage {
        Link(destination: URL(string: "https://www.jianshu.com/u/bc4a806f89c5")!) {
                VStack {
                  Image(uiImage: image)
                    .resizable()
                    .frame(minWidth: 169, maxWidth: .infinity, minHeight: 169, maxHeight: .infinity, alignment: .center)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    .widgetURL(URL(string: "https://www.jianshu.com/u/bc4a806f89c5"))
                }
            }
      }
      
      Text(entry.poster.content)
        .foregroundColor(Color.white)
        .lineLimit(4)
        .font(.system(size: 14))
        .padding(.horizontal)
//        .widgetURL(URL(string: "跳转链接Text"))
    }
//    .widgetURL(URL(string: "https://www.jianshu.com/u/bc4a806f89c5"))
  }
}

struct NowWidget1: Widget {
  let kind: String = "NowWidget1"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: PosterProvider()) { entry in
      NowPosterWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("看一看")
    .description("This is an 看一看 widget.")
//            .supportedFamilies([.systemSmall,.systemMedium])
  }
}

