import Foundation
import Alamofire
import Pulse

/// Configuration for setting up Pulse network logging.
public struct PulseConfiguration {
    private let configuration: URLSessionConfiguration
    private let sessionDelegate: SessionDelegate
    private let delegateQueue: OperationQueue
    
    /// Initializes the Pulse configuration with URL session settings.
        /// - Parameters:
        ///   - configuration: The URL session configuration to use.
        ///   - sessionDelegate: The session delegate for handling session events.
        ///   - delegateQueue: The operation queue for delegate callbacks.
    public init(
        configuration: URLSessionConfiguration,
        sessionDelegate: SessionDelegate,
        delegateQueue: OperationQueue
    ) {
        self.configuration = configuration
        self.sessionDelegate = sessionDelegate
        self.delegateQueue = delegateQueue
    }
    
    /// Creates and returns a configured URL session for Pulse logging.
        /// - Returns: A `URLSession` instance with Pulse logging enabled.
    func setup() -> URLSession {
        return URLSessionProxy(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: delegateQueue
        ).session
    }
}
