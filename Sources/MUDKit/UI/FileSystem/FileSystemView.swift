import SwiftUI

struct FileSystemView: View {
    private struct IdentifiableURL: Identifiable {
        let id = UUID()
        let url: URL
    }
    
    @State private var files: [URL] = []
    @State private var currentDirectory: FileSystemServiceDirectoryType?
    @State private var currentDirectoryUrl: URL?
    @State private var selectedFile: IdentifiableURL?
    @State private var errorMessage = ""
    @State private var fileUrlToShare: URL?
    @State private var isErrorShown = false
    @State private var isShareSheetPresented = false
    
    private let fileSystemService = FileSystemService()
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Button(FileSystemServiceDirectoryType.documents.name) {
                        loadDirectory(type: .documents)
                    }
                    Button(FileSystemServiceDirectoryType.temporary.name) {
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
            List {
                if case let .specific(url) = currentDirectory {
                    Button {
                        loadDirectory(type: .specific(url: url.deletingLastPathComponent()))
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
                                    loadDirectory(type: .specific(url: url))
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
    
    private func isDirectory(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
    
    private func loadDirectory(type: FileSystemServiceDirectoryType) {
        do {
            let (directoryType, directoryUrl, files) = try fileSystemService.loadDirectory(type)
            self.currentDirectory = directoryType
            self.currentDirectoryUrl = directoryUrl
            self.files = files
        } catch {
            showErrorMessage(error)
        }
    }
    
    private func deleteFile(at url: URL) {
        guard let currentDirectory else {
            return
        }
        
        if fileSystemService.deleteFile(at: url) {
            do {
                let (_, _, files) = try fileSystemService.loadDirectory(currentDirectory)
                self.files = files
            } catch {
                showErrorMessage(error)
            }
        } else {
            showErrorMessage(FileSystemServiceError.deleteFileError)
        }
    }
    
    private func showErrorMessage(_ error: Error) {
        if let fileSystemServiceError = error as? FileSystemServiceError {
            errorMessage = fileSystemServiceError.message
        } else {
            errorMessage = error.localizedDescription
        }
        
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
