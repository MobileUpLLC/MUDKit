import SwiftUI
import PulseUI
import Pulse

struct PulseView: View {
    let store: LoggerStore
    let mode: ConsoleMode
    
    var body: some View {
        ConsoleView()
            .closeButtonHidden()
    }
}

#Preview {
    PulseView(store: .shared, mode: .all)
}
