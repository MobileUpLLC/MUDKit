import Foundation

enum FileSystemServiceDirectoryType {
    case documents
    case temporary
    case specific(url: URL)
    
    var name: String {
        switch self {
        case .documents:
            return "Documents"
        case .temporary:
            return "Temporary"
        case .specific(let url):
            return url.absoluteString
        }
    }
}
