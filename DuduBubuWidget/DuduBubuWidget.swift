//
//  DuduBubuWidget.swift
//  DuduBubuWidget
//
//  Created by John McCants on 10/18/23.
//

import WidgetKit
import SwiftUI
import Intents
import OSLog
extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let viewCycle = OSLog(subsystem: subsystem, category: "viewcycle")
}

struct Provider: IntentTimelineProvider {
    let data = DataService()
    func placeholder(in context: Context) -> DuduBubuEntry {
        DuduBubuEntry(date: Date(), configuration: ConfigurationIntent(), selectedImage: data.progress())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DuduBubuEntry) -> ()) {
        let entry = DuduBubuEntry(date: Date(), configuration: configuration, selectedImage: data.progress())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DuduBubuEntry] = []


            let entry = DuduBubuEntry(date: Date(), configuration: configuration, selectedImage: data.progress())
                   entries.append(entry)
               
        
       

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DuduBubuEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let selectedImage: String?
    
}

struct DuduBubuWidgetEntryView : View {
    var entry: DuduBubuEntry
    
    let data = DataService()
    
  

    


    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(red: 0.4627, green: 0.8392, blue: 1.0).gradient)
            
            
            VStack {
             
                Image(data.progress()).resizable()
                        .scaledToFit()
         
                Text("John")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
            }
        }

    }
}

struct DuduBubuWidget: Widget {
    let kind: String = "DuduBubuWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DuduBubuWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DuduBubu Image Widget")
        .description("Displays your selected image.")
        
    }
}
    
    

struct DuduBubuWidget_Previews: PreviewProvider {
    static var previews: some View {
        DuduBubuWidgetEntryView(entry: DuduBubuEntry(date: Date(), configuration: ConfigurationIntent(), selectedImage: "Subject2"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
