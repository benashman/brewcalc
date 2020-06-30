//
//  ContentView.swift
//  Brewcalc
//
//  Created by Benjamin Ashman on 5/30/20.
//  Copyright © 2020 Benjamin Ashman. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {

    @State var coffeeAmount: Double = UserDefaults.standard.double(forKey: "coffeeAmount")
    @State var waterAmount: Double = UserDefaults.standard.double(forKey: "waterAmount")
    @State var waterRatio: Double = UserDefaults.standard.double(forKey: "waterRatio")
    
    @State var isDragging = false
    @State var offset = CGSize.zero
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                self.isDragging = true
                print("WE ARE DRAGGING")
            }
            
            .onEnded { _ in
                self.isDragging = false
            }
    }
    
    var body: some View {
        
        let ratioBinding = Binding(
            get: { UserDefaults.standard.double(forKey: "waterRatio") },
            set: {
                self.waterRatio = $0
                UserDefaults.standard.set(self.waterRatio, forKey: "waterRatio")
                
                self.waterAmount = $0 * self.coffeeAmount
                UserDefaults.standard.set(self.waterAmount, forKey: "waterAmount")
            }
        )
        
        let coffeeBinding = Binding(
            get: { UserDefaults.standard.double(forKey: "coffeeAmount") },
            set: {
                self.coffeeAmount = $0
                UserDefaults.standard.set(self.coffeeAmount, forKey: "coffeeAmount")
                
                self.waterAmount = $0 * self.waterRatio
                UserDefaults.standard.set(self.waterAmount, forKey: "waterAmount")
            }
        )
        
        let waterBinding = Binding(
            get: { UserDefaults.standard.double(forKey: "waterAmount") },
            set: {
                self.waterAmount = $0
                UserDefaults.standard.set(self.waterAmount, forKey: "waterAmount")
                
                self.coffeeAmount = $0 / self.waterRatio
                UserDefaults.standard.set(self.coffeeAmount, forKey: "coffeeAmount")
            }
        )
        
        return VStack( alignment: .center, spacing: 64) {
            
            // Coffee amount
            VStack(spacing: 4) {
                Text("Coffee")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                
                Nudger(value: coffeeBinding, range: 1...100) {
                    Text("\(Int(coffeeAmount))g")
                        .font(.system(size: 56, weight: .regular, design: .monospaced))
                }
            }
            
            // Coffee:Water Ratio
            VStack(spacing: 4) {
                Text("Coffee:Water")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                
                Nudger(value: ratioBinding, range: 1...30) {
                    Text("1:\(Int(waterRatio))")
                        .font(.system(size: 56, weight: .regular, design: .monospaced))
                }
            }
            
            // Water amount
            VStack(spacing: 4) {
                Text("Water")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                
                Nudger(value: waterBinding, range: 1...1000) {
                    Text("\(Int(waterAmount))g")
                        .font(.system(size: 56, weight: .regular, design: .monospaced))
                }
            }
        }.padding()
    }
}

struct Nudger<Content: View>: View {
    @Binding var value: Double
    @State var range: ClosedRange<CGFloat>
    
    @State var isDragging = false
    @GestureState var dragAmount = CGSize.zero
    
    let content: () -> Content

    var body: some View {
        Group {
            Text("\(Int(self.value + Double((dragAmount.width))))")
            content()
                .foregroundColor(self.isDragging ? Color.yellow : Color.primary)
                .offset(dragAmount)
                .gesture(
                    DragGesture()
                        .updating($dragAmount) { v, state, transaction in
                            withAnimation(.spring()) {
                                state.width = v.translation.width/20
                            }
                        }
                        .onChanged({ (v) in
                            self.value += round(Double(dragAmount.width/20))
                        })
                )
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
