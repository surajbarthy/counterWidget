import WidgetKit
import SwiftUI

@main
struct MintWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MintTrackerWidget()
        // Add other widgets here if needed.
    }
}
