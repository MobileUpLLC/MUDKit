import UIKit

final class FileSampleService {
    static func createSampleFiles() {
        createFiles(in: .documents)
        createFiles(in: .temporary)
    }
    
    private static func createFiles(in directoryType: FileSystemServiceDirectoryType) {
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
        if
            FileManager.default.fileExists(atPath: url.path) == false,
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonContent, options: .prettyPrinted)
        {
            try? jsonData.write(to: url)
        }
    }
    
    private static func createSamplePngFile(at url: URL) {
        if FileManager.default.fileExists(atPath: url.path) == false {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
            let image = UIImage(systemName: "star", withConfiguration: imageConfig)
            
            if let imageData = image?.pngData() {
                try? imageData.write(to: url)
            }
        }
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
        if FileManager.default.fileExists(atPath: url.path) == false {
            try? htmlContent.write(to: url, atomically: true, encoding: .utf8)
        }
    }
    
    private static func constructDirectoryPath(_ directory: FileSystemServiceDirectoryType) -> URL? {
        switch directory {
        case .documents:
            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }

            return url
        case .temporary:
            return URL(fileURLWithPath: FileManager.default.temporaryDirectory.path, isDirectory: true)
        }
    }
}
