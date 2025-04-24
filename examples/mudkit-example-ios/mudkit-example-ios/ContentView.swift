import SwiftUI
import MUDKit

struct ContentView: View {
    var body: some View {
        MUDKitView()
            .onAppear {
                MUDKitService.createSampleFilesForFileSystemServiceDemo()
            }
    }
}

#Preview {
    ContentView()
}
