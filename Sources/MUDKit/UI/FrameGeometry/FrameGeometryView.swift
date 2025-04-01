import SwiftUI

struct FrameGeometryView: View {
    @State private var isEnabled: Bool = UserDefaultsService.get(for: Key.frameGeometry.rawValue) ?? false
    
    var body: some View {
        VStack {
            Toggle("Frame geometry", isOn: $isEnabled)
                .padding()
                .onChange(of: isEnabled) { newValue in
                    UserDefaultsService.set(value: newValue, for: Key.frameGeometry.rawValue)
                }
            Spacer()
        }
        .navigationTitle("Feature toggles")
        .animation(.default, value: isEnabled)
    }
}

#Preview {
    FrameGeometryView()
}
