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
    var id = UUID().uuidString
}
