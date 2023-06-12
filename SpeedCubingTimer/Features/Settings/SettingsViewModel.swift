//
//  SettingsViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 12.06.2023.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage(SettingsViewModel.scrambleVisualizationOnKey) var scrambleVisualizationOn = true
    @AppStorage(SettingsViewModel.inspectionOnKey) var inspectionOn = false
    @AppStorage(SettingsViewModel.inspectionLimitKey) var inspectionLimit = 15
    
    static let scrambleVisualizationOnKey = "scrambleVisualization"
    static let inspectionOnKey = "inspectionOn"
    static let inspectionLimitKey = "inspectionLimit"
    
    func resetAllSettings() {
        scrambleVisualizationOn = true
        inspectionOn = false
        inspectionLimit = 15
    }
}
