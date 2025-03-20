import SwiftUI
import Pulse
import PulseUI

public struct MUDKitView: View {
    private let pulseStore: LoggerStore
    private let pulseMode: ConsoleMode
    private let featureToggles: [FeatureToggle]
    
    public var body: some View {
        NavigationView {
            List {
                NavigationLink("Pulse") {
                    PulseView(store: pulseStore, mode: pulseMode)
                }
                NavigationLink("Feature toggles") {
                    FeatureTogglesView(featureToggles: featureToggles)
                }
            }
            .navigationTitle("MUDKit")
        }
    }
    
    public init(
        pulseStore: LoggerStore = .shared,
        pulseMode: ConsoleMode = .all,
        featureToggles: [FeatureToggle] = []
    ) {
        self.pulseStore = pulseStore
        self.pulseMode = pulseMode
        self.featureToggles = featureToggles
    }
}

#Preview {
    MUDKitView()
}
