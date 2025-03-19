import Foundation

public struct MUDKitConfiguration {
    let pulseSession: URLSession?
    
    public init(pulseSession: URLSession?) {
        self.pulseSession = pulseSession
    }
}
