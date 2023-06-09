//
//  StatisticsView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct StatisticsView: View {
    
    @ObservedObject var viewModel: StatisticsViewModel
    
    var body: some View {
        VStack {
            ChartView(viewModel: viewModel)
                .padding(.top, 32)
                .frame(height: 384)
            
            numberStats

            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var numberStats: some View {
        HStack(alignment: .top) {
            //left column
            VStack(alignment: .leading, spacing: 8) {
                LabelPropertyView(
                    label: "curr mean 3:",
                    property: viewModel.timerViewModel.currentMeanOf3
                )
                LabelPropertyView(
                    label: "curr avg 5:",
                    property: viewModel.timerViewModel.currentAverageOf5
                )
                LabelPropertyView(
                    label: "curr avg 12:",
                    property: viewModel.timerViewModel.currentAverageOf12
                )
                LabelPropertyView(
                    label: "curr avg 50:",
                    property: viewModel.timerViewModel.currentAverageOf50
                )
                LabelPropertyView(
                    label: "curr avg 100:",
                    property: viewModel.timerViewModel.currentAverageOf100
                )
                LabelPropertyView(
                    label: "curr avg all:",
                    property: viewModel.timerViewModel.currentAverageOfAll
                )
                LabelPropertyView(
                    label: "best time:",
                    property: viewModel.timerViewModel.bestTime
                )
                
            }
            
            Spacer()
            
            //right column
            VStack(alignment: .leading, spacing: 8) {
                LabelPropertyView(
                    label: "best mean 3:",
                    property: viewModel.timerViewModel.bestMeanOf3
                )
                LabelPropertyView(
                    label: "best avg 5:",
                    property: viewModel.timerViewModel.bestAverageOf5
                )
                LabelPropertyView(
                    label: "best avg 12:",
                    property: viewModel.timerViewModel.bestAverageOf12
                )
                LabelPropertyView(
                    label: "best avg 50:",
                    property: viewModel.timerViewModel.bestAverageOf50
                )
                LabelPropertyView(
                    label: "best avg 100:",
                    property: viewModel.timerViewModel.bestAverageOf100
                )
                LabelPropertyView(
                    label: "solves:",
                    property: "\(viewModel.timerViewModel.solves.count)"
                )
                LabelPropertyView(
                    label: "worst time",
                    property: viewModel.timerViewModel.worstTime
                )
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: .init(timerViewModel: .init()))
    }
}
