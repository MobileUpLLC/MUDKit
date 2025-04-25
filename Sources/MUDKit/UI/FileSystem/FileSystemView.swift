import SwiftUI

struct FileSystemView: View {
    private struct IdentifiableURL: Identifiable {
        let id = UUID()
        let url: URL
    }
    
    @State private var files: [URL] = []
    @State private var currentDirectoryUrl: URL? { didSet { updateIsRootDirectory() } }
    @State private var selectedFile: IdentifiableURL?
    @State private var errorMessage = ""
    @State private var fileUrlToShare: URL?
    @State private var isErrorShown = false
    @State private var isShareSheetPresented = false
    @State private var isRootDirectory = true
    
    private let documentsDirectoryUrl: URL?
    private let temporaryDirectoryUrl: URL?
    
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
                if isRootDirectory == false {
                    Button {
                        loadPreviousDirectory()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ForEach(files, id: \.self) { url in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: isDirectory(url) ? "folder" : "doc")
                                Text(url.lastPathComponent)
                            }
                            .onTapGesture {
                                if isDirectory(url) {
                                    loadContentOfUrl(url: url)
                                } else {
                                    selectedFile = IdentifiableURL(url: url)
                                }
                            }
                        }
                        Spacer(minLength: 20)
                        if isDirectory(url) == false {
                            HStack(spacing: 20) {
                                Image(systemName: "square.and.arrow.up")
                                    .onTapGesture {
                                        fileUrlToShare = url
                                        isShareSheetPresented = true
                                    }
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        deleteFile(at: url)
                                    }
                            }
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
        .sheet(isPresented: $isShareSheetPresented) {
            if let fileUrlToShare {
                ShareSheetView(activityItems: [fileUrlToShare])
            }
        }
    }
    
    init() {
        documentsDirectoryUrl = fileSystemService.constructPath(
            directory: .documents,
            fileName: nil,
            fileExtension: nil
        )
        temporaryDirectoryUrl = fileSystemService.constructPath(
            directory: .temporary,
            fileName: nil,
            fileExtension: nil
        )
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
    
    private func updateIsRootDirectory() {
        if currentDirectoryUrl == documentsDirectoryUrl || currentDirectoryUrl == temporaryDirectoryUrl {
            isRootDirectory = true
        } else {
            isRootDirectory = false
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
