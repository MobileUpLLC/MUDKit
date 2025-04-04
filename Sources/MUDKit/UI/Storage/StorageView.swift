import SwiftUI

enum StorageType {
    case userDefaults
    case keychain
    
    var title: String {
        switch self {
        case .userDefaults:
            return "UserDefaults"
        case .keychain:
            return "Keychain"
        }
    }
    
    var prompt: String {
        return "\(title) key"
    }
    
    var warning: String {
        return "If the field above is empty, the entire \(title) storage will be deleted"
    }
    
    func clear() {
        switch self {
        case .userDefaults:
            UserDefaultsService.clear()
        case .keychain:
            KeychainService.clear()
        }
    }
    
    func delete(for key: String) {
        switch self {
        case .userDefaults:
            UserDefaultsService.delete(for: key)
        case .keychain:
            KeychainService.delete(for: key)
        }
    }
    
    func alertMessage(for key: String) -> String {
        return key.isEmpty ? "Entire \(title) storage will be deleted" : "Value for key \"\(key)\" will be deleted"
    }
}

struct StorageView: View {
    private let type: StorageType
    @State private var key: String = ""
    @State private var isAlertShown = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            InputFieldView(text: $key, prompt: type.prompt)
                .padding()
            Text(type.warning)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button("Delete") {
                    isFocused = false
                    isAlertShown = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle(type.title)
        .resignResponderOnTap()
        .alert("Are you shure?", isPresented: $isAlertShown) {
            Button("Yes", role: .destructive) {
                if key.isEmpty {
                    type.clear()
                } else {
                    type.delete(for: key)
                }
            }
            Button("No", role: .cancel) {
                isAlertShown = false
            }
        } message: {
            Text(type.alertMessage(for: key))
        }
    }
    
    init(type: StorageType) {
        self.type = type
    }
}

#Preview {
    return StorageView(type: .userDefaults)
}
