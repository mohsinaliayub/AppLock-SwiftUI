//
//  ContentView.swift
//  LockSwiftUI
//
//  Created by Mohsin Ali Ayub on 20.10.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LockView(lockType: .number, lockPin: "0320", isEnabled: true) {
            VStack(spacing: 16) {
                Image(systemName: "globe")
                    .imageScale(.large)
                
                Text("Hello World!")
            }
        }
    }
}

#Preview {
    ContentView()
}
