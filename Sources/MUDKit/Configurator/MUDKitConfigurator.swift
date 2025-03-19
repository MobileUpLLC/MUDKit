//
//  MUDKitConfigurator.swift
//  MUDKit
//
//  Created by Ян Бойко on 19.03.2025.
//

import Foundation
import Alamofire
import Pulse

public struct MUDKitConfigurator {
    public static func setup(
        pulseConfiguration: PulseConfiguration?
    ) {
        pulseConfiguration?.setup()
    }
}

public struct PulseConfiguration {
    public let configuration: URLSessionConfiguration
    public let sessionDelegate: SessionDelegate
    public let delegateQueue: OperationQueue
    public let onFinish: (URLSessionProxy) -> Void
    
    func setup() {
        let proxy = URLSessionProxy(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: delegateQueue
        )
        
        onFinish(proxy)
    }
}
