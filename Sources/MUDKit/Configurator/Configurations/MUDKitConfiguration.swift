import Foundation

public struct MUDKitConfiguration {
    public let pulseSession: URLSession?
    
    public init(pulseSession: URLSession?) {
        self.pulseSession = pulseSession
    }
}
