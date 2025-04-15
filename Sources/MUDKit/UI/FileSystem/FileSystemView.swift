import SwiftUI
import UniformTypeIdentifiers

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
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Button(FileSystemService.DirectoryType.documents.rawValue.capitalized) {
                        Task {
                            await loadDirectory(type: .documents)
                        }
                    }
                    Button(FileSystemService.DirectoryType.temporary.rawValue.capitalized) {
                        Task {
                            await loadDirectory(type: .temporary)
                        }
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
                        Task {
                            await loadSpecificDirectory(currentDirectory.deletingLastPathComponent())
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ForEach(files, id: \.self) { url in
                    HStack {
                        Button {
                            if FileSystemService.getIsDirectory(for: url) {
                                Task {
                                    await loadSpecificDirectory(url)
                                }
                            } else {
                                selectedFile = IdentifiableURL(url: url)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: FileSystemService.getIsDirectory(for: url) ? "folder" : "doc")
                                    Text(url.lastPathComponent)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        if FileSystemService.getIsDirectory(for: url) == false {
                            Button("Delete") {
                                Task {
                                    await deleteFile(at: url)
                                }
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
    
    private func loadDirectory(type: FileSystemService.DirectoryType) async {
        do {
            let (directory, files) = try await FileSystemService.loadDirectory(type)
            currentDirectory = directory
            self.files = files
        } catch {
            showError("Failed to find \(type.rawValue.capitalized) directory")
        }
    }
    
    private func loadSpecificDirectory(_ directoryURL: URL) async {
        do {
            files = try await FileSystemService.loadSpecificDirectory(directoryURL)
            currentDirectory = directoryURL
        } catch {
            showError("Failed to load directory")
        }
    }
    
    private func deleteFile(at url: URL) async {
        do {
            files = try await FileSystemService.deleteFile(at: url, currentDirectory: currentDirectory)
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

#Preview {
    FileSystemView()
}
