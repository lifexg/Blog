//
//  Widget.swift
//  Widget
//
//  Created by fexg on 2022/7/1.
//

import WidgetKit
import SwiftUI
import Intents

struct BGRecentlyReadEntry: TimelineEntry {
  let date: Date
  let arr: [[String: String]]
}


struct BGRecentlyReadProvider: TimelineProvider {
  // 占位视图
  func placeholder(in context: Context) -> BGRecentlyReadEntry {
    if let arr = NSUbiquitousKeyValueStore.default.array(forKey: "iCloudRecentlyReadKey") as? [[String: String]] {
      return BGRecentlyReadEntry(date: Date(), arr: arr)
    }
    return BGRecentlyReadEntry(date: Date(), arr: [])
  }
  
  // 编辑屏幕在左上角选择添加Widget、第一次展示时会调用该方法
  func getSnapshot(in context: Context, completion: @escaping (BGRecentlyReadEntry) -> ()) {
    if let arr = NSUbiquitousKeyValueStore.default.array(forKey: "iCloudRecentlyReadKey") as? [[String: String]] {
      completion (BGRecentlyReadEntry(date: Date(), arr: arr))
    }
    completion (BGRecentlyReadEntry(date: Date(), arr: []))
  }
  
  // 进行数据的预处理，转化成Entry
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let updateDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    if let arr = NSUbiquitousKeyValueStore.default.array(forKey: "iCloudRecentlyReadKey") as? [[String: String]] {
      let timeline = Timeline(entries: [BGRecentlyReadEntry(date: Date(), arr: arr)], policy: .after(updateDate))
      completion(timeline)
    }
    let timeline = Timeline(entries: [BGRecentlyReadEntry(date: Date(), arr: [])], policy: .after(updateDate))
    completion(timeline)
  }
}

//struct NowWidgetEntryView : View {
//    var entry: BGRecentlyReadProvider.Entry
//    //针对不同尺寸的 Widget 设置不同的 View
//    @Environment(\.widgetFamily) var family // 尺寸环境变量
//
//    @ViewBuilder
//    var body: some View {
//        switch family {
//        case .systemSmall:
//          Text(entry.date, style: .time)
//        case .systemMedium:
//          Text(entry.date, style: .date)
//        default:
//          Text(entry.date, style: .date)
//        }
//    }
//
//}

struct NowWidgetEntryView : View {
  var entry: BGRecentlyReadProvider.Entry
  var body: some View {
    
    VStack(alignment: .leading, spacing: 0, content: {
      Spacer()
      VStack(alignment: .leading, spacing: 0) {
        Label("最近阅读", systemImage: "book.fill")
          .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
      }
      let arr = entry.arr
      if arr.count > 0 {
        Spacer()
        getText(name: arr[0]["name"]!, link: arr[0]["link"]!)
      }
      if arr.count > 1 {
        Spacer()
        getText(name: arr[1]["name"]!, link: arr[1]["link"]!)
      }
      if arr.count > 2 {
        Spacer()
        getText(name: arr[2]["name"]!, link: arr[2]["link"]!)
      }
      Spacer()
    })
  }
  
  func getText(name: String, link: String) -> some View {
    Link(destination: URL(string: link)!) {
      Text(name)
        .font(.footnote)
        .lineLimit(1)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
  }
}

@main
struct NowSwiftWidget: WidgetBundle {
  @WidgetBundleBuilder
  var body: some Widget {
    //      NowWidget1()
    NowWidget2()
    //      NowWidget3()
  }
}


struct NowWidget2: Widget {
  let kind: String = "NowWidget2"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: BGRecentlyReadProvider()) { entry in
      NowWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("最近阅读")
    //        .description("This is an 读一读 widget.")
    .supportedFamilies([.systemMedium])
  }
}

