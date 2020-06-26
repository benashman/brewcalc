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
    
    @State var coffeeGestureAmount: Double = UserDefaults.standard.double(forKey: "coffeeAmount")
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Nudger<Content: View>: View {
    @Binding var value: Double
    @State var previousValue: Double = 0
    
    @State var range: ClosedRange<CGFloat>
    
    @State var dragOffset = CGSize.zero
    @State var isDragging = false
    
    let generator = UINotificationFeedbackGenerator()
    
    let content: () -> Content

    var body: some View {
        content()
            .foregroundColor(self.isDragging ? Color.yellow : Color.primary)
            .gesture(
                DragGesture(minimumDistance: 8, coordinateSpace: .global)
                    .onChanged({ gesture in
                        self.isDragging = true
                                                
                        let tx = Double(gesture.translation.width)
                        let minValue = Double(range.lowerBound)
                        let maxValue = Double(range.upperBound)
                        
                        var newValue = round(self.previousValue) + round(tx/20)
                        
                        // Ensure values stay within sensible ranges
                        if newValue > maxValue {
                            newValue = maxValue
                        }

                        if newValue < minValue {
                            newValue = minValue
                        }
                        
                        print("Previous Value: \(round(self.previousValue))")
                        print("Translation dinstance: \(round(tx/20))")
                        
                        self.value = newValue
//
//                        let screenWidth = UIScreen.main.bounds.size.width
//
//                        let minValue = Double(range.lowerBound)
//                        let maxValue = Double(range.upperBound)
//
//                        let modulatedValue = minValue + Double((tx / (screenWidth*2))) * (maxValue - minValue)
//
//                        // tx/20 = approx. 10 units in each direction
//                        if Int(tx).isMultiple(of: 10) {
//                            var newValue = self.value + Double(tx)
//                            print("VALUE CHANGED: \(newValue)")
//                            self.value = newValue
//                        }
                        
                        // Ensure value stays within provided range
//                        if newValue > maxValue {
//                            newValue = maxValue
//                        }
//s
//                        if newValue < minValue {
//                            newValue = minValue
//                        }
                        
                        // Set new value
//                        print(round(newValue))

                        // Animate directionally while nudging
                        withAnimation(.spring()) {
                            if tx > -16 && gesture.translation.width < 16 {
                                self.dragOffset = gesture.translation
                            }
                        }
                    })
                    .onEnded({ _ in
                        self.isDragging = false
                        
                        self.previousValue = self.value
                        
                        // Return to default position
                        withAnimation(.spring()) {
                            self.dragOffset = .zero
                        }
                    })
            )
            .offset(x: self.dragOffset.width, y: 0)
    }
}
