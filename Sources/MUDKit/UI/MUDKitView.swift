import SwiftUI
import Pulse
import PulseUI

public struct MUDKitView: View {
    private let pulseStore: LoggerStore
    private let pulseMode: ConsoleMode
    
    @State private var isClearUDAlertShown = false
    @State private var isClearKeychainAlertShown = false
    
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
                }
                Section("Clear storage (with reboot)") {
                    Button("Clear UserDefaults") {
                        isClearUDAlertShown = true
                    }
                    Button("Clear Keychain") {
                        isClearKeychainAlertShown = true
                    }
                }
            }
            .navigationTitle("MUDKit")
        }
        .alert("Clear UserDefaults", isPresented: $isClearUDAlertShown) {
            Button("OK", role: .destructive) {
                UserDefaultsService.clear()
                exit(0)
            }
            Button("Cancel", role: .cancel) {
                isClearUDAlertShown = false
            }
        }
        .alert("Clear Keychain", isPresented: $isClearKeychainAlertShown) {
            Button("OK", role: .destructive) {
                KeychainService.clear()
                exit(0)
            }
            Button("Cancel", role: .cancel) {
                isClearKeychainAlertShown = false
            }
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
