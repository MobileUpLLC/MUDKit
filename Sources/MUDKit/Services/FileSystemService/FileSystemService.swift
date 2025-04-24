import UIKit

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
    
    func createSampleFiles() {
        createFiles(in: .documents)
        createFiles(in: .temporary)
    }
    
    private func createFiles(in directoryType: FileSystemServiceDirectoryType) {
        let directoryUrl = constructDirectoryPath(directoryType)
        let jsonFileUrl = directoryUrl.appendingPathComponent("JSON-Sample.json")
        let pngFileUrl = directoryUrl.appendingPathComponent("PNG-Sample.png")
        let htmlFileUrl = directoryUrl.appendingPathComponent("HTML-Sample.html")
        
        createSampleJsonFile(at: jsonFileUrl)
        createSamplePngFile(at: pngFileUrl)
        createSampleHtmlFile(at: htmlFileUrl)
    }
    
    private func createSampleJsonFile(at url: URL) {
        let jsonContent: [String: Any] = ["name": "MUDKit Demo", "version": 1.0]
        if
            fileManager.fileExists(atPath: url.path) == false,
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonContent, options: .prettyPrinted)
        {
            try? jsonData.write(to: url)
        }
    }
    
    private func createSamplePngFile(at url: URL) {
        if fileManager.fileExists(atPath: url.path) == false {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
            let image = UIImage(systemName: "star", withConfiguration: imageConfig)
            
            if let imageData = image?.pngData() {
                try? imageData.write(to: url)
            }
        }
    }
    
    private func createSampleHtmlFile(at url: URL) {
        let htmlContent = """
    <!DOCTYPE html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MUDKit Demo</title>
    </head>
    <body>
        <h1>Welcome to MUDKit Demo</h1>
        <p>This is a sample HTML file created for testing MUDKit's file system features.</p>
    </body>
    </html>
    """
        if fileManager.fileExists(atPath: url.path) == false {
            try? htmlContent.write(to: url, atomically: true, encoding: .utf8)
        }
    }
}
