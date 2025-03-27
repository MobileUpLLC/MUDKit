import Foundation
import SwiftUI

public enum DeeplinkHandleMethod: String, CaseIterable {
    case sceneWillConnectTo
    case sceneOpenURLContexts
    case sceneContinueUserActivity
}

struct DeeplinkView: View {
    @State private var text: String = ""
    @State private var isError: Bool = false
    @FocusState private var isFocused: Bool
    private let error: String = "Looks like your text isn't valid url"
    
    var body: some View {
        VStack {
            Spacer()
            InputFieldView(text: $text, prompt: "Deeplink")
                .padding()
            if isError {
                Text(error)
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
