//
//  SolvesView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct SolvesView: View {
    @ObservedObject var solvesViewModel: SolvesViewModel
    
    var body: some View {
        Text("Solves view")
        
        ForEach(solvesViewModel.solves, id: \.id) { solve in
            Text(solve.scramble)
        }
    }
}

struct SolvesView_Previews: PreviewProvider {
    static var previews: some View {
        SolvesView(solvesViewModel: .init())
    }
}
