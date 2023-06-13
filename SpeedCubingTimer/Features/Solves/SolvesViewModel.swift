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
    typealias Dependencies = HasDataControllerService
    
    @Published var deleteConfirmationDialogPresent = false
    
    private var solves: [CDSolve] = []
    private var dataControllerService: any DataControllerServicing // TODO: why any
    
    // MARK: - public methods
    
    init(dependencies: Dependencies) {
        dataControllerService = dependencies.dataControllerService
    }
    
    func deleteSolve(at offsets: IndexSet) {
        // refresh data
        fetchSolvesReversed()
        
        // delete solves
        for offset in offsets {
            dataControllerService.deleteSolve(solve: solves[offset])
        }
    }
    
    func deleteAllSolves() {
        dataControllerService.deleteAllSolves()
    }
    
    // MARK: - private methods
    
    // fetch solves from newest to oldest
    private func fetchSolvesReversed() {
        solves = dataControllerService.fetchSolvesSortedByDateDesc()
    }
}
