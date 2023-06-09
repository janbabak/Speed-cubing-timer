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
                .frame(height: 400)
            
            numberStats

            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var numberStats: some View {
        HStack(alignment: .top) {
            //left column
            VStack(alignment: .leading, spacing: 8) {
                labelPropertyView(
                    label: "curr avg 5:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.currentAverageOf5)
                )
                labelPropertyView(
                    label: "curr avg 12:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.currentAverageOf12)
                )
                labelPropertyView(
                    label: "curr avg 50:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.currentAverageOf50)
                )
                labelPropertyView(
                    label: "curr avg 100:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.currentAverageOf100)
                )
                labelPropertyView(
                    label: "curr avg all:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.currentAverageOfAll)
                )
                labelPropertyView(
                    label: "best time:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.bestTime)
                )
                
            }
            
            Spacer()
            
            //right column
            VStack(alignment: .leading, spacing: 8) {
                labelPropertyView(
                    label: "best avg 5:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.bestAverageOf5)
                )
                labelPropertyView(
                    label: "best avg 12:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.bestAverageOf12)
                )
                labelPropertyView(
                    label: "best avg 50:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.bestAverageOf50)
                )
                labelPropertyView(
                    label: "best avg 100:",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.bestAverageOf100)
                )
                labelPropertyView(
                    label: "solves:",
                    property: "\(viewModel.timerViewModel.solves.count)"
                )
                labelPropertyView(
                    label: "worst time",
                    property: TimeFormatters.formatTime(seconds: viewModel.timerViewModel.worstTime)
                )
            }
        }
    }
    
    private func labelPropertyView(label: String, property: String) -> some View {
            HStack() {
                Text(LocalizedStringKey(label))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(property)
                    .fontWeight(.semibold)
            }
        }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: .init(timerViewModel: .init()))
    }
}
