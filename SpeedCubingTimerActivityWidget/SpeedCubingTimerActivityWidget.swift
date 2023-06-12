//
//  SpeedCubingTimerActivityWidget.swift
//  SpeedCubingTimerActivityWidget
//
//  Created by Jan Babák on 12.06.2023.
//

import WidgetKit
import SwiftUI

struct SpeedCubingTimerActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityWidgetAttributes.self) { context in
            TimeActivityView(context: context, isLockScreen: true)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    TimeActivityView(context: context)
                }
            } compactLeading: {
                TimeActivityView(context: context)
            } compactTrailing: {
                
            } minimal: {
                TimeActivityView(context: context)
            }
        }
    }
}

struct TimeActivityView: View {
    let context: ActivityViewContext<TimerActivityWidgetAttributes>
    var isLockScreen = false
    
    var body: some View {
        HStack {
            if isLockScreen {
                Text(context.state.timerColor == .timerRunnig ? "Solve: " : "Inspection: ")
                    .font(.title2)
            }
            
            Text(context.state.time)
                .foregroundColor(isLockScreen ? .primary : context.state.timerColor.uiColor)
                .font(isLockScreen ? .title : .body)
        }
        .padding()
    }
}
