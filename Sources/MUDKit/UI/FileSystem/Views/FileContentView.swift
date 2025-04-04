import SwiftUI
import AVKit

struct FileContentView: View {
    let fileURL: URL
    
    private var contentType: UTType? {
        return try? fileURL.resourceValues(forKeys: [.contentTypeKey]).contentType
    }
    
    var body: some View {
        Group {
            if contentType?.conforms(to: .image) ?? false {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Unable to load image")
                }
            } else if
                (contentType?.conforms(to: .video) ?? false)
                || (contentType?.conforms(to: .movie) ?? false)
            {
                VideoPlayer(player: AVPlayer(url: fileURL))
                    .scaledToFit()
            } else if
                (contentType?.conforms(to: .html) ?? false)
                || (contentType?.conforms(to: .json) ?? false)
                || (contentType?.conforms(to: .xml) ?? false)
            {
                WebView(url: fileURL)
            } else if contentType?.conforms(to: .audio) ?? false {
                AudioPlayerView(url: fileURL)
            } else {
                if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
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
