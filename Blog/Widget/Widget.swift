//
//  Widget.swift
//  Widget
//
//  Created by fexg on 2022/7/1.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    // 占位视图
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    // 编辑屏幕在左上角选择添加Widget、第一次展示时会调用该方法
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    // 进行数据的预处理，转化成Entry
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
  let view = UIView()
}

struct NowWidgetEntryView : View {
    var entry: Provider.Entry
    //针对不同尺寸的 Widget 设置不同的 View
    @Environment(\.widgetFamily) var family // 尺寸环境变量

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
          Text(entry.date, style: .time)
        case .systemMedium:
          Text(entry.date, style: .date)
        default:
          Text(entry.date, style: .date)
        }
    }

}

@main
struct NowSwiftWidget: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
      NowWidget1()
//      NowWidget2()
//      NowWidget3()
    }
}


struct NowWidget2: Widget {
    let kind: String = "NowWidget2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NowWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("读一读")
        .description("This is an 读一读 widget.")
//        .supportedFamilies([.systemSmall,.systemMedium])
    }
}

struct NowWidget3: Widget {
    let kind: String = "NowWidget3"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NowWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("写一写")
        .description("This is an 写一写 widget.")
//        .supportedFamilies([.systemSmall,.systemMedium])
    }
}

