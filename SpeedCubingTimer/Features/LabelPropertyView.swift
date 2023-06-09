//
//  LabelPropertyView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 09.06.2023.
//

import SwiftUI

struct LabelPropertyView: View {
    
    var label: String
    var property: String
    
    var body: some View {
        HStack() {
            Text(LocalizedStringKey(label))
                .foregroundColor(Color.theme.secondaryText)
            
            Text(property)
                .fontWeight(.semibold)
        }
    }
}
