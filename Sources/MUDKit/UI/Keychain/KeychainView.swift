import SwiftUI

struct KeychainView: View {
    @State private var key: String = ""
    @State private var isDeleteKeychainAlertShown = false
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
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            Text("If the field above is empty, the entire Keychain storage will be deleted")
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button("Delete") {
                    isFocused = false
                    isDeleteKeychainAlertShown = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle("Keychain")
        .resignResponderOnTap()
        .alert("Are you shure?", isPresented: $isDeleteKeychainAlertShown) {
            Button("Yes", role: .destructive) {
                if key.isEmpty {
                    KeychainService.clear()
                } else {
                    KeychainService.delete(for: key)
                }
            }
            Button("No", role: .cancel) {
                isDeleteKeychainAlertShown = false
            }
        } message: {
            Text(key.isEmpty ? "Entire Keychain storage will be deleted" : "Value for key \"\(key)\" will be deleted")
        }
    }
}

#Preview {
    KeychainView()
}
