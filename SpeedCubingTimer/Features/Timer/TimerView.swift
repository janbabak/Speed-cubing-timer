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
            scramble
                .padding(.bottom, 16)
            
            time
                .padding(.bottom, 16)
            
            stats

            cube
            
            buttons
        }
        .padding(.all, 16)
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
        .onAppear {
            viewModel.visualizeCurrentScramble()
        }
    }
    
    var scramble: some View {
        Text(viewModel.scramble)
            .font(.title2)
    }
    
    var time: some View {
        Text(viewModel.lastSolve.formattedTime)
            .font(.system(size: 44, design: .monospaced))
            .foregroundColor(viewModel.holdingScreen ? .red : .primary)
    }
    
    var stats: some View {
        VStack(spacing: 8) {
            LabelPropertyView(label: "mean 5:", property: viewModel.currentMeanOf3)
            LabelPropertyView(label: "avg 5:", property: viewModel.currentAverageOf5)
            LabelPropertyView(label: "avg 12:", property: viewModel.currentAverageOf5)
            LabelPropertyView(label: "avg 50:", property: viewModel.currentAverageOf50)
        }
        .opacity(viewModel.timerIsRunning ? 0 : 1) // stats are not visible, when timer si running
    }
    
    var cube: some View {
        Cube3DView(cube: viewModel.cube)
            .frame(minHeight: 200, maxHeight: .infinity)
    }
    
    // delete, DNF, +2 buttons
    var buttons: some View {
        HStack {
            //delete solve
            FullwidthButton(
                label: "Delete",
                tint: .red,
                borderedProminent: true
            ) {
                viewModel.deleteConfirmationDialogPresent = true
            }
            .confirmationDialog(
                "Delete last solve?",
                isPresented: $viewModel.deleteConfirmationDialogPresent,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive, action: viewModel.deleteLastSolve)
            }
            
            // did not finished
            FullwidthButton(
                label: "DNF",
                tint: .orange,
                borderedProminent: viewModel.lastSolve.penalty == .DNF
            ) {
                viewModel.toggleLastSolvePenalty(penalty: .DNF)
            }
            
            // +2 seconds
            FullwidthButton(
                label: "+2",
                tint: .blue,
                borderedProminent: viewModel.lastSolve.penalty == .plus2
            ) {
                viewModel.toggleLastSolvePenalty(penalty: .plus2)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: .init())
    }
}
