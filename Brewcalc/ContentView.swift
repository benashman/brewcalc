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
        
        return VStack {
            Text("Coffee amount")
            Text(" \(Int(coffeeAmount))g")
            Slider(value: coffeeBinding, in: 1...100, step: 1)
            
            Text("Water ratio")
            Text(" 1:\(Int(waterRatio))")
            Slider(value: ratioBinding, in: 1...30, step: 1)
            
            Text("Water amount")
            Text(" \(Int(waterAmount))g")
            Slider(value: waterBinding, in: 1...1000, step: 1)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
