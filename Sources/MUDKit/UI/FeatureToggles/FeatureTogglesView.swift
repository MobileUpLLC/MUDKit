import SwiftUI

struct FeatureTogglesView: View {
    @State var featureToggles: [FeatureToggle] = MUDKitConfigurator
        .configuration?
        .featureToggleConfiguration?
        .featureToggles ?? []
    @State private var isOnlyLocal: Bool = MUDKitConfigurator
        .configuration?
        .featureToggleConfiguration?
        .featureToggles
        .filter { $0.isLocal == false }
        .isEmpty ?? true
    
    var body: some View {
        Group {
            if featureToggles.isEmpty {
                Text("Feature toggles are not found")
            } else {
                List {
                    Section {
                        ForEach($featureToggles, id: \.self) { toggle in
                            Toggle(toggle.wrappedValue.convenientName, isOn: toggle.isEnabled)
                        }
                        
                    } header: {
                        Toggle("Only local features", isOn: $isOnlyLocal)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Button("Save with reboot") {
                        if let encodedValue = try? JSONEncoder().encode(featureToggles) {
                            UserDefaults.standard.set(encodedValue, forKey: "featureToggles")
                            exit(0)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemBackground))
                }
            }
        }
        .navigationTitle("Feature toggles")
        .animation(.default, value: featureToggles)
        .onChange(of: isOnlyLocal) { newValue in
            featureToggles.indices.forEach {
                featureToggles[$0].isEnabled = featureToggles[$0].isLocal && newValue
            }
        }
    }
}

#Preview {
    FeatureTogglesView(
        featureToggles: [
            FeatureToggle(
                name: "feature_toggle_name",
                convenientName: "Feature toggle",
                isEnabled: false,
                isLocal: true
            ),
            FeatureToggle(
                name: "another_feature_toggle_name",
                convenientName: "Another feature toggle",
                isEnabled: false,
                isLocal: true
            )
        ]
    )
}
