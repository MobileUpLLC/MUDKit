import SwiftUI

struct KeychainView: View {
    @State private var key: String = ""
    @State private var isClearKeychainAlertShown = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Keychain key", text: $key, prompt: Text("Keychain key"))
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue, lineWidth: 2)
                    )
                .padding()
                .focused($isFocused)
            Text("If the field above is empty, the entire Keychain storage will be cleared")
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button("Clear") {
                    isFocused = false
                    isClearKeychainAlertShown = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Keychain")
        .alert("Are you shure?", isPresented: $isClearKeychainAlertShown) {
            Button("Yes", role: .destructive) {
                if key.isEmpty {
                    KeychainService.clear()
                } else {
                    KeychainService.delete(for: key)
                }
            }
            Button("No", role: .cancel) {
                isClearKeychainAlertShown = false
            }
        } message: {
            Text(key.isEmpty ? "Entire Keychain storage will be deleted" : "Value for key \"\(key)\" will be deleted")
        }
    }
}

#Preview {
    KeychainView()
}
