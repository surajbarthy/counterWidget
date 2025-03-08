import WidgetKit
import SwiftUI
import AppIntents

//let appGroupIdentifier = "group.example.MintCounter"
//let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)

//UserDefaults(suiteName: "group.example.MintCounter")

// MARK: - Timeline Entry
struct MintEntry: TimelineEntry {
    let date: Date
    let mintCount: Int
}

// MARK: - Timeline Provider
struct MintProvider: AppIntentTimelineProvider {
    // Define the associated types for the timeline provider.
    typealias Entry = MintEntry
    typealias Intent = MintIncrementIntent

    func placeholder(in context: Context) -> MintEntry {
        MintEntry(date: Date(), mintCount: 0)
    }
    
    // Provide a snapshot of your widget.
    func snapshot(for configuration: MintIncrementIntent, in context: Context) async -> MintEntry {
        MintEntry(date: Date(), mintCount: fetchMintCount())
    }
    
    // Provide the timeline (using a single entry here).
    func timeline(for configuration: MintIncrementIntent, in context: Context) async -> Timeline<MintEntry> {
        let entry = MintEntry(date: Date(), mintCount: fetchMintCount())
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    // Helper to fetch the current mint count.
    private func fetchMintCount() -> Int {
        return UserDefaults.standard.integer(forKey: "mintCount")
    }
}

// MARK: - Interactive Intent
struct MintIncrementIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Add Mint"
    static var description = IntentDescription("Increment the mint counter in the widget.")

    func perform() async throws -> some IntentResult {
        let current = UserDefaults.standard.integer(forKey: "mintCount")
        let newTotal = current + 1
        UserDefaults.standard.set(newTotal, forKey: "mintCount")
        print("Mint count updated to \(newTotal)")
        return .result()
    }
}

// MARK: - Widget View
struct MintWidgetExtensionEntryView: View {
    var entry: MintEntry

    var body: some View {
        VStack {
            Text("Mints: \(entry.mintCount)")
                .font(.headline)
            
            // Interactive button (iOS 17+) that triggers the intent.
            Button(intent: MintIncrementIntent()) {
                Text("Add Mint")
                    .padding(8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

// MARK: - Interactive Widget Definition
struct MintTrackerWidget: Widget {
    let kind: String = "MintTrackerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: MintIncrementIntent.self,
            provider: MintProvider()
        ) { entry in
            MintWidgetExtensionEntryView(entry: entry)
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
