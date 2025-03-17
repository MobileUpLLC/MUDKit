import SwiftUI

public struct MUDKitView: View {
    public var body: some View {
        NavigationView {
            List {
                NavigationLink("Pulse") {
                    PulseView()
                }
            }
            .navigationTitle("MUDKit")
        }
    }
    
    public init() {}
}

#Preview {
    MUDKitView()
}
