import Foundation

/// A thread-safe actor for managing file system operations.
actor FileSystem {
    private let fileManager = FileManager.default
    
    /// The URL of the temporary directory.
    var temporaryDirectory: URL {
        fileManager.temporaryDirectory
    }
    
    /// Retrieves a URL for a specified directory.
        /// - Parameters:
        ///   - directory: The directory to locate (e.g., `.documentDirectory`).
        ///   - domain: The domain in which to search (e.g., `.userDomainMask`).
        ///   - url: A URL for which the directory is appropriate, if applicable. Optional.
        ///   - create: Whether to create the directory if it does not exist.
        /// - Returns: The URL of the specified directory.
        /// - Throws: An error if the directory cannot be located or created.
    func url(
        for directory: FileManager.SearchPathDirectory,
        in domain: FileManager.SearchPathDomainMask,
        appropriateFor url: URL?,
        create: Bool
    ) throws -> URL {
        try fileManager.url(for: directory, in: domain, appropriateFor: url, create: create)
    }    
    
    /// Retrieves the contents of a directory.
        /// - Parameters:
        ///   - url: The URL of the directory to enumerate.
        ///   - includingPropertiesForKeys: Resource properties to include (e.g., `.isDirectoryKey`). Optional.
        ///   - options: Enumeration options (e.g., `.skipsHiddenFiles`).
        /// - Returns: An array of URLs representing the directory's contents.
        /// - Throws: An error if the directory cannot be enumerated.
    func contentsOfDirectory(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options: FileManager.DirectoryEnumerationOptions
    ) throws -> [URL] {
        try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: options)
    }
    
    /// Removes an item at the specified URL.
        /// - Parameter url: The URL of the item to remove.
        /// - Throws: An error if the item cannot be removed.
    func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
}
