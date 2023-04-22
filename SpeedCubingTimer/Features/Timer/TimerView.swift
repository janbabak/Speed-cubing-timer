//
//  TimerView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.scramble)
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
            viewModel.onTapGesture()
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    viewModel.onDragGestureChange()
                }
                .onEnded { _ in
                    viewModel.onTouchUpGesture()
                }
        )
    }
    
    var time: some View {
        Text(viewModel.lastSolve.formattedTime)
            .font(.system(size: 44, design: .monospaced))
            .foregroundColor(viewModel.holdingScreen ? .red : .primary)
    }
    
    // delete, DNF, +2 buttons
    var buttons: some View {
        HStack {
            //delete solve
            FullwidthButton(label: "Delete", tint: .red) {
                viewModel.deleteLastSolve()
            }
            // did not finished
            FullwidthButton(label: "DNF", tint: .orange) {
                viewModel.setDnfToLastSolve()
            }
            // +2 seconds
            FullwidthButton(label: "+2", tint: .blue) {
                viewModel.setPlus2toLastSolve()
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: .init())
    }
}
