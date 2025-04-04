import SwiftUI

struct FeatureTogglesView: View {
    @State private var featureToggles: [FeatureToggle] = MUDKitConfigurator
        .configuration?
        .featureToggleConfiguration?
        .featureToggles ?? []
    @State private var isOverrideBaseConfig: Bool = UserDefaultsService.get(
        for: Key.isOverrideBaseConfig.rawValue
    ) ?? false
    
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
                        UserDefaultsService.set(value: isOverrideBaseConfig, for: Key.isOverrideBaseConfig.rawValue)
                        UserDefaultsService.set(value: featureToggles, for: Key.featureToggles.rawValue)
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
    FeatureTogglesView()
}
