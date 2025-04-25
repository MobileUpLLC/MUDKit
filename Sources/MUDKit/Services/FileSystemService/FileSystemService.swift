import Foundation

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
}
