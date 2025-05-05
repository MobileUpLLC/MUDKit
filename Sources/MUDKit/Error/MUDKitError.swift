/// An error type representing issues that can occur within the MUDKit framework.
public enum MUDKitError: Error {
    case setupFailed
    
    var description: String {
        switch self {
        case .setupFailed:
            return "MUDKit configuration setup failed"
        }
    }
}
