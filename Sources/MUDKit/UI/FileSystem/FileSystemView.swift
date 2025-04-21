import SwiftUI

struct FileSystemView: View {
    private struct IdentifiableURL: Identifiable {
        let id = UUID()
        let url: URL
    }
    
    @State private var files: [URL] = []
    @State private var currentDirectory: URL?
    @State private var selectedFile: IdentifiableURL?
    @State private var errorMessage = ""
    @State private var isErrorShown = false
    
    private let fileSystemService = FileSystemService()
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Button(FileSystemService.DirectoryType.documents.rawValue.capitalized) {
                        loadDirectory(type: .documents)
                    }
                    Button(FileSystemService.DirectoryType.temporary.rawValue.capitalized) {
                        loadDirectory(type: .temporary)
                    }
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
                    currentDirectory != FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                    currentDirectory != FileManager.default.temporaryDirectory
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
                            if fileSystemService.getIsDirectory(for: url) {
                                loadSpecificDirectory(url)
                            } else {
                                selectedFile = IdentifiableURL(url: url)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: fileSystemService.getIsDirectory(for: url) ? "folder" : "doc")
                                    Text(url.lastPathComponent)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        if fileSystemService.getIsDirectory(for: url) == false {
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
        .sheet(item: $selectedFile) { identifiableURL in
            FileViewer(fileURL: identifiableURL.url)
        }
        .alert(isPresented: $isErrorShown) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func loadDirectory(type: FileSystemService.DirectoryType) {
        do {
            let (directory, files) = try fileSystemService.loadDirectory(type)
            currentDirectory = directory
            self.files = files
        } catch {
            showErrorMessage(error)
        }
    }
    
    private func loadSpecificDirectory(_ directoryURL: URL) {
        do {
            files = try fileSystemService.loadSpecificDirectory(directoryURL)
            currentDirectory = directoryURL
        } catch {
            showErrorMessage(error)
        }
    }
    
    private func deleteFile(at url: URL) {
        do {
            files = try fileSystemService.deleteFile(at: url, currentDirectory: currentDirectory)
        } catch {
            showErrorMessage(error)
        }
    }
    
    private func showErrorMessage(_ error: Error) {
        if let fileSystemServiceError = error as? FileSystemService.FileSystemServiceError {
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
