//
//  CDSolveExtension.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import Foundation

// Core Data Solve entity extension
extension CDSolve {
    
    // work around stroring enum in Core Data,
    // Core Data strores internal variable penaltyStr as a string representation of enum
    var penalty: Solve.Penalty {
        get {
            return Solve.Penalty(rawValue: penaltyStr ?? "") ?? .noPenalty
        }
        set {
            penaltyStr = newValue.rawValue
        }
    }
    
    // result time in seconds
    var inSeconds: Double {
        return Double(hours * 3600 + minutes * 60 + seconds + (penalty == .plus2 ? 2 : 0))
        + Double(fractions) / 100.0
    }
    
    // format time including the penalty
    var formattedTime: String {
        if penalty == .DNF {
            return "DNF"
        }
        
        return TimeFormatters.formatTime(seconds: inSeconds)
    }
}
