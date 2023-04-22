//
//  TimerView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text(timerViewModel.scramble)
                .font(.title2)
            
            Spacer()
            
            time
            
            Spacer()
            
            buttons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            timerViewModel.onTapGesture()
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    timerViewModel.onDragGestureChange()
                }
                .onEnded { _ in
                    timerViewModel.onTouchUpGesture()
                }
        )
    }
    
    var time: some View {
        Text(timerViewModel.lastSolve.formattedTime)
            .font(.system(size: 44, design: .monospaced))
            .foregroundColor(timerViewModel.holdingScreen ? .red : .primary)
    }
    
    // delete, DNF, +2 buttons
    var buttons: some View {
        HStack {
            //delete solve
            FullwidthButton(label: "Delete", tint: .red) {
                print("tap")
            }
            // did not finished
            FullwidthButton(label: "DNF", tint: .orange) {
                timerViewModel.setDnfToLastSolve()
            }
            // +2 seconds
            FullwidthButton(label: "+2", tint: .blue) {
                timerViewModel.setPlus2toLastSolve()
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerViewModel: .init())
    }
}
