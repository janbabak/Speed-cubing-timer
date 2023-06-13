//
//  StatisticsView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct StatisticsView<ViewModel: StatisticsViewModeling>: View {
    
    @ObservedObject var viewModel: ViewModel
    
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
    
    private var numberStats: some View {
        HStack(alignment: .top) {
            //left column
            VStack(alignment: .leading, spacing: 8) {
                LabelPropertyView(
                    label: "curr mean 3:",
                    property: viewModel.currentMeanOf3
                )
                LabelPropertyView(
                    label: "curr avg 5:",
                    property: viewModel.currentAverageOf5
                )
                LabelPropertyView(
                    label: "curr avg 12:",
                    property: viewModel.currentAverageOf12
                )
                LabelPropertyView(
                    label: "curr avg 50:",
                    property: viewModel.currentAverageOf50
                )
                LabelPropertyView(
                    label: "curr avg 100:",
                    property: viewModel.currentAverageOf100
                )
                LabelPropertyView(
                    label: "curr avg all:",
                    property: viewModel.currentAverageOfAll
                )
                LabelPropertyView(
                    label: "best time:",
                    property: viewModel.formattedBestTime
                )
                
            }
            
            Spacer()
            
            //right column
            VStack(alignment: .leading, spacing: 8) {
                LabelPropertyView(
                    label: "best mean 3:",
                    property: viewModel.bestMeanOf3
                )
                LabelPropertyView(
                    label: "best avg 5:",
                    property: viewModel.bestAverageOf5
                )
                LabelPropertyView(
                    label: "best avg 12:",
                    property: viewModel.bestAverageOf12
                )
                LabelPropertyView(
                    label: "best avg 50:",
                    property: viewModel.bestAverageOf50
                )
                LabelPropertyView(
                    label: "best avg 100:",
                    property: viewModel.bestAverageOf100
                )
                LabelPropertyView(
                    label: "solves:",
                    property: "\(viewModel.solves.count)"
                )
                LabelPropertyView(
                    label: "worst time",
                    property: viewModel.formattedWorstTime
                )
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: StatisticsViewModel(dependencies: appDependencies))
    }
}
