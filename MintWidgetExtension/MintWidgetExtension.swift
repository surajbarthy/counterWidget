import WidgetKit
import SwiftUI
import AppIntents

// Define your App Group identifier.
let appGroupIdentifier = "group.example.MintCounter"

// MARK: - Timeline Entry
struct MintEntry: TimelineEntry {
    let date: Date
    let mintCount: Int
}

// MARK: - Timeline Provider
struct MintProvider: AppIntentTimelineProvider {
    typealias Entry = MintEntry
    typealias Intent = MintIncrementIntent

    func placeholder(in context: Context) -> MintEntry {
        MintEntry(date: Date(), mintCount: 0)
    }
    
    func snapshot(for configuration: MintIncrementIntent, in context: Context) async -> MintEntry {
        MintEntry(date: Date(), mintCount: fetchMintCount())
    }
    
    func timeline(for configuration: MintIncrementIntent, in context: Context) async -> Timeline<MintEntry> {
        let entry = MintEntry(date: Date(), mintCount: fetchMintCount())
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    // Read the shared counter from the App Group's UserDefaults.
    private func fetchMintCount() -> Int {
        return UserDefaults(suiteName: appGroupIdentifier)?.integer(forKey: "mintCount") ?? 0
    }
}

// MARK: - Interactive Intent
struct MintIncrementIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Add Mint"
    static var description = IntentDescription("Increment the mint counter.")

    func perform() async throws -> some IntentResult {
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        let current = sharedDefaults?.integer(forKey: "mintCount") ?? 0
        let newTotal = current + 1
        sharedDefaults?.set(newTotal, forKey: "mintCount")
        print("Mint count updated to \(newTotal)")
        return .result()
    }
}

// MARK: - Styled Widget View
struct MintWidgetEntryView: View {
    var entry: MintEntry

    var body: some View {
        ZStack {
            // Set the background color. Adjust the RGB values as needed.
            Color(red: 255/255, green: 249/255, blue: 240/255)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Title text.
                Text("Add a puff")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 255/255, green: 127/255, blue: 65/255))
                // Display the counter value in a large, bold font.
                Text("\(entry.mintCount)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 45/255, green: 42/255, blue: 38/255))
                // Interactive button: a circle with a plus icon.
                Button(intent: MintIncrementIntent()) {
                    Image(systemName: "plus")
                        .font(.title)
//                        .foregroundColor(.white)
                        .foregroundColor(Color(red: 25/255, green: 48/255, blue: 43/255))

                        .padding(20)
                        .background(Circle().fill(Color(red: 208/255, green: 222/255, blue: 187/255)))
                }
            }
            .padding()
        }
    }
}

// MARK: - Widget Definition
struct MintTrackerWidget: Widget {
    let kind: String = "MintTrackerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: MintIncrementIntent.self,
            provider: MintProvider()
        ) { entry in
            MintWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mint Tracker")
        .description("Track your mints with an interactive widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    MintTrackerWidget()
} timeline: {
    MintEntry(date: Date(), mintCount: 0)
    MintEntry(date: Date(), mintCount: 5)
}
