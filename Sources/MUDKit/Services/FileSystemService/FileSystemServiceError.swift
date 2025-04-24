enum FileSystemServiceError: Error {
    case findDirectoryError
    case loadDirectoryError
    case existFileError
    case deleteFileError
    
    var message: String {
        switch self {
        case .findDirectoryError:
            return "Failed to find directory"
        case .loadDirectoryError:
            return "Failed to load directory"
        case .existFileError:
            return "File doesn't exist"
        case .deleteFileError:
            return "Failed to delete file"
        }
    }
}
