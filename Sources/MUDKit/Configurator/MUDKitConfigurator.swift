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
    private let configuration: URLSessionConfiguration
    private let sessionDelegate: SessionDelegate
    private let delegateQueue: OperationQueue
    private let onFinish: (URLSessionProxy) -> Void
    
    public init(
        configuration: URLSessionConfiguration,
        sessionDelegate: SessionDelegate,
        delegateQueue: OperationQueue,
        onFinish: @escaping (URLSessionProxy) -> Void
    ) {
        self.configuration = configuration
        self.sessionDelegate = sessionDelegate
        self.delegateQueue = delegateQueue
        self.onFinish = onFinish
    }
    
    func setup() {
        let proxy = URLSessionProxy(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: delegateQueue
        )
        
        onFinish(proxy)
    }
}
