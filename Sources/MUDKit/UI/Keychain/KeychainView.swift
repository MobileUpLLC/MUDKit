import SwiftUI

struct KeychainView: View {
    @State private var key: String = ""
    @State private var isClearKeychainAlertShown = false
    
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
            Text("If the field above is empty, the entire Keychain storage will be cleared")
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button("Clear with reboot") {
                    isClearKeychainAlertShown = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Keychain")
        .alert("Are you shure?", isPresented: $isClearKeychainAlertShown) {
            Button("Yes", role: .destructive) {
                if key.isEmpty {
                    KeychainService.clear()
                } else {
                    KeychainService.delete(for: key)
                }
                
                exit(0)
            }
            Button("No", role: .cancel) {
                isClearKeychainAlertShown = false
            }
        }
    }
}

#Preview {
    KeychainView()
}
