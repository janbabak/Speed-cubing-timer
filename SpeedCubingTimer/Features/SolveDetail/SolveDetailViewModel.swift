//
//  SolveDetailViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import SwiftUI

final class SolveDetailViewModel: ObservableObject {
    @Published var solve: CDSolve
    @Published var deleteConfirmationDialogPresent = false
    @Published private(set) var cube = Cube()
    
    @AppStorage(SettingsViewModel.scrambleVisualizationOnKey) var scrambleVisualizationOn = true
    
    init(solve: CDSolve) {
        self.solve = solve
        cube.scramble(solve.scramble ?? "")
    }
    
    func deleteSolve() {
        DataController.shared.deleteSolve(solve: solve)
    }
    
    func setNote(note: String) {
        DataController.shared.editSolve(solve: solve, note: note)
    }
    
    func togglePenalty(penalty: Solve.Penalty) {
        if solve.penalty == penalty {
            solve.penalty = .noPenalty
        } else {
            solve.penalty = penalty
        }
        
        DataController.shared.editSolve(solve: solve)
        objectWillChange.send() // triggers the UI refresh
    }
}
