import SwiftUI

struct FileSystemView: View {
    @State private var files: [URL] = []
    @State private var currentDirectoryUrl: URL? { didSet { updateIsRootDirectory() } }
    @State private var selectedFile: URL?
    @State private var errorMessage = ""
    @State private var fileUrlToShare: URL?
    @State private var isErrorShown = false
    @State private var isCopied = false
    @State private var isFileOpened = false
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
                HStack(spacing: 20) {
                    Text("Current directory: \(currentDirectoryUrl.absoluteString)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                    Button {
                        copyDirectoryPath()
                    } label: {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                            .frame(width: 24, height: 24)
                    }
                    .disabled(isCopied)
                }
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
                                    selectedFile = url
                                    isFileOpened = true
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
        .sheet(isPresented: $isFileOpened) {
            if let selectedFile {
                FileViewer(fileURL: selectedFile)
            } else {
                EmptyView()
            }
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
    
    private func loadDirectory(directory: FileSystemServiceDirectoryType) {
        guard let url = fileSystemService.constructPath(directory: directory, fileName: nil, fileExtension: nil) else {
            return showErrorMessage("Невозможно загрузить директорию \(directory)")
        }
        
        loadContentOfUrl(url: url)
    }
    
    private func loadPreviousDirectory() {
        guard let url = currentDirectoryUrl?.deletingLastPathComponent() else {
            return showErrorMessage("Невозможно загрузить предыдущую директорию")
        }
        
        loadContentOfUrl(url: url)
    }
    
    private func loadContentOfUrl(url: URL) {
        guard let content = fileSystemService.getContentOfUrl(url)
                
        else {
            return showErrorMessage("Невозможно загрузить директорию \(url.absoluteString)")
        }

        currentDirectoryUrl = url
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
        isRootDirectory = currentDirectoryUrl == documentsDirectoryUrl || currentDirectoryUrl == temporaryDirectoryUrl
    }
    
    private func copyDirectoryPath() {
        if let currentDirectoryUrl {
            isCopied = true
            
            UIPasteboard.general.string = currentDirectoryUrl.absoluteString
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isCopied = false
            }
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
