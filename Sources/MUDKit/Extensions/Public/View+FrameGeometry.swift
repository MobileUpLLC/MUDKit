import SwiftUI

public extension View {
    func frameGeometry(_ color: Color = .red) -> some View {
        modifier(FrameGeometry(color: color))
    }
}

private struct FrameGeometry: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        if UserDefaultsService.get(for: Key.frameGeometry.rawValue) == true {
            content
                .overlay(GeometryReader(content: overlayContent))
        } else {
            content
        }
    }
    
    func overlayContent(for geometry: GeometryProxy) -> some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(color)
            Text(describe(geometry))
                .font(.caption2)
                .foregroundColor(color)
                .padding(2)
        }
    }
    
    private func describe(_ geometry: GeometryProxy) -> String {
        var information: [String] = []
        let size = "\(Int(geometry.size.width))x\(Int(geometry.size.height))"
        information.append(size)
        
        if geometry.safeAreaInsets != EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0 ) {
            let safeAreaInsets = [
                geometry.safeAreaInsets.top,
                geometry.safeAreaInsets.leading,
                geometry.safeAreaInsets.trailing,
                geometry.safeAreaInsets.bottom
            ].map { "\(Int($0))" }.joined(separator: ";")
            
            information.append("[\(safeAreaInsets)]")
        }
        
        return information.joined(separator: " ")
    }
}
