import Foundation
import SwiftUI

enum DeeplinkHandleMethod: String, CaseIterable {
    case openURLContexts
    case continueUserActivity
}

struct DeeplinkView: View {
    @State private var deeplink: String = ""
    @FocusState private var isFocused: Bool
    
    @State private var selectedOption = DeeplinkHandleMethod.continueUserActivity.rawValue
    private var options: [String] {
        var options: [String] = []
        for method in DeeplinkHandleMethod.allCases {
            options.append(method.rawValue)
        }
        
        return options
    }
    
    var body: some View {
        VStack {
            RadioButtonList(selectedOption: $selectedOption, options: options)
                .padding()
            Spacer()
            InputFieldView(text: $deeplink, prompt: "Deeplink")
                .padding()
            Spacer()
            HStack {
                Button("Let's go") {
                    isFocused = false
                    guard let url = URL(string: deeplink) else { return }
                    
                    let activity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
                    activity.webpageURL = url
                    
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? UISceneDelegate {
                        sceneDelegate.scene!(UIApplication.shared.connectedScenes.first!, continue: activity)
                    }
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

private struct RadioButtonList: View {
    @Binding var selectedOption: String
    let options: [String]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(options, id: \.self) { option in
                Button(action: { selectedOption = option }) {
                    HStack {
                        Text(option)
                            .font(.system(size: 20))
                        Spacer()
                        Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.accentColor)
                            .font(.system(size: 20))
                    }
                }
                .foregroundColor(.primary)
            }
        }
    }
}


#Preview {
    DeeplinkView()
}
