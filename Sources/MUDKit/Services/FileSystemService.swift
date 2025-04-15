import Foundation

public struct FileSystemService {
    enum DirectoryType: String {
        case documents
        case temporary
    }
    
    enum FileSystemServiceError: Error {
        case findDirectoryError
        case loadDirectoryError
        case deleteFileError
    }
    
    private static let fileManagerActor = FileManagerActor()
    
    static func loadDirectory(_ type: DirectoryType) async throws -> (URL, [URL]) {
        do {
            let directoryURL: URL
            
            switch type {
            case .documents:
                directoryURL = try await fileManagerActor.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
            case .temporary:
                directoryURL = await fileManagerActor.temporaryDirectory
            }
            
            do {
                let directoryContents = try await loadSpecificDirectory(directoryURL)
                
                return (directoryURL, directoryContents)
            } catch {
                throw FileSystemServiceError.loadDirectoryError
            }
        } catch {
            throw FileSystemServiceError.findDirectoryError
        }
    }
    
    static func loadSpecificDirectory(_ directoryURL: URL) async throws -> [URL] {
        do {
            let directoryContents = try await fileManagerActor.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey],
                options: [.skipsHiddenFiles]
            )
            
            return directoryContents
        } catch {
            throw FileSystemServiceError.loadDirectoryError
        }
    }
    
    static func deleteFile(at url: URL, currentDirectory: URL?) async throws -> [URL] {
        do {
            try await fileManagerActor.removeItem(at: url)
            
            if let currentDirectory {
                do {
                    let directoryContents = try await loadSpecificDirectory(currentDirectory)
                    
                    return directoryContents
                } catch {
                    throw FileSystemServiceError.loadDirectoryError
                }
            } else {
                throw FileSystemServiceError.deleteFileError
            }
        } catch {
            throw FileSystemServiceError.deleteFileError
        }
    }
    
    static func getIsDirectory(for url: URL) -> Bool {
        return (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
}
