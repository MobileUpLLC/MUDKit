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
    
    private static let fileManager = FileManager.default
    
    static func loadDirectory(_ type: DirectoryType) throws -> (URL, [URL]) {
        do {
            let directoryURL: URL
            
            switch type {
            case .documents:
                directoryURL = try fileManager.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
            case .temporary:
                directoryURL = fileManager.temporaryDirectory
            }
            
            do {
                let directoryContents = try loadSpecificDirectory(directoryURL)
                
                return (directoryURL, directoryContents)
            } catch {
                throw FileSystemServiceError.loadDirectoryError
            }
        } catch {
            throw FileSystemServiceError.findDirectoryError
        }
    }
    
    static func loadSpecificDirectory(_ directoryURL: URL) throws -> [URL] {
        do {
            let directoryContents = try fileManager.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey],
                options: [.skipsHiddenFiles]
            )
            
            return directoryContents
        } catch {
            throw FileSystemServiceError.loadDirectoryError
        }
    }
    
    static func deleteFile(at url: URL, currentDirectory: URL?) throws -> [URL] {
        do {
            try fileManager.removeItem(at: url)
            
            if let currentDirectory {
                do {
                    let directoryContents = try loadSpecificDirectory(currentDirectory)
                    
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
