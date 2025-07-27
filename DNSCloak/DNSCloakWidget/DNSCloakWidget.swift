import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), isEnabled: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), isEnabled: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, isEnabled: false)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let isEnabled: Bool
}

struct DNSCloakWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("DNSCloak")
            Text(entry.isEnabled ? "Enabled" : "Disabled")
        }
    }
}

@main
struct DNSCloakWidget: Widget {
    let kind: String = "DNSCloakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DNSCloakWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DNSCloak Widget")
        .description("Quickly enable or disable the DNSCloak VPN.")
    }
}

struct DNSCloakWidget_Previews: PreviewProvider {
    static var previews: some View {
        DNSCloakWidgetEntryView(entry: SimpleEntry(date: Date(), isEnabled: false))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
