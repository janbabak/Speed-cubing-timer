//
//  TimeFormatter.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import Foundation


enum TimeFormatters {
    static let joinedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ddMMYYYY hhmm")
        
        return formatter
    }()
    
    // format time
    static func formatTime(seconds: Double?) -> String {
        guard let seconds = seconds else {
            return "-"
        }
        
        var secondsOut = Int(floor(seconds))
        let fractionsOut = Int((seconds - Double(secondsOut)) * 100)
        var minutesOut = 0
        var hoursOut = 0
        
        if secondsOut > 59 {
            minutesOut = secondsOut / 60
            secondsOut %= 60
        }
        
        if minutesOut > 59 {
            hoursOut = minutesOut / 60
            minutesOut %= 60
        }
        
        if hoursOut == 0 {
            if minutesOut == 0 {
                return String(format: "%02d.%02d", secondsOut, fractionsOut)
            } else {
                return String(format: "%02d:%02d", minutesOut, secondsOut)
            }
        }
        return String(format: "%02d:%02d:%02d", hoursOut, minutesOut, secondsOut)
    }
    
    // format time (for example for chart axis)
    static func formatTime(seconds: Int?) -> String {
        guard let seconds = seconds else {
            return "-"
        }
        
        var secondsOut = seconds
        var minutesOut = 0
        var hoursOut = 0
        
        if secondsOut > 59 {
            minutesOut = secondsOut / 60
            secondsOut %= 60
        }
        
        if minutesOut > 59 {
            hoursOut = minutesOut / 60
            minutesOut %= 60
        }
        
        if hoursOut == 0 {
            if minutesOut == 0 {
                return String(format: "%02d.00", secondsOut)
            } else {
                return String(format: "%02d:%02d", minutesOut, secondsOut)
            }
        }
        return String(format: "%02d:%02d:%02d", hoursOut, minutesOut, secondsOut)
    }
}
