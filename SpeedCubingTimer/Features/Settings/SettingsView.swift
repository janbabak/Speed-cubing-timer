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
            settingsSection
            
            aboutSection
        }
    }
    
    private var settingsSection: some View {
        Section(header: Text("Settings")) {
            scrambleVisualizationToggle
            
            inspectionToggle

            inspectionLimit

            resetBtn
        }
    }
    
    private var scrambleVisualizationToggle: some View {
        Toggle(isOn: viewModel.$scrambleVisualizationOn) {
            Label("Scramble visualization", systemImage: "cube.fill")
        }
    }
    
    private var inspectionToggle: some View {
        Toggle(isOn: viewModel.$inspectionOn) {
            Label("Inspection on", systemImage: "eye")
        }
    }
    
    private var inspectionLimit: some View {
        VStack(alignment: .leading) {
            Label("Inspection limit \(viewModel.inspectionLimit)", systemImage: "clock")
            Slider(
                value: Binding(
                    get: {
                        return Double(viewModel.inspectionLimit)
                    },
                    set: { value in
                        viewModel.inspectionLimit = Int(value)
                    }),
                in: 1...60, step: 1
            )
        }
    }
    
    private var resetBtn: some View {
        Button {
            viewModel.resetAllSettings()
        } label: {
            Label("Reset all settings", systemImage: "arrow.counterclockwise")
        }
    }
    
    private var aboutSection: some View {
        Section(header: Text("About")) {
            Label("[Source code](https://github.com/janbabak/Speed-cubing-timer)", systemImage: "link")
            Label("[Follow me on GitHub](https://github.com/janbabak)", systemImage: "person")
            Label("[Message me on LinkedIn](https://www.linkedin.com/in/janbabak/)", systemImage: "paperplane")
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
