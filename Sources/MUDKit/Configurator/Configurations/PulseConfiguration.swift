import Foundation
import Alamofire
import Pulse

public struct PulseConfiguration {
    private let configuration: URLSessionConfiguration
    private let sessionDelegate: SessionDelegate
    private let delegateQueue: OperationQueue
    
    public init(
        configuration: URLSessionConfiguration,
        sessionDelegate: SessionDelegate,
        delegateQueue: OperationQueue
    ) {
        self.configuration = configuration
        self.sessionDelegate = sessionDelegate
        self.delegateQueue = delegateQueue
    }
    
    func setup() -> URLSession {
        return URLSessionProxy(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: delegateQueue
        ).session
    }
}
