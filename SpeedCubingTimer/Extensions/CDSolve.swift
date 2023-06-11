//
//  CDSolveExtension.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import Foundation

extension CDSolve {
    
    // format time including the penalty
    var formattedTime: String {
        if penalty == Solve.Penalty.DNF.rawValue {
            return "DNF"
        }
        
        var secondsOut = seconds
        var minutesOut = minutes
        var hoursOut = hours
        
        if penalty == Solve.Penalty.plus2.rawValue {
            secondsOut += 2
        }
        
        if secondsOut > 59 {
            minutesOut += secondsOut / 60
            secondsOut %= 60
        }
        
        if minutesOut > 59 {
            hoursOut += minutesOut / 60
            minutesOut %= 60
        }
        
        if hoursOut == 0 {
            if minutesOut == 0 {
                return String(format: "%02d.%02d", secondsOut, fractions)
            } else {
                return String(format: "%02d:%02d.%02d", minutesOut, secondsOut, fractions)
            }
        }
        return String(format: "%02d:%02d:%02d.%02d", hoursOut, minutesOut, secondsOut, fractions)
    }
}
