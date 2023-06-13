//
//  SolveDetailViw.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import SwiftUI

struct SolveDetailView<ViewModel: SolveDetailViewModeling>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            time
            
            date()
            
            scramble
            
            note
            
            puzzleVisualization
            
            penaltyButtons
        }
        .padding(.all, 16)
        .confirmationDialog(
            "Delete solve?",
            isPresented: $viewModel.deleteConfirmationDialogPresent,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteSolve()
                dismiss()
            }
        }
    }
    
    var time: some View {
        Text(viewModel.solve.formattedTime)
            .font(.system(size: 44, weight: .medium, design: .monospaced))
    }
    
    @ViewBuilder
    func date() -> some View {
        Text(TimeFormatters.joinedFormatter.string(from: viewModel.solve.date ?? Date()))
            .foregroundColor(.gray)
            .font(.title3)
    }
    
    var scramble: some View {
        GroupBox {
            Text(viewModel.solve.scramble ?? "")
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
                                viewModel.solve.note ?? ""
                            },
                            set: { value in
                                viewModel.setNote(note: value)
                            }
                        )
            )
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .frame(minHeight: 32, maxHeight: viewModel.scrambleVisualizationOn ? 32 : .infinity)
        } label: {
            Text("Note:")
        }
    }
    
    @ViewBuilder
    var puzzleVisualization: some View {
        if viewModel.scrambleVisualizationOn {
            Puzzle3DVizualizationView(puzzle: viewModel.puzzle)
                .frame(minHeight: 80, maxHeight: .infinity)
        }
    }
    
    // penalty buttons
    var penaltyButtons: some View {
        HStack {
            //no penalty
            FullwidthButton(
                label: "no penalty",
                tint: .green, font: .headline,
                fullHeight: true,
                borderedProminent: viewModel.solve.penalty == .noPenalty
            ) {
                viewModel.togglePenalty(penalty: .noPenalty)
            }
            
            // did not finished
            FullwidthButton(
                label: "DNF",
                tint: .orange,
                fullHeight: true,
                borderedProminent: viewModel.solve.penalty == .DNF
            ) {
                viewModel.togglePenalty(penalty: .DNF)
            }
            
            // +2 seconds
            FullwidthButton(
                label: "+2",
                tint: .blue,
                fullHeight: true,
                borderedProminent: viewModel.solve.penalty == .plus2
            ) {
                viewModel.togglePenalty(penalty: .plus2)
            }
        }
        .frame(maxHeight: 75)
    }
}

struct SolveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SolveDetailView(
            viewModel: SolveDetailViewModel(
                solve: Self.createSolve(),
                dependencies: appDependencies
            )
        )
    }
    
    static func createSolve() -> CDSolve {
        let solve = CDSolve()
        solve.scramble = "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D"
        solve.date = Date()
        solve.hours = 0
        solve.minutes = 0
        solve.seconds = 12
        solve.fractions = 59
        solve.penalty = .plus2
        
        return solve
    }
}
