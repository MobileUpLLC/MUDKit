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
        
        var message: String {
            switch self {
            case .findDirectoryError:
                "Failed to find directory"
            case .loadDirectoryError:
                "Failed to load directory"
            case .deleteFileError:
                "Failed to delete file"
            }
        }
    }
    
    private static let fileSystem = FileSystem()
    
    static func loadDirectory(_ type: DirectoryType) async throws -> (directory: URL, files: [URL]) {
        let directoryURL: URL
        
        do {
            switch type {
            case .documents:
                directoryURL = try await fileSystem.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
            case .temporary:
                directoryURL = await fileSystem.temporaryDirectory
            }
        } catch {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.findDirectoryError.message + ": \(type.rawValue)")
            )
            throw FileSystemServiceError.findDirectoryError
        }
        
        do {
            let directoryContents = try await loadSpecificDirectory(directoryURL)
            
            return (directory: directoryURL, files: directoryContents)
        } catch {
            throw error
        }
    }
    
    static func loadSpecificDirectory(_ directoryURL: URL) async throws -> [URL] {
        do {
            let directoryContents = try await fileSystem.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey],
                options: [.skipsHiddenFiles]
            )
            
            return directoryContents
        } catch {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.loadDirectoryError.message + ": \(directoryURL)")
            )
            
            throw FileSystemServiceError.loadDirectoryError
        }
    }
    
    static func deleteFile(at url: URL, currentDirectory: URL?) async throws -> [URL] {
        do {
            try await fileSystem.removeItem(at: url)
        } catch {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.deleteFileError.message + ": \(url)")
            )
            
            throw FileSystemServiceError.deleteFileError
        }
        
        guard let currentDirectory else {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.deleteFileError.message + ": \(url)")
            )
            
            throw FileSystemServiceError.deleteFileError
        }
        
        do {
            return try await loadSpecificDirectory(currentDirectory)
        } catch {
            throw error
        }
    }
    
    static func getIsDirectory(for url: URL) -> Bool {
        return (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
}
