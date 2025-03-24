import SwiftUI

struct UserDefaultsView: View {
    @State private var key: String = ""
    @State private var isClearUserDefaultsAlertShown = false
    
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
            Text("If the field above is empty, the entire UserDefaults storage will be cleared")
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button("Clear with reboot") {
                    isClearUserDefaultsAlertShown = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("UserDefaults")
        .alert("Are you shure?", isPresented: $isClearUserDefaultsAlertShown) {
            Button("Yes", role: .destructive) {
                if key.isEmpty {
                    UserDefaultsService.clear()
                } else {
                    UserDefaultsService.delete(for: key)
                }
                
                exit(0)
            }
            Button("No", role: .cancel) {
                isClearUserDefaultsAlertShown = false
            }
        }
    }
}

#Preview {
    return UserDefaultsView()
}
