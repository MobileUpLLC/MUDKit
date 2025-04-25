import SwiftUI

struct FileSystemView: View {
    private struct IdentifiableURL: Identifiable {
        let id = UUID()
        let url: URL
    }
    
    @State private var files: [URL] = []
//    @State private var currentDirectory: FileSystemServiceDirectoryType?
    @State private var currentDirectoryUrl: URL?
    @State private var selectedFile: IdentifiableURL?
    @State private var errorMessage = ""
    @State private var isErrorShown = false
    
    private let fileSystemService = FileSystemService()
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Button("Documents") {
                        loadDirectory(type: .documents)
                    }
                    Button("Temporary") {
                        loadDirectory(type: .temporary)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            if let currentDirectoryUrl {
                Text("Current directory: \(currentDirectoryUrl.absoluteString)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
//            List {
//                if case let .specific(url) = currentDirectory {
//                    Button {
//                        loadDirectory(type: .specific(url: url.deletingLastPathComponent()))
//                    } label: {
//                        Image(systemName: "chevron.left")
//                    }
//                }
//                ForEach(files, id: \.self) { url in
//                    HStack {
//                        Button {
//                            if isDirectory(url) {
//                                loadDirectory(type: .specific(url: url))
//                            } else {
//                                selectedFile = IdentifiableURL(url: url)
//                            }
//                        } label: {
//                            VStack(alignment: .leading, spacing: 4) {
//                                HStack {
//                                    Image(systemName: isDirectory(url) ? "folder" : "doc")
//                                    Text(url.lastPathComponent)
//                                }
//                            }
//                        }
//                        .buttonStyle(.plain)
//                        Spacer()
//                        if isDirectory(url) == false {
//                            Button("Delete") {
//                                deleteFile(at: url)
//                            }
//                            .foregroundColor(.red)
//                        }
//                    }
//                }
//            }
        }
        .navigationTitle("File System")
        .sheet(item: $selectedFile) { identifiableURL in
            FileViewer(fileURL: identifiableURL.url)
        }
        .alert(isPresented: $isErrorShown) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func isDirectory(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
    
    private func loadDirectory(type: FileSystemServiceDirectoryType) {
        guard
            let directoryUrl = fileSystemService.constructPath(fileDirectory: type, fileName: nil, fileExtension: nil),
            let content = fileSystemService.getContentOfUrl(directoryUrl)
        else {
            return showErrorMessage("Невозможно загрузить директорию \(type)")
        }

        currentDirectoryUrl = directoryUrl
        files = content
    }
    
//    private func deleteFile(at url: URL) {
//        guard let currentDirectory else {
//            return
//        }
//        
//        if fileSystemService.deleteFile(at: url) {
//            do {
//                let (_, _, files) = try fileSystemService.loadDirectory(currentDirectory)
//                self.files = files
//            } catch {
//                showErrorMessage(error)
//            }
//        } else {
//            showErrorMessage(FileSystemServiceError.deleteFileError)
//        }
//    }
    
    private func showErrorMessage(_ message: String) {
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

#Preview {
    FileSystemView()
}
