import SwiftUI

struct FeatureTogglesView: View {
    @State var featureToggles: [FeatureToggle] = MUDKitConfigurator
        .configuration?
        .featureToggleConfiguration?
        .featureToggles
    ?? []
    
    var body: some View {
        Group {
            if featureToggles.isEmpty {
                Text("Feature toggles are not found")
            } else {
                List($featureToggles, id: \.self) { toggle in
                    Toggle(toggle.wrappedValue.convenientName, isOn: toggle.isEnabled)
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
                    .padding(.top)
                    .background(Color.white)
                }
            }
        }
        .navigationTitle("Feature toggles")
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
