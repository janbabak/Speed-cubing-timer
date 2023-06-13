//
//  SolveDetailViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import SwiftUI

protocol SolveDetailViewModeling: ObservableObject {
    var solve: CDSolve { get set }
    var deleteConfirmationDialogPresent: Bool { get set }
    var puzzle: Puzzle { get }
    var scrambleVisualizationOn: Bool { get set }
    
//    init(solve: CDSolve, dependencies: Depedency) // TODO: should init be here?
    func deleteSolve()
    func setNote(note: String)
    func togglePenalty(penalty: Solve.Penalty)
}

// MARK: - implementation

final class SolveDetailViewModel: SolveDetailViewModeling {
    typealias Dependencies = HasDataControllerService
    
    @Published var solve: CDSolve
    @Published var deleteConfirmationDialogPresent = false
    @Published private(set) var puzzle: Puzzle = Cube3x3()
    
    @AppStorage(SettingsViewModel.scrambleVisualizationOnKey) var scrambleVisualizationOn = true
    
    private var dataControllerService: any DataControllerServicing // TODO: why any
    
    init(solve: CDSolve, dependencies: Dependencies) {
        dataControllerService = dependencies.dataControllerService
        self.solve = solve
        puzzle.scramble(solve.scramble ?? "")
    }
    
    func deleteSolve() {
        dataControllerService.deleteSolve(solve: solve)
    }
    
    func setNote(note: String) {
        dataControllerService.editSolve(
            solve: solve,
            scramble: nil,
            date: nil,
            hours: nil,
            minutes: nil,
            seconds: nil,
            fractions: nil,
            note: note,
            penalty: nil
        )
    }
    
    func togglePenalty(penalty: Solve.Penalty) {
        if solve.penalty == penalty {
            solve.penalty = .noPenalty
        } else {
            solve.penalty = penalty
        }
        
        // TODO: fix this ugly method https://medium.com/@georgetsifrikas/swift-protocols-with-default-values-b7278d3eef22
        dataControllerService.editSolve(
            solve: solve,
            scramble: nil,
            date: nil,
            hours: nil,
            minutes: nil,
            seconds: nil,
            fractions: nil,
            note: nil,
            penalty: nil
        )
        
        objectWillChange.send() // triggers the UI refresh
    }
}
