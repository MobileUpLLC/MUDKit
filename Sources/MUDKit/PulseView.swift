//
//  PulseView.swift
//  MUDKit
//
//  Created by Ян Бойко on 14.03.2025.
//

import SwiftUI
import PulseUI
import Pulse

public struct PulseView: View {
    private let store: LoggerStore
    private let mode: ConsoleMode
    
    public var body: some View {
        ConsoleView()
    }
    
    public init(
        store: LoggerStore = .shared,
        mode: ConsoleMode = .all
    ) {
        self.store = store
        self.mode = mode
    }
}

#Preview {
    PulseView()
}
