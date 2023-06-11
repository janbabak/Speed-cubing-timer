//
//  SolvesViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import CoreData

final class SolvesViewModel: ObservableObject {
    // MARK: - private props
    
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
    
    // MARK: - private methods
    
    // fetch solves from newest to oldest
    private func fetchSolvesReversed() {
        solves = DataController.shared.fetchSolvesSortedByDateDesc()
    }
}
