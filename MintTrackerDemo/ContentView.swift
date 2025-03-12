import SwiftUI
import WidgetKit

// Ensure this matches the App Group identifier used in your widget.
let appGroupIdentifier = "group.example.MintCounter"

struct ContentView: View {
    @State private var mintCount: Int = 0
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 20) {
            Text("Mint Count: \(mintCount)")
                .font(.largeTitle)
                .padding()
            Button("Add Mint") {
                incrementMintCount()
            }
            .padding()
            .background(Color.green.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // New Reset button:
            Button("Reset Counter") {
                resetCounter()
            }
            .padding()
            .background(Color.red.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear {
            updateMintCount()
        }
        // Update counter when app becomes active.
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                updateMintCount()
            }
        }
    }
    
    func updateMintCount() {
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        let newCount = sharedDefaults?.integer(forKey: "mintCount") ?? 0
        mintCount = newCount
    }
    
    func incrementMintCount() {
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        let current = sharedDefaults?.integer(forKey: "mintCount") ?? 0
        let newTotal = current + 1
        sharedDefaults?.set(newTotal, forKey: "mintCount")
        mintCount = newTotal
        // Refresh the widget timeline to update the widget.
        WidgetCenter.shared.reloadTimelines(ofKind: "MintTrackerWidget")
    }
    
    // Reset function sets the counter to 0.
    func resetCounter() {
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        sharedDefaults?.set(0, forKey: "mintCount")
        mintCount = 0
        // Refresh the widget timeline to update the widget.
        WidgetCenter.shared.reloadTimelines(ofKind: "MintTrackerWidget")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
