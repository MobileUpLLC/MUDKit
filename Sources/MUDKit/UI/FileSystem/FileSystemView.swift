import SwiftUI

struct FileSystemView: View {
    @State private var files: [URL] = []
    @State private var currentDirectoryUrl: URL?
    @State private var errorMessage = ""
    @State private var isErrorPresented = false
    @State private var isCopied = false
    @State private var isShareSheetPresented = false
    @State private var isRootDirectory = true
    @State private var sharingUrl: URL?

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
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: isDirectory(url) ? "folder" : "doc")
                                Text(url.lastPathComponent)
                            }
                            .onTapGesture {
                                if isDirectory(url) {
                                    loadContentOfUrl(url: url)
                                }
                            }
                        }
                        Spacer(minLength: 20)
                        if isDirectory(url) == false {
                            HStack(spacing: 20) {
                                Image(systemName: "square.and.arrow.up")
                                    .onTapGesture {
                                        isShareSheetPresented = true

                                        Task {
                                            self.sharingUrl = url
                                        }
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
        .alert(isPresented: $isErrorPresented) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $isShareSheetPresented) {
            sharingUrl = nil
        } content: {
            Group {
                if let sharingUrl {
                    ShareSheetView(activityItems: [sharingUrl])
                } else {
                    ProgressView()
                }
            }
            .ignoresSafeArea()
        }
    }
    
    init() {
        documentsDirectoryUrl = fileSystemService.constructDirectoryUrl(.documents)
        temporaryDirectoryUrl = fileSystemService.constructDirectoryUrl(.temporary)
    }
    
    private func isDirectory(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
    
    private func loadDirectory(directory: FileSystemServiceDirectoryType) {
        guard let url = fileSystemService.constructDirectoryUrl(directory) else {
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
        guard
            let currentDirectoryUrl,
            fileSystemService.deleteFile(at: url)
        else {
            return showErrorMessage("Невозможно удалить файл")
        }
        
        loadContentOfUrl(url: currentDirectoryUrl)
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
            try await Task.sleep(for: .seconds(1.5))
            isCopied = false
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        isErrorPresented = true
    }
}

#Preview {
    FileSystemView()
}
