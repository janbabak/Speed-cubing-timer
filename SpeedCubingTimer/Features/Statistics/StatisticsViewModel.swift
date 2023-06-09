//
//  StatisticsViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import SwiftUI

final class StatisticsViewModel: ObservableObject {
    @ObservedObject var timerViewModel: TimerViewModel = .init()
    @Published var selectedItemIdx: Int? = nil
    
    init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    lazy var maxTime: Double? = {
        self.timerViewModel.notDnfSolves.max(by: { $0.inSeconds < $1.inSeconds })?.inSeconds
    }()

    lazy var xAxisMarks: [Int] = {
        let gap = Int(ceil((self.maxTime ?? 0) / 5))
        var marks: [Int] = []
        for i in 0..<5 {
            marks.append(i * gap)
        }
        return marks
    }()
}
