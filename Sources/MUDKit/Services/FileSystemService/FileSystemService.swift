import Foundation

final class FileSystemService {
    func constructDirectoryPath(_ directory: FileSystemServiceDirectoryType) -> URL? {
        switch directory {
        case .documents:
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        case .temporary:
            return URL(fileURLWithPath: FileManager.default.temporaryDirectory.path, isDirectory: true)
        }
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
    
    func deleteFile(at url: URL) -> Bool {
        guard FileManager.default.fileExists(atPath: url.path) else {
            return true
        }

        return (try? FileManager.default.removeItem(at: url)) != nil
    }
}
