import SwiftUI
import Pulse
import PulseUI

public struct MUDKitView: View {
    private let pulseStore: LoggerStore
    private let pulseMode: ConsoleMode
    
    public var body: some View {
        NavigationView {
            List {
                NavigationLink("Pulse") {
                    PulseView(store: pulseStore, mode: pulseMode)
                }
                NavigationLink("Feature toggles") {
                    FeatureTogglesView()
                }
                NavigationLink("UserDefaults") {
                    StorageView(type: .userDefaults)
                }
                NavigationLink("Keychain") {
                    StorageView(type: .keychain)
                }
            }
            .navigationTitle("MUDKit")
        }
    }
    
    public init(
        pulseStore: LoggerStore = .shared,
        pulseMode: ConsoleMode = .all
    ) {
        self.pulseStore = pulseStore
        self.pulseMode = pulseMode
    }
}

#Preview {
    MUDKitView()
}
