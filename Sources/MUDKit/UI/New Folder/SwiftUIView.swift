import SwiftUI

struct FrameGeometryView: View {
    @State private var isEnabled: Bool = UserDefaultsService.get(for: Key.frameGeometry.rawValue) ?? false
    
    var body: some View {
        Toggle("Frame geometry", isOn: $isEnabled)
            .onChange(of: isEnabled) { newValue in
                UserDefaultsService.set(value: newValue, for: Key.frameGeometry.rawValue)
            }
    }
}

#Preview {
    FrameGeometryView()
}
