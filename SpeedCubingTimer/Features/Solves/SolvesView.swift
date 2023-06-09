//
//  SolvesView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct SolvesView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    let onSolveTapped: (Solve) -> Void
    
    var body: some View {
        if (viewModel.solves.isEmpty) {
            Text("You don't have any solves yet!")
            
        } else {
            solvesList
                .padding(.top, 16)
        }
    }
    
    var solvesList: some View {
        List {
            ForEach(viewModel.solvesReversed, id: \.id) { solve in
                listItem(solve: solve)
            }
            .onDelete(perform: viewModel.deleteSolve)
        }
        .listStyle(.inset)
    }
    
    @ViewBuilder
    func listItem(solve: Solve) -> some View {
        Button {
            onSolveTapped(solve)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(solve.formattedTime)
                        .padding(.bottom, 4)

                    Spacer()

                    if (solve.penalty != .noPenalty) {
                        Text(solve.penalty.rawValue)
                            .foregroundColor(.red)
                    }
                }
                Text(solve.scramble).font(.caption)
            }
            .foregroundColor(Color.primary)
        }
    }
}

struct SolvesView_Previews: PreviewProvider {
    static var previews: some View {
        SolvesView(viewModel: .init(), onSolveTapped: { _ in })
    }
}
