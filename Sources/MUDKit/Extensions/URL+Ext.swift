import UniformTypeIdentifiers

extension URL {
    var fileSize: String {
        let values = try? resourceValues(forKeys: [.fileSizeKey])
        
        if let size = values?.fileSize {
            return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
        } else {
            return "N/A"
        }
    }
    
    var creationDate: String {
        let values = try? resourceValues(forKeys: [.creationDateKey])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        if let date = values?.creationDate {
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }
    
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }
    
    var isImage: Bool {
        return contentType?.conforms(to: .image) ?? false
    }
    
    var isVideo: Bool {
        guard let type = contentType else {
            return false
        }
        
        return type.conforms(to: .movie) || type.conforms(to: .video)
    }
    
    var isWebPage: Bool {
        guard let type = contentType else {
            return false
        }
        
        return type.conforms(to: .html) || type.conforms(to: .json) || type.conforms(to: .xml)
    }
    
    var isAudio: Bool {
        return contentType?.conforms(to: .audio) ?? false
    }
    
    private var contentType: UTType? {
        return try? resourceValues(forKeys: [.contentTypeKey]).contentType
    }
}
