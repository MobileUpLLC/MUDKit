import Foundation

/// Utility for managing file system operations.
public struct FileSystemService {
    /// Enum representing directory types.
    enum DirectoryType: String {
        /// The documents directory.
        case documents
        /// The temporary directory.
        case temporary
    }
    
    /// Enum representing file system errors.
    enum FileSystemServiceError: Error {
        /// Error while finding a directory.
        case findDirectoryError
        /// Error while loading a directory's contents.
        case loadDirectoryError
        /// Error while deleting a file.
        case deleteFileError
        
        /// Message describing an error.
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
    
    /// Loads the contents of a specified directory.
        /// - Parameter type: The type of directory to load (`.documents` or `.temporary`).
        /// - Returns: A tuple containing the directory URL and an array of file URLs.
        /// - Throws: `FileSystemServiceError` if the directory cannot be found or loaded.
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
    
    /// Loads the contents of a specific directory.
        /// - Parameter directoryURL: The URL of the directory to load.
        /// - Returns: An array of file URLs in the directory.
        /// - Throws: `FileSystemServiceError.loadDirectoryError` if the directory cannot be loaded.
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
    
    /// Deletes a file and returns the updated directory contents.
        /// - Parameters:
        ///   - url: The URL of the file to delete.
        ///   - currentDirectory: The URL of the current directory, if available.
        /// - Returns: An array of file URLs in the directory after deletion.
        /// - Throws: `FileSystemServiceError` if the file cannot be deleted or the directory cannot be reloaded.
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
    
    /// Checks if a URL represents a directory.
        /// - Parameter url: The URL to check.
        /// - Returns: `true` if the URL is a directory, `false` otherwise.
    static func getIsDirectory(for url: URL) -> Bool {
        return (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
}
