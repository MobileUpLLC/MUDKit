import SwiftUI

struct InputFieldView: View {
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    private let prompt: String
    
    var body: some View {
        TextField(prompt, text: $text, prompt: Text(prompt))
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFocused ? .blue : .gray, lineWidth: 2)
            )
            .focused($isFocused)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
    
    init(text: Binding<String>, prompt: String) {
        self._text = text
        self.prompt = prompt
    }
}

#Preview {
    InputFieldView(text: .constant(""), prompt: "prompt")
}
