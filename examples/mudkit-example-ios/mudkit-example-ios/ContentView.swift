import SwiftUI
import MUDKit

struct ContentView: View {
    var body: some View {
        MUDKitView()
            .onAppear {
                FileSampleService.createSampleFiles()
            }
    }
}

#Preview {
    ContentView()
}
