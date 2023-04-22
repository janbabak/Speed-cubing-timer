//
//  SolvesView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct SolvesView: View {
    @ObservedObject var timerViewModel: TimerViewModel
    
    var body: some View {
        List(timerViewModel.solves) { solve in
            listItem(solve: solve)
        }
        .padding(.top, 16)
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
        SolvesView(timerViewModel: .init())
    }
}
