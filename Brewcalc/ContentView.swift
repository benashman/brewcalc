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

struct DefaultValues {
    static let coffee = 21
    static let ratio = 16
    static let water = 336
}

struct ContentView: View {
    @State var coffee: Int = UserDefaults.standard.integer(forKey: Components.coffee)
    @State var ratio: Int = UserDefaults.standard.integer(forKey: Components.ratio)
    @State var water: Int = UserDefaults.standard.integer(forKey: Components.water)
    
    var body: some View {
        
        let coffeeBinding: Binding<Int> = Binding(
            get: { coffee },
            set: {
                coffee = $0
                UserDefaults.standard.set(coffee, forKey: Components.coffee)
                
                water = $0 * ratio
                UserDefaults.standard.set(water, forKey: Components.water)
            }
        )
        
        let ratioBinding: Binding<Int> = Binding(
            get: { ratio },
            set: {
                ratio = $0
                UserDefaults.standard.set(ratio, forKey: Components.ratio)
                
                water = $0 * coffee
                UserDefaults.standard.set(water, forKey: Components.water)
            }
        )
        
        let waterBinding: Binding<Int> = Binding(
            get: { water },
            set: {
                water = $0
                UserDefaults.standard.set(water, forKey: Components.water)
                
                coffee = $0 / ratio
                UserDefaults.standard.set(coffee, forKey: Components.coffee)
            }
        )
        
        return VStack(alignment: .center, spacing: 64) {
            VStack(spacing: 4) {
                ComponentTitle(title: "Coffee")
                Nudger(value: coffeeBinding, range: 1...100) {
                    ComponentLabel(label: "\(self.coffee)g")
                }
            }

            VStack(spacing: 4) {
                ComponentTitle(title: "Ratio")
                Nudger(value: ratioBinding, range: 1...50) {
                    ComponentLabel(label: "1:\(self.ratio)")
                }
            }

            VStack(spacing: 4) {
                ComponentTitle(title: "Water")
                Nudger(value: waterBinding, range: 1...5000) {
                    ComponentLabel(label: "\(self.water)g")
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
