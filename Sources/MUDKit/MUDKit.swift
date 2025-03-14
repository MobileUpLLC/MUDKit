import Foundation
import Pulse
import Alamofire

public final class ProxyService {
    public static let shared = ProxyService()
    
    public func getUrlSessionProxy(
        configuration: URLSessionConfiguration,
        sessionDelegate: SessionDelegate,
        delegateQueue: OperationQueue
    ) -> Pulse.URLSessionProxy {
        return Pulse.URLSessionProxy(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: delegateQueue
        )
    }
}
