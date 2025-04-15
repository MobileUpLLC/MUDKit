import Foundation

actor FileManagerActor {
    let fileManager = FileManager.default
    
    func url(
        for directory: FileManager.SearchPathDirectory,
        in domain: FileManager.SearchPathDomainMask,
        appropriateFor url: URL?,
        create: Bool
    ) throws -> URL {
        try fileManager.url(for: directory, in: domain, appropriateFor: url, create: create)
    }
    
    var temporaryDirectory: URL {
        fileManager.temporaryDirectory
    }
    
    func contentsOfDirectory(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options: FileManager.DirectoryEnumerationOptions
    ) throws -> [URL] {
        try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: options)
    }
    
    func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
}
