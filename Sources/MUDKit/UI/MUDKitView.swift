//
//  MUDKitView.swift
//  MUDKit
//
//  Created by Ян Бойко on 17.03.2025.
//

import SwiftUI

struct MUDKitView: View {
    var body: some View {
        Text("MUDKit")
            .font(.headline)
        NavigationView {
            List {
                NavigationLink("Открыть Pulse") {
                    PulseView()
                }
            }
        }
    }
}

#Preview {
    MUDKitView()
}
