public enum MUDKitError: Error {
    case setupFailed
    
    var description: String {
        switch self {
        case .setupFailed:
            return "MUDKit configuration setup failed"
        }
    }
}
