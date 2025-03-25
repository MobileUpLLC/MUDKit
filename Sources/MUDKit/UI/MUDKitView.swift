import SwiftUI
import Pulse
import PulseUI

public struct MUDKitView<Content: View>: View {
    private let pulseStore: LoggerStore
    private let pulseMode: ConsoleMode
    @ViewBuilder private let content: () -> Content
    
    public var body: some View {
        NavigationView {
            List {
                Section {
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
                if Content.self != EmptyView.self {
                    Section("Custom") {
                        content()
                    }
                }
            }
            .navigationTitle("MUDKit")
        }
    }
    
    public init(
        pulseStore: LoggerStore = .shared,
        pulseMode: ConsoleMode = .all,
        @ViewBuilder content: @escaping () -> Content = { EmptyView() }
    ) {
        self.pulseStore = pulseStore
        self.pulseMode = pulseMode
        self.content = content
    }
}

#Preview {
    MUDKitView {
        NavigationLink("Custom action") {
            Text("Custom action screen")
        }
    }
}
