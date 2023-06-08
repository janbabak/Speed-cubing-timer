//
//  TimeFormatter.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import Foundation


enum DateFormatters {
    static let joinedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ddMMYYYY hhmm")
        
        return formatter
    }()
}
