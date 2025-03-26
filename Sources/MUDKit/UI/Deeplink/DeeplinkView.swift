import Foundation
import SwiftUI

public enum DeeplinkHandleMethod: String, CaseIterable {
    case sceneWillConnectTo
    case sceneOpenURLContexts
    case sceneContinueUserActivity
}

struct DeeplinkView: View {
    @State private var deeplink: String = ""
    @FocusState private var isFocused: Bool
    @State private var selectedMethod: DeeplinkHandleMethod?
    private let methods: [DeeplinkHandleMethod] = DeeplinkHandleMethod.allCases
    
    var body: some View {
        VStack {
            RadioButtonList(selectedMethod: $selectedMethod, methods: methods)
                .padding()
            Spacer()
            InputFieldView(text: $deeplink, prompt: "Deeplink")
                .padding()
            Spacer()
            HStack {
                Button("Let's go") {
                    isFocused = false
                    handleButtonTap()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle("Deeplink")
        .resignResponderOnTap()
    }
    
    init(selectedMethod: DeeplinkHandleMethod?) {
        self.selectedMethod = selectedMethod
    }
    
    private func handleButtonTap() {
        guard
            let url = URL(string: deeplink),
            let scene = UIApplication.shared.connectedScenes.first,
            let sceneDelegate = scene.delegate
        else {
            return
        }
        
        switch selectedMethod {
        case .sceneWillConnectTo:
            if let options = MUDKitConfigurator.sceneDelegateConfiguration?.options {
                sceneDelegate.scene?(scene, willConnectTo: scene.session, options: options)
            }
        case .sceneOpenURLContexts:
            if let contexts = MUDKitConfigurator.sceneDelegateConfiguration?.contexts {
                sceneDelegate.scene?(scene, openURLContexts: contexts)
            }
        case .sceneContinueUserActivity:
            let activity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
            activity.webpageURL = url
            sceneDelegate.scene?(scene, continue: activity)
        case nil:
            return
        }
    }
}

private struct RadioButtonList: View {
    @Binding var selectedMethod: DeeplinkHandleMethod?
    let methods: [DeeplinkHandleMethod]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(methods, id: \.self) { method in
                Button(action: { selectedMethod = method }) {
                    HStack {
                        Text(method.rawValue)
                            .font(.system(size: 20))
                        Spacer()
                        Image(systemName: selectedMethod == method ? "checkmark.circle.fill" : "circle")
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
    DeeplinkView(selectedMethod: nil)
}
