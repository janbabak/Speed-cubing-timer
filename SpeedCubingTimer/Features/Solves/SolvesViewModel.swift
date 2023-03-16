//
//  SolvesViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

final class SolvesViewModel: ObservableObject {
    @Published var solves: [Solve] = []
    
    func addSolve(solve: Solve?) {
        guard let solve = solve else { return }
        print("✅ save solve")
        solves.append(solve)
    }
}
