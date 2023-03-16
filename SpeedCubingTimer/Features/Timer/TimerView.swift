//
//  TimerView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var timerViewModel: TimerViewModel
    @ObservedObject var solvesViewModel: SolvesViewModel
    
    var body: some View {
        VStack {
            Text(timerViewModel.scramble)
            
            Spacer()
            
            Text(String(format: "%02d:%02d:%02d.%02d", timerViewModel.hours, timerViewModel.minutes, timerViewModel.seconds, timerViewModel.fractions))
                .font(.system(size: 44, design: .monospaced))
                .foregroundColor(timerViewModel.holdingScreen ? .red : .primary)
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            solvesViewModel.addSolve(solve: timerViewModel.onTapGesture())
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    timerViewModel.onDragGestureChange()
                }
                .onEnded { _ in
                    timerViewModel.onTouchUpGesture()
                }
        )
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerViewModel: .init(), solvesViewModel: .init())
    }
}
