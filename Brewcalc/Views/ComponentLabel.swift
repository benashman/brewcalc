//
//  ComponentLabel.swift
//  Brewcalc
//
//  Created by Benjamin Ashman on 7/6/20.
//  Copyright © 2020 Benjamin Ashman. All rights reserved.
//

import SwiftUI

struct ComponentLabel: View {
    let label: String
    
    var body: some View {
        Text(label)
            .font(.system(size: 56, weight: .regular, design: .monospaced))
    }
}

struct ComponentLabel_Previews: PreviewProvider {
    static var previews: some View {
        ComponentLabel(label: "21g")
    }
}
