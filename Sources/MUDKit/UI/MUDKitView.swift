import SwiftUI
import Pulse
import PulseUI

/// The main debug interface for MUDKit, providing access to various tools.
public struct MUDKitView<Content: View>: View {
    private let pulseStore: LoggerStore
    private let pulseMode: ConsoleMode
    @ViewBuilder private let content: () -> Content
    private let hasCustomContent: Bool
    
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
                    NavigationLink("Deeplink") {
                        DeeplinkView()
                    }
                    NavigationLink("Environments") {
                        EnvironmentView()
                    }
                    NavigationLink("File System") {
                        FileSystemView()
                    }
                    FrameGeometryView()
                }
                if hasCustomContent {
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
        self.hasCustomContent = Content.self != EmptyView.self
    }
}

#Preview {
    MUDKitView {
        NavigationLink("Custom action") {
            Text("Custom action screen")
        }
    }
}
