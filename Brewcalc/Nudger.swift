//
//  Nudger.swift
//  Brewcalc
//
//  Created by Benjamin Ashman on 7/6/20.
//  Copyright © 2020 Benjamin Ashman. All rights reserved.
//

import SwiftUI

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
                        isDragging = true
                        
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
                        isDragging = false
                        
                        currentValue = self.value
                        
                        withAnimation(.spring()) {
                            dragValue = .zero
                        }
                    }
            )
            .offset(x: dragValue.width, y: 0)
            .foregroundColor(isDragging ? Color.yellow : Color.primary)
            .onAppear {
                self.currentValue = self.value
            }
    }
}
