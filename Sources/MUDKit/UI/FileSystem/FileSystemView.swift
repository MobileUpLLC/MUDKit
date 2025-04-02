import SwiftUI
import AVKit
import WebKit

struct FileSystemView: View {
    private enum DirectoryType: String {
        case documents
        case temporary
    }
    
    private struct IdentifiableURL: Identifiable {
        let id = UUID()
        let url: URL
    }
    
    @State private var files: [URL] = []
    @State private var currentDirectory: URL?
    @State private var selectedFile: IdentifiableURL?
    @State private var errorMessage = ""
    @State private var isErrorShown = false
    
    private let fileManager = FileManager.default
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Button(DirectoryType.documents.rawValue.capitalized) { loadDirectory(.documents) }
                    Button(DirectoryType.temporary.rawValue.capitalized) { loadDirectory(.temporary) }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            if let currentDirectory {
                Text("Current directory: \(currentDirectory.path)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
            List {
                if
                    let currentDirectory,
                    currentDirectory != fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
                    currentDirectory != fileManager.temporaryDirectory
                {
                    Button {
                        loadSpecificDirectory(currentDirectory.deletingLastPathComponent())
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ForEach(files, id: \.self) { url in
                    HStack {
                        Button {
                            if url.isDirectory {
                                loadSpecificDirectory(url)
                            } else {
                                selectedFile = IdentifiableURL(url: url)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: url.isDirectory ? "folder" : "doc")
                                    Text(url.lastPathComponent)
                                }
                                if url.isDirectory == false {
                                    HStack(spacing: 8) {
                                        Group {
                                            Text(url.fileSize)
                                            Text(url.creationDate)
                                        }
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        if url.isDirectory == false {
                            Button("Delete") { deleteFile(at: url) }
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("File System")
        .sheet(item: $selectedFile) { identifiableURL in
            FileViewer(fileURL: identifiableURL.url)
        }
        .alert(isPresented: $isErrorShown) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func loadDirectory(_ type: DirectoryType) {
        do {
            let directoryURL: URL
            
            switch type {
            case .documents:
                directoryURL = try fileManager.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
            case .temporary:
                directoryURL = fileManager.temporaryDirectory
            }
            
            loadSpecificDirectory(directoryURL)
        } catch {
            showError("Failed to find \(type.rawValue.capitalized) directory: \(error.localizedDescription)")
        }
    }
    
    private func loadSpecificDirectory(_ directoryURL: URL) {
        do {
            let directoryContents = try fileManager.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey],
                options: [.skipsHiddenFiles]
            )
            
            currentDirectory = directoryURL
            files = directoryContents
        } catch {
            showError("Failed to load directory: \(error.localizedDescription)")
        }
    }
    
    private func deleteFile(at url: URL) {
        do {
            try fileManager.removeItem(at: url)
            
            if let currentDir = currentDirectory {
                loadSpecificDirectory(currentDir)
            }
        } catch {
            showError("Failed to delete file: \(error.localizedDescription)")
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        isErrorShown = true
    }
}

private struct FileViewer: View {
    let fileURL: URL
    
    @SwiftUI.Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            FileContentView(fileURL: fileURL)
                .navigationTitle(fileURL.lastPathComponent)
                .navigationBarItems(trailing: Button("Close") { dismiss() })
        }
    }
}

private struct FileContentView: View {
    let fileURL: URL
    
    var body: some View {
        Group {
            if fileURL.isImage {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Unable to load image")
                }
            } else if fileURL.isVideo {
                VideoPlayer(player: AVPlayer(url: fileURL))
                    .scaledToFit()
            } else if fileURL.isWebPage {
                WebView(url: fileURL)
            } else if fileURL.isAudio {
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

private struct AudioPlayerView: View {
    let url: URL
    
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false

    private var trackName: String { url.deletingPathExtension().lastPathComponent }
    
    var body: some View {
        VStack {
            Text(trackName)
                .font(.headline)
                .padding()
            
            HStack(spacing: 20) {
                AudioPlayerButton(systemName: "play.circle") {
                    if player == nil {
                        player = AVPlayer(url: url)
                    }
                    player?.play()
                    isPlaying = true
                }
                .disabled(isPlaying)
                
                AudioPlayerButton(systemName: "pause.circle") {
                    player?.pause()
                    isPlaying = false
                }
                .disabled(isPlaying == false)
                
                AudioPlayerButton(systemName: "stop.circle") {
                    player?.pause()
                    player?.seek(to: .zero)
                    isPlaying = false
                }
            }
            .padding()
        }
        .onDisappear {
            player?.pause()
            isPlaying = false
        }
    }
}

private struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

private struct AudioPlayerButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    FileSystemView()
}
