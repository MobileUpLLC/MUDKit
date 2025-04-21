/// An error type representing issues that can occur within the MUDKit framework.
public enum MUDKitError: Error {
    /// Indicates that the MUDKit configuration setup process failed.
    case setupFailed
    
    /// A convinient description of the error.
    var description: String {
        switch self {
        case .setupFailed:
            return "MUDKit configuration setup failed"
        }
    }
}
