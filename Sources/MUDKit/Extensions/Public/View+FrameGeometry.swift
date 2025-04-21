import SwiftUI

public extension View {
    /// Applies a frame geometry overlay to a SwiftUI view for debugging, showing a dashed border and size information.
    /// The overlay is only visible if the frameGeometry feature is enabled in UserDefaults.
    /// - Parameter color: The color of the dashed border and text label. Defaults to red.
    /// - Returns: A modified view with the FrameGeometry modifier applied.
    func frameGeometry(_ color: Color = .red) -> some View {
        modifier(FrameGeometry(color: color))
    }
}
