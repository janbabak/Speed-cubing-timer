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
            
            Spacer()
            
            Text(String(format: "%02d:%02d:%02d.%02d", viewModel.hours, viewModel.minutes, viewModel.seconds, viewModel.fractions))
                .font(.system(size: 44, design: .monospaced))
                .foregroundColor(viewModel.holdingScreen ? .red : .black)
            
            Spacer()
        }
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
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: TimerViewModel())
    }
}
