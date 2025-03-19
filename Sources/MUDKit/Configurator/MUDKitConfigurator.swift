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
    let configuration: URLSessionConfiguration
    let sessionDelegate: SessionDelegate
    let delegateQueue: OperationQueue
    let onFinish: (URLSessionProxy) -> Void
    
    func setup() {
        let proxy = URLSessionProxy(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: delegateQueue
        )
        
        onFinish(proxy)
    }
}
