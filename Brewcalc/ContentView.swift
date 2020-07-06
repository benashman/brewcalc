//
//  ContentView.swift
//  Brewcalc
//
//  Created by Benjamin Ashman on 5/30/20.
//  Copyright © 2020 Benjamin Ashman. All rights reserved.
//

import SwiftUI
import Foundation

struct DefaultValues {
    static let coffee = 21
    static let ratio = 16
    static let water = 336
}

enum Components {
    static let coffee = "coffee"
    static let ratio = "ratio"
    static let water = "water"
}

struct ContentView: View {
    @State var coffee: Int = UserDefaults.standard.integer(forKey: Components.coffee)
    @State var ratio: Int = UserDefaults.standard.integer(forKey: Components.ratio)
    @State var water: Int = UserDefaults.standard.integer(forKey: Components.water)
    
    var body: some View {
        
        let coffeeBinding: Binding<Int> = Binding(
            get: { UserDefaults.standard.integer(forKey: Components.coffee) },
            set: { val in
                coffee = val
                UserDefaults.standard.set(coffee, forKey: Components.coffee)
                
                water = val * ratio
                UserDefaults.standard.set(water, forKey: Components.water)
            }
        )
        
        let ratioBinding: Binding<Int> = Binding(
            get: { UserDefaults.standard.integer(forKey: Components.ratio) },
            set: { val in
                ratio = val
                UserDefaults.standard.set(ratio, forKey: Components.ratio)
                
                water = val * coffee
                UserDefaults.standard.set(water, forKey: Components.water)
            }
        )
        
        let waterBinding: Binding<Int> = Binding(
            get: { UserDefaults.standard.integer(forKey: Components.water) },
            set: { val in
                water = val
                UserDefaults.standard.set(water, forKey: Components.water)
                
                coffee = val / ratio
                UserDefaults.standard.set(coffee, forKey: Components.coffee)
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
        .onAppear {
            setDefaultValues()
        }
    }
    
    func setDefaultValues() {
        if coffee == 0 {
            coffee = DefaultValues.coffee
            UserDefaults.standard.set(coffee, forKey: Components.coffee)
        }
        
        if ratio == 0 {
            ratio = DefaultValues.ratio
            UserDefaults.standard.set(ratio, forKey: Components.ratio)
        }
        
        if water == 0 {
            water = DefaultValues.water
            UserDefaults.standard.set(water, forKey: Components.water)
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
