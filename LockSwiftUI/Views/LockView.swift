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
    var forgotPin: () -> () = { }
    
    // State properties
    @State private var pin: String = ""
    @State private var animateField = false
    @State private var isUnlocked = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                ZStack {
                    Rectangle().ignoresSafeArea()
                    
                    if lockType == .both || lockType == .biometric {
                        
                    } else {
                        // Custom number pad to view lock pin
                        numberPadPinView()
                    }
                }
                .transition(.offset(y: size.height + 100))
            }
            
        }
    }
    
    /// Numberpad Pin View.
    @ViewBuilder
    func numberPadPinView() -> some View {
        VStack(spacing: 16) {
            Text("Enter pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
            
            // Add wiggling animation for wrong pin with KeyFrame Animator.
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                        // Showing pin at each box with the help of index
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: { content, value in
                content.offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            .padding(.top, 16)
            .overlay(alignment: .bottomTrailing) {
                Button("Forgot pin?", action: forgotPin)
                    .foregroundStyle(.white)
                    .offset(y: 40)
            }
            .frame(maxHeight: .infinity)
            
            // Custom number pad
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        }) {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                    }
                    
                    // 0 and back button
                    Button(action: { }) {
                        Text("")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    }
                    .tint(.white)
                    .disabled(true)
                    
                    Button(action: {
                        if pin.count < 4 {
                            pin.append("0")
                        }
                    }) {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    }
                    .tint(.white)
                    
                    Button(action: { 
                        if !pin.isEmpty { pin.removeLast() }
                    }) {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    }
                    .tint(.white)
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    // Validate pin
                    if lockPin == pin {
                        print("Unlocked")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            // clearing pin
                            pin = ""
                        }
                    } else {
                        print("Wrong pin")
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
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
