import SwiftUI

struct DeeplinkView: View {
    @State private var text: String = ""
    @State private var isError: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            InputFieldView(text: $text, prompt: "Deeplink", keyboardType: .URL, textContentType: .URL)
                .padding()
            if isError {
                Text("The text you entered is not a valid URL")
            }
            Spacer()
            HStack {
                Button("Let's go") {
                    guard let url = URL(string: text) else {
                        isError = true
                        return
                    }
                    
                    isError = false
                    isFocused = false
                    MUDKitConfigurator.configuration?.deeplinkConfiguration?.deeplinkHandler(url)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle("Deeplink")
        .resignResponderOnTap()
    }
}

#Preview {
    DeeplinkView()
}
