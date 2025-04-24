import Foundation

final class FileSystemService {
    private let fileManager = FileManager.default
    
    func loadDirectory(
        _ type: FileSystemServiceDirectoryType
    ) throws -> (
        type: FileSystemServiceDirectoryType,
        directoryUrl: URL,
        files: [URL]
    ) {
        let directoryUrl = constructDirectoryPath(type)
        
        do {
            let directoryType = getDirectoryType(directoryUrl)
            
            let directoryContents = try fileManager.contentsOfDirectory(
                at: directoryUrl,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey],
                options: [.skipsHiddenFiles]
            )
            
            return (type: directoryType, directoryUrl: directoryUrl, files: directoryContents)
        } catch {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.loadDirectoryError.message + ": \(directoryUrl)")
            )
            
            throw FileSystemServiceError.loadDirectoryError
        }
    }
    
    func deleteFile(at url: URL) -> Bool {
        guard fileManager.fileExists(atPath: url.path) else {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.existFileError.message + ": \(url)")
            )
            
            return false
        }
        
        do {
            try fileManager.removeItem(at: url)
            
            return true
        } catch {
            Log.fileSystemService.error(
                logEntry: .text(FileSystemServiceError.deleteFileError.message + ": \(url)")
            )
            
            return false
        }
    }
    
    private func constructDirectoryPath(_ directory: FileSystemServiceDirectoryType) -> URL {
        switch directory {
        case .documents:
            guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return constructDirectoryPath(.temporary)
            }
            
            return url
        case .temporary:
            return URL(fileURLWithPath: fileManager.temporaryDirectory.path, isDirectory: true)
        case .specific(url: let url):
            return url
        }
    }
    
    // Для подмены типа директории в случае .specific
    private func getDirectoryType(_ url: URL) -> FileSystemServiceDirectoryType {
        if url == constructDirectoryPath(.documents) {
            return .documents
        } else if url == constructDirectoryPath(.temporary) {
            return .temporary
        } else {
            return .specific(url: url)
        }
    }
}
