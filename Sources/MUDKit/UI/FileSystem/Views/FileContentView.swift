import SwiftUI
import UniformTypeIdentifiers.UTType

struct FileContentView: View {
    let fileUrl: URL
    
    private var contentType: UTType? {
        return try? fileUrl.resourceValues(forKeys: [.contentTypeKey]).contentType
    }
    
    var body: some View {
        Group {
            if contentType?.conforms(to: .image) ?? false {
                if let image = UIImage(contentsOfFile: fileUrl.path) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Unable to load image")
                }
            } else if
                (contentType?.conforms(to: .html) ?? false)
                || (contentType?.conforms(to: .json) ?? false)
                || (contentType?.conforms(to: .xml) ?? false)
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
}
