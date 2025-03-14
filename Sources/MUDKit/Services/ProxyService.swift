import Foundation
import Pulse
import Alamofire

public struct ProxyService {
    public static func getUrlSessionProxy(
        configuration: URLSessionConfiguration,
        sessionDelegate: SessionDelegate,
        delegateQueue: OperationQueue
    ) -> URLSessionProxy {
        return URLSessionProxy(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: delegateQueue
        )
    }
}
