import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var counter: Int = 0
    // Use the same shared UserDefaults.
    let sharedDefaults = UserDefaults(suiteName: "group.com.example.MintCounter")!

    var body: some View {
        VStack(spacing: 20) {
            Text("Counter: \(counter)")
                .font(.largeTitle)
            Button("Increment Counter") {
                incrementCounter()
            }
        }
        .padding()
        .onAppear {
            loadCounter()
        }
    }
    
    func loadCounter() {
        counter = sharedDefaults.integer(forKey: "mintCount")
    }
    
    func incrementCounter() {
        let newCount = sharedDefaults.integer(forKey: "mintCount") + 1
        sharedDefaults.set(newCount, forKey: "mintCount")
        counter = newCount
        // Tell WidgetCenter to reload the widget timeline.
        WidgetCenter.shared.reloadTimelines(ofKind: "MintTrackerWidget")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
