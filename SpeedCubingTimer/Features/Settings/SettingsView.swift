//
//  SettingsView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        Form {
            // scramble visualization
            Toggle(isOn: viewModel.$scrambleVisualizationOn) {
                Label("Scramble visualization", systemImage: "cube.fill")
            }
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
