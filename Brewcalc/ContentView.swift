//
//  ContentView.swift
//  Brewcalc
//
//  Created by Benjamin Ashman on 5/30/20.
//  Copyright © 2020 Benjamin Ashman. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var coffeeAmount: Double = 25
    @State var waterAmount: Double = 25
    @State var waterRatio: Double = 16
    
    var body: some View {
        
        let ratioBinding = Binding(
            get: {
                self.waterRatio
            },
            set: {
                self.waterRatio = $0
                self.waterAmount = $0 * self.coffeeAmount
            }
        )
        
        let coffeeBinding = Binding(
            get: {
                self.coffeeAmount
            },
            set: {
                self.coffeeAmount = $0
                self.waterAmount = $0 * self.waterRatio
            }
        )
        
        let waterBinding = Binding(
            get: {
                self.waterAmount
                
            },
            set: {
                self.waterAmount = $0
                self.coffeeAmount = $0 / self.waterRatio
            }
        )
        
        return VStack {
            Text("Coffee: \(coffeeAmount)")
            Slider(value: coffeeBinding, in: 0...100, step: 1)
            
            Text("Water ratio: \(waterRatio)")
            Slider(value: ratioBinding, in: 0...30, step: 1)
            
            Text("Water: \(waterAmount)")
            Slider(value: waterBinding, in: 0...1000, step: 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
