//
//  LockView.swift
//  LockSwiftUI
//
//  Created by Mohsin Ali Ayub on 20.10.23.
//

import SwiftUI

struct LockView<Content: View>: View {
    // Lock properties
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    @ViewBuilder var content: Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled {
                ZStack {
                    if lockType == .both || lockType == .biometric {
                        Rectangle()
                    } else {
                        // Custom number pad to view lock pin
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
    
    enum LockType: String {
        case biometric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First preference will be biometric, and if it's not available, it will go for number lock."
    }
}

#Preview {
    ContentView()
}
