//
//  SolvesView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct SolvesView: View {
    @ObservedObject var viewModel: TimerViewModel
    
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
            ForEach(viewModel.solves, id: \.id) { solve in
                listItem(solve: solve)
            }
            .onDelete(perform: viewModel.removeSolve)
        }
    }
    
    @ViewBuilder
    func listItem(solve: Solve) -> some View {
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
            //TODO: add links to detail
        }
    }
}

struct SolvesView_Previews: PreviewProvider {
    static var previews: some View {
        SolvesView(viewModel: .init())
    }
}
