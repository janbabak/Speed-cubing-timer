//
//  SolveDetailViw.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import SwiftUI

struct SolveDetailView: View {
    
    @ObservedObject var viewModel: TimerViewModel
    @State var solve: Solve
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            time
            
            date()
            
            scramble
            
            note
            
            cube
            
            penaltyButtons
        }
        .padding(.all, 16)
        .onAppear {
            viewModel.visualizeScramble(scramble: solve.scramble)
        }
        .confirmationDialog(
            "Delete solve?",
            isPresented: $viewModel.deleteConfirmationDialogPresent,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteSolveById(solveId: solve.id)
                dismiss() // TODO: - Warning "Publishing changes from within view updates is not allowed, this will cause undefined behavior."
            }
        }
    }
    
    var time: some View {
        Text(solve.formattedTime)
            .font(.system(size: 44, weight: .medium, design: .monospaced))
    }
    
    @ViewBuilder
    func date() -> some View {
        Text(TimeFormatters.joinedFormatter.string(from: solve.date))
            .foregroundColor(.gray)
            .font(.title3)
    }
    
    var scramble: some View {
        GroupBox {
            Text(solve.scramble)
                .font(.title3)
        } label: {
            Text("Scramble:")
                .padding(.bottom, 2)
        }
    }
    
    var note: some View {
        GroupBox {
            TextEditor(text:
                        Binding(
                            get: {
                                solve.note
                            },
                            set: { value in
                                solve = viewModel.setNoteBySolveId(note: value, solveId: solve.id)!
                            }
                        )
            )
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        } label: {
            Text("Note:")
        }
    }
    
    var cube: some View {
        Cube3DView(cube: viewModel.cube)
            .frame(minHeight: 200, maxHeight: .infinity)
    }
    
    // penalty buttons
    var penaltyButtons: some View {
        HStack {
            //no penalty
            FullwidthButton(
                label: "no penalty",
                tint: .green, font: .headline,
                fullHeight: true,
                borderedProminent: solve.penalty == .noPenalty
            ) {
                self.solve = viewModel.togglePenalty(penalty: .noPenalty, solveId: solve.id)!
            }
            
            // did not finished
            FullwidthButton(
                label: "DNF",
                tint: .orange,
                fullHeight: true,
                borderedProminent: solve.penalty == .DNF
            ) {
                self.solve = viewModel.togglePenalty(penalty: .DNF, solveId: solve.id)!
            }
            
            // +2 seconds
            FullwidthButton(
                label: "+2",
                tint: .blue,
                fullHeight: true,
                borderedProminent: solve.penalty == .plus2
            ) {
                self.solve = viewModel.togglePenalty(penalty: .plus2, solveId: solve.id)!
            }
        }
        .frame(maxHeight: 75)
    }
}

struct SolveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SolveDetailView(viewModel: .init(), solve: Solve(
            scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
            date: Date(),
            hours: 0,
            minutes: 0,
            seconds: 12,
            fractions: 59,
            penalty: .plus2
        ))
    }
}
