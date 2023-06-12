//
//  SettingsViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 12.06.2023.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage(SettingsViewModel.scrambleVisualizationOnKey) var scrambleVisualizationOn = true
    
    static let scrambleVisualizationOnKey = "scrambleVisualization"
    
    func resetAllSettings() {
        scrambleVisualizationOn = true
    }
}
