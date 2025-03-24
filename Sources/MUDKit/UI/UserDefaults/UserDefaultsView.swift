import SwiftUI

struct UserDefaultsView: View {
    @State private var key: String = ""
    @State private var isDeleteUserDefaultsAlertShown = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            TextField("UserDefaults key", text: $key, prompt: Text("UserDefaults key"))
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
            Text("If the field above is empty, the entire UserDefaults storage will be deleted")
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button("Delete") {
                    isFocused = false
                    isDeleteUserDefaultsAlertShown = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle("UserDefaults")
        .resignResponderOnTap()
        .alert("Are you shure?", isPresented: $isDeleteUserDefaultsAlertShown) {
            Button("Yes", role: .destructive) {
                if key.isEmpty {
                    UserDefaultsService.clear()
                } else {
                    UserDefaultsService.delete(for: key)
                }
            }
            Button("No", role: .cancel) {
                isDeleteUserDefaultsAlertShown = false
            }
        } message: {
            Text(
                key.isEmpty
                ? "Entire UserDefaults storage will be deleted"
                : "Value for key \"\(key)\" will be deleted"
            )
        }
    }
}

#Preview {
    return UserDefaultsView()
}
