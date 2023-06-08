//
//  FullwidthButton.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 05.04.2023.
//

import SwiftUI

struct FullwidthButton: View {
    var label: String = ""
    var tint: Color = .gray
    var buttonStyle: BorderedButtonStyle = .bordered
    var controlSize: ControlSize = .large
    var font: Font = .title2
    var fullHeight = false
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .font(font)
                .frame(maxWidth: .infinity, maxHeight: (fullHeight ? .infinity : nil))
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .controlSize(controlSize)
    }
}

struct FullwidthButton_Previews: PreviewProvider {
    static var previews: some View {
        FullwidthButton()
    }
}
