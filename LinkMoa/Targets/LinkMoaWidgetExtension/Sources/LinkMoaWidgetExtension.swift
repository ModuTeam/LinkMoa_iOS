//
//  LinkMoaWidgetExtension.swift
//  LinkMoaWidgetExtension
//
//  Created by won heo on 2021/03/23.
//

import SwiftUI
import WidgetKit
import LinkMoaKit
import LinkMoaCore

struct Provider: TimelineProvider {
    let linkMoaProvider = LinkMoaAPI.provider
    let placeholderEntry = FolderEntry(
        date: Date(),
        todayFolder: [
            TodayFolder.Result(index: 0, name: "추천 폴더", linkCount: 5, linkImageURL: Constant.defaultImageURL)
        ]
    )
    
    func placeholder(in context: Context) -> FolderEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FolderEntry) -> Void) {
        let entry = placeholderEntry
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var todayFolder: [TodayFolder.Result] = []
        var entries: [FolderEntry] = []
        let currentDate = Date()
        
        linkMoaProvider.request(.todayFolder) { result in
            switch result {
            case .success(let response):
                let data = response.data
                if let folderList = try? JSONDecoder().decode(TodayFolder.self, from: data) {
                    todayFolder = folderList.result
                }
            default:
                break
            }
            
            let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
            
            if let today = Calendar.current.date(from: todayComponents), let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) {
                
                let entry1 = FolderEntry(date: today, todayFolder: todayFolder)
                let entry2 = FolderEntry(date: tomorrow, todayFolder: todayFolder)
                entries.append(entry1)
                entries.append(entry2)
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct FolderEntry: TimelineEntry {
    let date: Date
    let todayFolder: [TodayFolder.Result]
}

struct LinkMoaWidgetExtensionEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry
    var index: Int {
        if entry.todayFolder.count > 0 {
            return entry.todayFolder[0].index
        } else {
            return 0
        }
    }
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            WidgetBoxView(todayFolder: entry.todayFolder)
                .widgetURL(URL(string: "linkmoa://\(index)"))
        default:
            Text("test")
        }
    }
    
}

@main
struct LinkMoaWidgetExtension: Widget {
    let kind: String = "LinkMoaWidgetExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LinkMoaWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("추천 링크달")
        .description("나에게 맞는 링크달을 추천해드립니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct LinkMoaWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        LinkMoaWidgetExtensionEntryView(entry: FolderEntry(date: Date(), todayFolder: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
