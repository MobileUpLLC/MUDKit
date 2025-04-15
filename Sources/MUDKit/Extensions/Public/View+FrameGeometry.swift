import SwiftUI

public extension View {
    func frameGeometry(_ color: Color = .red) -> some View {
        modifier(FrameGeometry(color: color))
    }
}
