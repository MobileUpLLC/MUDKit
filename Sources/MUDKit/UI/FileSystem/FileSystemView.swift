import SwiftUI

struct FileSystemView: View {
    private struct IdentifiableURL: Identifiable {
        let id = UUID()
        let url: URL
    }
    
    @State private var files: [URL] = []
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
                        loadDirectory(directory: .documents)
                    }
                    Button("Temporary") {
                        loadDirectory(directory: .temporary)
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
            List {
                Button {
                    loadPreviousDirectory()
                } label: {
                    Image(systemName: "chevron.left")
                }
                ForEach(files, id: \.self) { url in
                    HStack {
                        Button {
                            if isDirectory(url) {
                                loadContentOfUrl(url: url)
                            } else {
                                selectedFile = IdentifiableURL(url: url)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: isDirectory(url) ? "folder" : "doc")
                                    Text(url.lastPathComponent)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        if isDirectory(url) == false {
                            Button("Delete") {
                                deleteFile(at: url)
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("File System")
        .onAppear {
            loadDirectory(directory: .documents)
        }
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
    
    private func loadDirectory(
        directory: FileSystemServiceDirectoryType,
        fileName: String? = nil,
        fileExtension: String? = nil
    ) {
        guard
            let directoryUrl = fileSystemService.constructPath(directory: directory, fileName: nil, fileExtension: nil),
            let content = fileSystemService.getContentOfUrl(directoryUrl)
        else {
            return showErrorMessage("Невозможно загрузить директорию \(directory)")
        }

        currentDirectoryUrl = directoryUrl
        files = content
    }
    
    private func loadContentOfUrl(url: URL) {
        guard let content = fileSystemService.getContentOfUrl(url)
                
        else {
            return showErrorMessage("Невозможно загрузить директорию \(url.absoluteString)")
        }

        currentDirectoryUrl = url
        files = content
    }
    
    private func loadPreviousDirectory() {
        guard
            let previousDirectoryUrl = currentDirectoryUrl?.deletingLastPathComponent(),
            let content = fileSystemService.getContentOfUrl(previousDirectoryUrl)
        else {
            return showErrorMessage("Невозможно загрузить предыдущую директорию")
        }
        
        currentDirectoryUrl = previousDirectoryUrl
        files = content
    }
    
    private func deleteFile(at url: URL) {
        if fileSystemService.deleteFile(at: url) {
            guard
                let currentDirectoryUrl,
                let content = fileSystemService.getContentOfUrl(currentDirectoryUrl)
            else {
                return showErrorMessage("Невозможно обновить директорию")
            }
            
            files = content
        } else {
            showErrorMessage("Невозможно удалить файл")
        }
    }
    
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
