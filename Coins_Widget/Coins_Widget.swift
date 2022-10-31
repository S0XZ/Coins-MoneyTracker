

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    @AppStorage("todayAmount", store: UserDefaults(suiteName: "group.older.coins")) var todayAmount: Double = 0
    @AppStorage("todayAmountType", store: UserDefaults(suiteName: "group.older.coins")) var todayAmountType: LabelType = .expense
    @AppStorage("colorString", store: UserDefaults(suiteName: "group.older.coins")) var colorString: String = "mint"
    
    func stringToColor(colorString: String) -> Color? {
        let preferColors: [Color] = [.mint, .red, .brown, .blue, .indigo, .purple, .orange, .pink, .green]
        let color = preferColors.first {$0.description == colorString}
        return color
    }
    
    var preferColor: Color {
        stringToColor(colorString: colorString) ?? .mint
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), labelType: todayAmountType, preferColor: preferColor)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, amount: todayAmount, labelType: todayAmountType, preferColor: preferColor)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, amount: todayAmount, labelType: todayAmountType, preferColor: preferColor)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    var amount: Double = 20
    var labelType: LabelType = .income
    var preferColor: Color
}

struct Coins_WidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    var isExpense: Bool {
        entry.labelType == .expense
    }
    

    var body: some View {
        let amount: Double = entry.amount
        let labelType: LabelType = entry.labelType
        let color: Color = entry.preferColor
   
        ZStack {
            if !isExpense {

                Color.accentColor
                LinearGradient(colors: [.white, .black.opacity(0.25)], startPoint: .top, endPoint: .bottom).blendMode(.overlay).opacity(0.8)
                if color == .mint {
                    Color.black.blendMode(.multiply).opacity(0.3)
                }
                
            } else {
                Color.accentColor
                LinearGradient(colors: [.black, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
            }
            
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Today")
                            .opacity(0.8)
                        Text(LocalizedStringKey(labelType.rawValue))
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    
                    Image(systemName: makeIcon(with: labelType))
                        .imageScale(.large)
                }
                .padding(3)
                .foregroundColor(.white)
                .blendMode(isExpense ? .normal : .overlay)
                                                
                Text(entry.amount, format: .currency(code: "USD").precision(.fractionLength(
                    entry.amount>99 ? 0 : 1
                )))
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .blendMode(.normal)
                    .opacity(amount == 0 ? 0.4 : 0.8)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .accentColor(color)
    }
    
    func makeColor(type: LabelType) -> Color {
        switch type {
        case .expense:
            return Color.primary
        case .income:
            return Color.accentColor
        }
    }
    
    func makeIcon(with type: LabelType) -> String {
        switch type {
        case .expense:
            return "tray.and.arrow.up"
        case .income:
            return "tray.and.arrow.down"
        }
    }
}

@main
struct Coins_Widget: Widget {
    let kind: String = "Coins_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Coins_WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Today Summary")
        .description("View the entries summary of today")
    }
}

struct Coins_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Coins_WidgetEntryView(entry:
                                SimpleEntry(
                                    date: Date(),
                                    configuration: ConfigurationIntent(),
                                    preferColor: .mint
                                ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        Coins_WidgetEntryView(entry:
                                SimpleEntry(
                                    date: Date(),
                                    configuration: ConfigurationIntent(),
                                    preferColor: .pink
                                ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
