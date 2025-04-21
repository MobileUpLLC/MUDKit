import Foundation

final class FileSystemService {
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
    
    private let fileManager = FileManager.default
    
    func loadDirectory(_ type: DirectoryType) throws -> (directory: URL, files: [URL]) {
        let directoryURL: URL
        
        do {
            switch type {
            case .documents:
                directoryURL = try await url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
            case .temporary:
                directoryURL = fileManager.temporaryDirectory
            }
        } catch {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.findDirectoryError.message + ": \(type.rawValue)")
            )
            throw FileSystemServiceError.findDirectoryError
        }
        
        do {
            let directoryContents = try loadSpecificDirectory(directoryURL)
            
            return (directory: directoryURL, files: directoryContents)
        } catch {
            throw error
        }
    }
    
    func loadSpecificDirectory(_ directoryURL: URL) throws -> [URL] {
        do {
            let directoryContents = try contentsOfDirectory(
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
    
    func deleteFile(at url: URL, currentDirectory: URL?) throws -> [URL] {
        do {
            try removeItem(at: url)
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
            return try loadSpecificDirectory(currentDirectory)
        } catch {
            throw error
        }
    }
    
    func getIsDirectory(for url: URL) -> Bool {
        return (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
    
    private func url(
        for directory: FileManager.SearchPathDirectory,
        in domain: FileManager.SearchPathDomainMask,
        appropriateFor url: URL?,
        create: Bool
    ) throws -> URL {
        try fileManager.url(for: directory, in: domain, appropriateFor: url, create: create)
    }
    
    private func contentsOfDirectory(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options: FileManager.DirectoryEnumerationOptions
    ) throws -> [URL] {
        try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: options)
    }
    
    private func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
}
