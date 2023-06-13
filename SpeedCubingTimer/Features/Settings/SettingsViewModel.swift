//
//  SettingsViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 12.06.2023.
//

import SwiftUI

protocol SettingsViewModeling: ObservableObject {
    var scrambleVisualizationOn: Bool { get set }
    var inspectionOn: Bool { get set }
    var inspectionLimit: Int { get set }
    
    static var scrambleVisualizationOnKey: String { get }
    static var inspectionOnKey: String { get }
    static var inspectionLimitKey: String { get }
    
    func resetAllSettings()
}

final class SettingsViewModel: SettingsViewModeling {
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
