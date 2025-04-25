import UIKit

final class FileSystemService {
    func constructPath(
        directory: FileSystemServiceDirectoryType,
        fileName: String?,
        fileExtension: String?
    ) -> URL? {
        guard var url = constructDirectoryPath(directory) else {
            return nil
        }

        if let fileName {
            url = url.appendingPathComponent(fileName)
        } else if let fileExtension {
            url = url.appendingPathExtension(fileExtension)
        }

        return url
    }
    
    func getContentOfUrl(_ url: URL) -> [URL]? {
        var isDirectory: ObjCBool = false

        guard
            FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
            isDirectory.boolValue
        else {
            return nil
        }

        return try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [])
    }


    private func constructDirectoryPath(_ directory: FileSystemServiceDirectoryType) -> URL? {
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
    
    func deleteFile(at url: URL) -> Bool {
        guard FileManager.default.fileExists(atPath: url.path) else {
            return true
        }

        return (try? FileManager.default.removeItem(at: url)) != nil
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
