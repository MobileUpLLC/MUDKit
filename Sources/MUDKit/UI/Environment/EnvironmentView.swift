import SwiftUI

struct EnvironmentView: View {
    private enum Constants {
        static let selectedEnvironmentKey = "selectedEnvironment"
    }
    
    @State var environments: [Environment] = MUDKitConfigurator
        .configuration?
        .environmentConfiguration?
        .environments ?? []
    
    @State private var selectedEnvironment: Environment? = MUDKitConfigurator
        .configuration?
        .environmentConfiguration?
        .selectedEnvironment
    
    var body: some View {
        VStack {
            if environments.isEmpty {
                Text("Environments are not found")
            } else {
                List {
                    ForEach($environments, id: \.name) { $environment in
                        HStack {
                            Text(environment.name)
                            Spacer()
                            if environment == selectedEnvironment {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .onTapGesture {
                            selectedEnvironment = environment
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Button("Switch Environment with reboot") {
                        UserDefaultsService.set(value: selectedEnvironment, for: Constants.selectedEnvironmentKey)
                        exit(0)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .background(Color(uiColor: .secondarySystemBackground))
                }
            }
        }
        .navigationTitle("Environments")
    }
}

#Preview {
    EnvironmentView()
}
