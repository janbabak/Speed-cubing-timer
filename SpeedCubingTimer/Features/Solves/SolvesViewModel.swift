//
//  SolvesViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

final class SolvesViewModel: ObservableObject {
    @Published var solves: [Solve] = []
    
    init() {
        //TODO: remove after testing
        self.solves = [
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 16,
                fractions: 34,
                penalty: .DNF
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 12,
                fractions: 59,
                penalty: .plus2
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 59,
                fractions: 99,
                penalty: .noPenalty
            )
        ]
    }
    
    //set last solve penalty to dnf
    func lastDnf() {
        setPenaltyBySolveId(penalty: .DNF, solveId: solves.last?.id ?? "")
    }
    
    //add penalty of 2 seconds to last solve
    func lastPlus2Seconds() {
        setPenaltyBySolveId(penalty: .plus2, solveId: solves.last?.id ?? "")
    }
    
    //set penalty of solve by its id
    func setPenaltyBySolveId(penalty: SolvePenalty, solveId: String) {
        guard let solveIndex = solves.firstIndex(where: { $0.id == solveId }) else { return }
        
        solves[solveIndex].penalty = penalty
    }
    
    func addSolve(solve: Solve?) {
        guard let solve = solve else { return }
        print("✅ save solve")
        solves.append(solve)
    }
}
