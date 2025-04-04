import SwiftUI

struct InputFieldView: View {
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    private let prompt: String
    private let textContentType: UITextContentType?
    private let keyboardType: UIKeyboardType
    
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
            .textContentType(textContentType)
            .keyboardType(keyboardType)
    }
    
    init(
        text: Binding<String>,
        prompt: String,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) {
        self._text = text
        self.prompt = prompt
        self.keyboardType = keyboardType
        self.textContentType = textContentType
    }
}

#Preview {
    InputFieldView(text: .constant(""), prompt: "prompt")
}
