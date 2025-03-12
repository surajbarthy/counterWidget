import SwiftUI
import WidgetKit

let appGroupIdentifier = "group.example.MintCounter"

struct ContentView: View {
    @State private var mintCount: Int = 0
    @Environment(\.scenePhase) private var scenePhase  // Track scene phase

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
        }
        .onAppear {
            updateMintCount()
        }
        // Listen for scene phase changes and update when the app becomes active.
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
        
        // Optionally, refresh the widget timeline so the widget updates immediately.
        WidgetCenter.shared.reloadTimelines(ofKind: "MintTrackerWidget")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
