//
//  DataControllerServiceMock.swift
//  SpeedCubingTimerTests
//
//  Created by Jan Babák on 13.06.2023.
//

import Foundation
import CoreData

@testable import SpeedCubingTimer

final class DataControllerServiceMock: DataControllerServicing {
    var fetchSolvesRespose: [SpeedCubingTimer.CDSolve]
    var fetchSolvesSortedByDateDescResponse: [SpeedCubingTimer.CDSolve]
    var fetchNotDNFSolvesResponse: [SpeedCubingTimer.CDSolve]
    var container: NSPersistentContainer
    
    init(
        fetchSolvesRespose: [SpeedCubingTimer.CDSolve] = [],
        fetchSolvesSortedByDateDescResponse: [SpeedCubingTimer.CDSolve] = [],
        fetchNotDNFSolvesResponse: [SpeedCubingTimer.CDSolve] = [],
        container: NSPersistentContainer = .init(name: "SpeedCubingTimerModel")
    ) {
        self.fetchSolvesRespose = fetchSolvesRespose
        self.fetchSolvesSortedByDateDescResponse = fetchSolvesSortedByDateDescResponse
        self.fetchNotDNFSolvesResponse = fetchNotDNFSolvesResponse
        self.container = container
    }
    
    func save() {}
    
    func fetchSolves() -> [SpeedCubingTimer.CDSolve] {
        for solve in fetchSolvesRespose {
            print(solve)
        }
        return fetchSolvesRespose
    }
    
    func fetchSolvesSortedByDateDesc() -> [SpeedCubingTimer.CDSolve] {
        fetchSolvesSortedByDateDescResponse
    }
    
    func fetchNotDNFSolves() -> [SpeedCubingTimer.CDSolve] {
        fetchNotDNFSolvesResponse
    }
    
    func deleteSolve(solve: SpeedCubingTimer.CDSolve) {}
    
    func deleteAllSolves() {}
    
    func addSolve(solve: SpeedCubingTimer.Solve) {}
    
    func addSolve(
        scramble: String,
        date: Date,
        hours: Int16,
        minutes: Int16,
        seconds: Int16,
        fractions: Int16,
        note: String,
        penalty: SpeedCubingTimer.Solve.Penalty
    ) {}
    
    func editSolve(
        solve: SpeedCubingTimer.CDSolve,
        scramble: String?,
        date: Date?,
        hours: Int16?,
        minutes: Int16?,
        seconds: Int16?,
        fractions: Int16?,
        note: String?,
        penalty: SpeedCubingTimer.Solve.Penalty?
    ) {}
}
