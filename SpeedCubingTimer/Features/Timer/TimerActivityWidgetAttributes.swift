//
//  TimeTrackingAttributes.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 12.06.2023.
//

import SwiftUI
import ActivityKit

// attributes of activity widget
struct TimerActivityWidgetAttributes: ActivityAttributes {
    typealias TimeTrackingStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var time = ""
        var timerColor = TimerColor.timerRunnig
    }
}

enum TimerColor: String, Decodable, Encodable {
    case inspectionRunning = "green"
    case timerRunnig = "accent"
    
    var uiColor: Color {
        switch self {
        case .inspectionRunning:
            return .green
        case .timerRunnig:
            return .orange
        }
    }
}
