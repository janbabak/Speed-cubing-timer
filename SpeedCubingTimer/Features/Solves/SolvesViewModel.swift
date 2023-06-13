//
//  SolvesViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import Foundation

protocol SolvesViewModeling: ObservableObject {
    var deleteConfirmationDialogPresent: Bool { get set }
    
    func deleteSolve(at offsets: IndexSet)
    func deleteAllSolves()
}

// MARK: - implementation

final class SolvesViewModel: SolvesViewModeling {
    @Published var deleteConfirmationDialogPresent = false
    
    private var solves: [CDSolve] = []
    
    // MARK: - public methods
    
    func deleteSolve(at offsets: IndexSet) {
        // refresh data
        fetchSolvesReversed()
        
        // delete solves
        for offset in offsets {
            DataController.shared.deleteSolve(solve: solves[offset])
        }
    }
    
    func deleteAllSolves() {
        DataController.shared.deleteAllSolves()
    }
    
    // MARK: - private methods
    
    // fetch solves from newest to oldest
    private func fetchSolvesReversed() {
        solves = DataController.shared.fetchSolvesSortedByDateDesc()
    }
}
