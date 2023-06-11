//
//  CDSolveExtension.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import Foundation

// Core Data Solve entity extension
extension CDSolve {
    
    // result time in seconds
    var inSeconds: Double {
        return Double(hours * 3600 + minutes * 60 + seconds + (penalty == Solve.Penalty.plus2.rawValue ? 2 : 0))
        + Double(fractions) / 100.0
    }
    
    // format time including the penalty
    var formattedTime: String {
        if penalty == Solve.Penalty.DNF.rawValue {
            return "DNF"
        }
        
        return TimeFormatters.formatTime(seconds: inSeconds)
    }
}
