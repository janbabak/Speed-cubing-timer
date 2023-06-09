//
//  SettingsView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack {
            Text("Settings")
            Cube3DView()
                .frame(height: 350)
        }
        .padding()
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
