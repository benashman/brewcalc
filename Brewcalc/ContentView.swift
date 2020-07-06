//
//  ContentView.swift
//  Brewcalc
//
//  Created by Benjamin Ashman on 5/30/20.
//  Copyright © 2020 Benjamin Ashman. All rights reserved.
//

import SwiftUI
import Foundation

enum Components {
    static let coffee = "coffee"
    static let ratio = "ratio"
    static let water = "water"
}

struct ContentView: View {
    @AppStorage(Components.coffee) var coffee: Int = 21
    @AppStorage(Components.ratio) var ratio: Int = 16
    @AppStorage(Components.water) var water: Int = 336
    
    var body: some View {
        
        let coffeeBinding: Binding<Int> = Binding(
            get: { coffee },
            set: { val in
                coffee = val
                water = val * ratio
            }
        )
        
        let ratioBinding: Binding<Int> = Binding(
            get: { ratio },
            set: { val in
                ratio = val
                water = val * coffee
            }
        )
        
        let waterBinding: Binding<Int> = Binding(
            get: { water },
            set: { val in
                water = val
                coffee = val / ratio
            }
        )
        
        return VStack(alignment: .center, spacing: 64) {
            VStack(spacing: 4) {
                Text("Coffee")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                Nudger(value: coffeeBinding, range: 1...100) {
                    Text("\(self.coffee)g")
                        .font(.system(size: 56, weight: .regular, design: .monospaced))
                }
            }

            VStack(spacing: 4) {
                Text("Ratio")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                Nudger(value: ratioBinding, range: 1...50) {
                    Text("1:\(self.ratio)")
                        .font(.system(size: 56, weight: .regular, design: .monospaced))
                }
            }

            VStack(spacing: 4) {
                Text("Water")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                Nudger(value: waterBinding, range: 1...5000) {
                    Text("\(self.water)g")
                        .font(.system(size: 56, weight: .regular, design: .monospaced))
                }
            }
        }
    }
}

struct Nudger<Content: View>: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    @State var currentValue: Int = 0
    
    @State var dragValue = CGSize.zero
    @State var isDragging = false
    
    let content: () -> Content
    
    var body: some View {
        content()
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged() { v in
                        
                        // Update internal value from state when gesture begins
                        if v.translation.width == 0 {
                            self.currentValue = self.value
                        }
                        
                        var newValue = currentValue + Int(v.translation.width/20)
                        
                        // Ensure values stay within sensible ranges
                        if newValue > range.upperBound {
                            newValue = range.upperBound
                        }
                        
                        if newValue < range.lowerBound {
                            newValue = range.lowerBound
                        }
                        
                        // Update state
                        self.value = newValue
                        
                        withAnimation(.spring()) {
                            if v.translation.width > -12 && v.translation.width < 12 {
                                dragValue = v.translation
                            }
                        }
                    }
                    .onEnded { _ in
                        currentValue = self.value
                        
                        withAnimation(.spring()) {
                            dragValue = .zero
                        }
                    }
            )
            .offset(x: dragValue.width, y: 0)
            .onAppear {
                self.currentValue = self.value
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
