import SwiftUI

struct FileSystemView: View {
    @State private var files: [URL] = []
    @State private var currentDirectoryUrl: URL?
    @State private var selectedFile: URL?
    @State private var errorMessage = ""
    @State private var isErrorPresented = false
    @State private var isCopied = false
    @State private var isFileOpened = false
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
                    .padding(.trailing, 20)
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
                        Button {
                            if isDirectory(url) {
                                loadContentOfUrl(url: url)
                            } else {
                                selectedFile = url
                                isFileOpened = true
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
        .sheet(isPresented: $isFileOpened) {
            if let selectedFile {
                FileViewer(fileUrl: selectedFile)
            } else {
                EmptyView()
            }
        }
        .alert(isPresented: $isErrorPresented) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    init() {
        documentsDirectoryUrl = fileSystemService.constructDirectoryPath(.documents)
        temporaryDirectoryUrl = fileSystemService.constructDirectoryPath(.temporary)
    }
    
    private func isDirectory(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
    
    private func loadDirectory(directory: FileSystemServiceDirectoryType) {
        guard let url = fileSystemService.constructDirectoryPath(directory) else {
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
    
    private func deleteFile(at url: URL) {
        if fileSystemService.deleteFile(at: url) {
            guard let currentDirectoryUrl else {
                return showErrorMessage("Невозможно обновить директорию")
            }
            
            loadContentOfUrl(url: currentDirectoryUrl)
        } else {
            showErrorMessage("Невозможно удалить файл")
        }
    }
    
    private func loadContentOfUrl(url: URL) {
        guard let content = fileSystemService.getContentOfUrl(url) else {
            return showErrorMessage("Невозможно загрузить директорию \(url.absoluteString)")
        }

        updateCurrentDirectoryUrl(url)
        files = content
    }
    
    private func updateCurrentDirectoryUrl(_ url: URL) {
        currentDirectoryUrl = url
        isRootDirectory = currentDirectoryUrl == documentsDirectoryUrl || currentDirectoryUrl == temporaryDirectoryUrl
    }
    
    private func copyDirectoryPath() {
        guard let currentDirectoryUrl else {
            return
        }
        
        isCopied = true
        UIPasteboard.general.string = currentDirectoryUrl.absoluteString
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 1_500_000_000)
            isCopied = false
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        isErrorPresented = true
    }
}

private struct FileViewer: View {
    let fileUrl: URL
    
    @SwiftUI.Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            FileContentView(fileUrl: fileUrl)
                .navigationTitle(fileUrl.lastPathComponent)
                .navigationBarItems(trailing: Button("Close") { dismiss() })
        }
    }
}

#Preview {
    FileSystemView()
}
