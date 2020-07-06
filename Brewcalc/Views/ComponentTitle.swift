//
//  ComponentTitle.swift
//  Brewcalc
//
//  Created by Benjamin Ashman on 7/6/20.
//  Copyright © 2020 Benjamin Ashman. All rights reserved.
//

import SwiftUI

struct ComponentTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .regular, design: .monospaced))
    }
}

struct ComponentTitle_Previews: PreviewProvider {
    static var previews: some View {
        ComponentTitle(title: "Coffee")
    }
}
