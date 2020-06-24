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
                
                let rangeMin = 0.0
                let rangeMax = 100.0
                let startValue = self.coffeeAmount
                
                
                withAnimation(.spring()) {
                    if gesture.translation.width > -16 && gesture.translation.width < 16 {
                        self.offset = gesture.translation
                    }
                }
                
//                print(Int(gesture.translation.width))
                // https://gist.github.com/assassinave/23e939608622e8b288a29ace37be3091
                var modulatedValue = 0 + ((gesture.translation.width - 0) / (375 - 0)) * (100 - 0)
                
                var newValue = Double(startValue + (Double(modulatedValue) / 300))
                
                if newValue > rangeMax {
                    newValue = rangeMax
                }
                
                if newValue < rangeMin {
                    newValue = rangeMin
                }
                
                self.coffeeAmount = newValue
                self.waterAmount = newValue * self.waterRatio
                
                print(newValue)
                
//                var translationValue = modulatedValue
//                print(coffeeAmount + Double(modulatedValue))
//                print(0 + ((gesture.translation.width - 0) / (375 - 0)) * (100 - 0))
            }
            
            .onEnded { _ in
                self.isDragging = false
                
                withAnimation(.spring()) {
                    self.offset = .zero
                }
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
            
            Nudger(value: coffeeBinding, range: 1...100, text: "\(Int(coffeeAmount))g")
            Nudger(value: ratioBinding, range: 1...30, text: "\(Int(waterRatio))g")
            Nudger(value: waterBinding, range: 1...1000, text: "\(Int(waterAmount))g")
            
            VStack(spacing: 0) {
                Text("Coffee")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .foregroundColor(self.isDragging ? Color.yellow : Color.primary)

                Text("\(Int(coffeeAmount))g")
                    .font(.system(size: 56, weight: .regular, design: .monospaced))
                    .foregroundColor(self.isDragging ? Color.yellow : Color.primary)
                    .offset(x: offset.width, y: 0)
                    .gesture(drag)
                
    //            Slider(value: coffeeBinding, in: 1...100, step: 1)
            }
            
            VStack(spacing: 0) {
                Text("Ratio")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
    //                .foregroundColor(self.isDragging ? Color.yellow : Color.primary)
                
                Text("1:\(Int(waterRatio))")
                    .font(.system(size: 56, weight: .regular, design: .monospaced))
    //                .foregroundColor(self.isDragging ? Color.yellow : Color.primary)
                
    //            Slider(value: ratioBinding, in: 1...30, step: 1)
            }
            
            VStack(spacing: 0) {
                Text("Water")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
    //                .foregroundColor(self.isDragging ? Color.yellow : Color.primary)
                
                Text("\(Int(waterAmount))g")
                    .font(.system(size: 56, weight: .regular, design: .monospaced))
    //                .foregroundColor(self.isDragging ? Color.yellow : Color.primary)
                
    //            Slider(value: waterBinding, in: 1...1000, step: 1)
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Nudger: View {
    @Binding var value: Double
    
    @State var isDragging = false
    @State var range: ClosedRange<CGFloat>
    @State var text: String
    
    var body: some View {
        Text("\(self.value)")
            .gesture(
                DragGesture()
                    .onChanged({ gesture in
                        
                        self.isDragging = true
                        
                        var startValue = self.value
                        var tx = gesture.translation.width
                        let screenWidth = UIScreen.main.bounds.size.width
                        
                        let minValue = Double(range.lowerBound)
                        let maxValue = Double(range.upperBound)
                        
                        var modulatedValue = minValue + Double((tx / screenWidth)) * (maxValue - minValue)
                        
                        var newValue = Double(startValue + modulatedValue)
                        
                        // Ensure value stays within range
                        if newValue > maxValue {
                            newValue = maxValue
                        }
                        
                        if newValue < minValue {
                            newValue = minValue
                        }
                        
                        self.value = newValue
                    })
            )
    }
}
