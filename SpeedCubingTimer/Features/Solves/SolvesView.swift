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
        List(solvesViewModel.solves) { solve in
            listItem(solve: solve)
        }
        .padding(.top, 16)
    }
    
    @ViewBuilder
    func listItem(solve: Solve) -> some View {
        VStack(alignment: .leading) {
            Text(solve.formattedTime)
                .padding(.bottom, 4)
            Text(solve.scramble).font(.caption)
            //TODO: add links to detail
        }
    }
}

struct SolvesView_Previews: PreviewProvider {
    static var previews: some View {
        SolvesView(solvesViewModel: .init())
    }
}
