//
//  StatisticsView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct StatisticsView: View {
    
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        ChartView(viewModel: viewModel)
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .frame(height: 400)
        
        Spacer()
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: .init())
    }
}
