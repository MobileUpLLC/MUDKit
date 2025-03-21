import SwiftUI
import PulseUI
import Pulse

struct PulseView: View {
    private let store: LoggerStore
    private let mode: ConsoleMode
    
    var body: some View {
        ConsoleView()
            .closeButtonHidden()
    }
    
    init(store: LoggerStore, mode: ConsoleMode) {
        self.store = store
        self.mode = mode
    }
}

#Preview {
    PulseView(store: .shared, mode: .all)
}
