//
//  Solve.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct Solve: Identifiable {
    var scramble: String
    var date: Date
    var hours: Int
    var minutes: Int
    var seconds: Int
    var fractions: Int
    var penalty: SolvePenalty
    var id = UUID().uuidString
    
    var formattedTime: String {
        if hours == 0 {
            if minutes == 0 {
                return String(format: "%02d.%02d", seconds, fractions)
            } else {
                return String(format: "%02d:%02d.%02d", minutes, seconds, fractions)
            }
        }
        return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, fractions)
    }
}

enum SolvePenalty {
    case noPenalty
    case plus2 //+ 2 seconds
    case DNF //Did Not Finished
}
