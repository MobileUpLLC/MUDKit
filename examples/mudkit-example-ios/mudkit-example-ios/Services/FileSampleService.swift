import UIKit

final class FileSampleService {
    private enum DirectoryType {
        case documents
        case temporary
    }
    
    static func createSampleFiles() {
        createFiles(in: .documents)
        createFiles(in: .temporary)
    }
    
    private static func createFiles(in directoryType: DirectoryType) {
        guard let directoryUrl = constructDirectoryPath(directoryType) else {
            return
        }
        
        let jsonFileUrl = directoryUrl.appendingPathComponent("JSON-Sample.json")
        let pngFileUrl = directoryUrl.appendingPathComponent("PNG-Sample.png")
        let htmlFileUrl = directoryUrl.appendingPathComponent("HTML-Sample.html")
        
        createSampleJsonFile(at: jsonFileUrl)
        createSamplePngFile(at: pngFileUrl)
        createSampleHtmlFile(at: htmlFileUrl)
    }
    
    private static func createSampleJsonFile(at url: URL) {
        let jsonContent: [String: Any] = ["name": "MUDKit Demo", "version": 1.0]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonContent, options: .prettyPrinted) else {
            return
        }
        
        createFile(fromData: jsonData, atUrl: url)
    }
    
    private static func createSamplePngFile(at url: URL) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
        let image = UIImage(systemName: "star", withConfiguration: imageConfig)
        
        guard let imageData = image?.pngData() else {
            return
        }
        
        createFile(fromData: imageData, atUrl: url)
    }
    
    private static func createSampleHtmlFile(at url: URL) {
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
        
        guard let htmlData = htmlContent.data(using: .utf8) else {
            return
        }
        
        createFile(fromData: htmlData, atUrl: url)
    }
    
    private static func constructDirectoryPath(_ directory: DirectoryType) -> URL? {
        switch directory {
        case .documents:
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        case .temporary:
            return URL(fileURLWithPath: FileManager.default.temporaryDirectory.path, isDirectory: true)
        }
    }
    
    private static func createFile(fromData data: Data, atUrl url: URL) {
        if FileManager.default.fileExists(atPath: url.path) == false {
            try? data.write(to: url)
        }
    }
}
