import SwiftUI

struct FeatureTogglesView: View {
    @State var featureToggles: [FeatureToggle] = MUDKitConfigurator
        .configuration?
        .featureToggleConfiguration?
        .featureToggles ?? []
    @State private var isOverrideBaseConfig: Bool = UserDefaultsUtil.get(for: "isOverrideBaseConfig") ?? false
    
    var body: some View {
        Group {
            if featureToggles.isEmpty {
                Text("Feature toggles are not found")
            } else {
                List {
                    Section {
                        ForEach($featureToggles, id: \.self) { toggle in
                            Toggle(toggle.wrappedValue.convenientName, isOn: toggle.isEnabled)
                                .disabled(isOverrideBaseConfig == false)
                        }
                        
                    } header: {
                        Toggle("Override base config", isOn: $isOverrideBaseConfig)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Button("Save with reboot") {
                        UserDefaultsUtil.save(value: isOverrideBaseConfig, key: "isOverrideBaseConfig")
                        UserDefaultsUtil.save(value: featureToggles, key: "featureToggles")
                        exit(0)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .background(Color(uiColor: .secondarySystemBackground))
                }
            }
        }
        .navigationTitle("Feature toggles")
        .animation(.default, value: featureToggles)
    }
}

#Preview {
    FeatureTogglesView(
        featureToggles: [
            FeatureToggle(
                name: "feature_toggle_name",
                convenientName: "Feature toggle",
                isEnabled: false
            ),
            FeatureToggle(
                name: "another_feature_toggle_name",
                convenientName: "Another feature toggle",
                isEnabled: true
            ),
            FeatureToggle(
                name: "backend_feature_toggle_name",
                convenientName: "Backend feature toggle",
                isEnabled: false
            )
        ]
    )
}
