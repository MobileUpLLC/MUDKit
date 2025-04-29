import SwiftUI
import UniformTypeIdentifiers.UTType

struct FileContentView: View {
    let fileUrl: URL
    
    private var contentType: UTType? {
        return try? fileUrl.resourceValues(forKeys: [.contentTypeKey]).contentType
    }
    
    var body: some View {
        Group {
            if
                let contentType,
                checkWebViewTypeConformance(type: contentType)
            {
                WebView(url: fileUrl)
            } else {
                if let content = try? String(contentsOf: fileUrl, encoding: .utf8) {
                    ScrollView {
                        Text(content)
                            .padding()
                    }
                } else {
                    Text("Unsupported file type")
                }
            }
        }
    }
    
    private func checkWebViewTypeConformance(type: UTType) -> Bool {
        let conformingTypes: [UTType] = [.image, .movie, .mp3, .aiff, .html, .json, .xml]
        
        return conformingTypes.contains(where: { type.conforms(to: $0) })
    }
}
