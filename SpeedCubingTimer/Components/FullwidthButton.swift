//
//  FullwidthButton.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 05.04.2023.
//

import SwiftUI

struct FullwidthButton: View {
    var label: String = ""
    var tint: Color = .blue
    var buttonStyle: BorderedButtonStyle = .bordered
    var controlSize: ControlSize = .large
    var font: Font = .title2
    var fullHeight = false
    var borderedProminent = true
    var action: () -> Void = {}
    
    var body: some View {
        if borderedProminent {
            button.buttonStyle(.borderedProminent)
        } else {
            button.buttonStyle(.bordered)
        }
    }
    
    var button: some View {
        Button {
            action()
        } label: {
            Text(label)
                .font(font)
                .frame(maxWidth: .infinity, maxHeight: (fullHeight ? .infinity : nil))
        }
        .tint(tint)
        .controlSize(controlSize)
    }
}

struct FullwidthButton_Previews: PreviewProvider {
    static var previews: some View {
        FullwidthButton(label: "Button")
    }
}
