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
        
        return VStack {
            HStack {
                Text("Coffee")
                Nudger(value: coffeeBinding) {
                    Text("\(self.coffee)g")
                }
            }

            HStack {
                Text("Ratio")
                Nudger(value: ratioBinding) {
                    Text("1:\(self.ratio)")
                }
            }

            HStack {
                Text("Water")
                Nudger(value: waterBinding) {
                    Text("\(self.water)g")
                }
            }
        }
    }
}

struct Nudger<Content: View>: View {
    @Binding var value: Int
    @State var previousValue: Int = 0
    
    @State var dragValue = CGSize.zero
    @State var isDragging = false
    
    let content: () -> Content
    
    var body: some View {
        content()
            .gesture(
                DragGesture()
                    .onChanged { v in
                        dragValue.width = v.translation.width
                        self.value = previousValue + Int(v.translation.width/20)
                    }
                    .onEnded { _ in
                        previousValue = self.value
                    }
            )
            .onAppear {
                self.previousValue = self.value
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
