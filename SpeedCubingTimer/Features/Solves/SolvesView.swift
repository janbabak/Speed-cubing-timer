//
//  SolvesView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI
import CoreData

struct SolvesView<ViewModel: SolvesViewModeling>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ]) private var solves: FetchedResults<CDSolve>
    
    let onSolveTapped: (CDSolve) -> Void
    
    var body: some View {
        Group {
            if (solves.isEmpty) {
                Text("You don't have any solves yet!")
            } else {
                VStack(alignment: .leading) {
                    Text("Number of solves: \(solves.count)")
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    solvesList
                }
            }
        }
        .confirmationDialog(
            "Delete all solves?",
            isPresented: $viewModel.deleteConfirmationDialogPresent,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteAllSolves()
            }
        }
    }
    
    private var solvesList: some View {
        List {
            ForEach(solves, id: \.id) { solve in
                listItem(solve: solve)
            }
            .onDelete(perform: viewModel.deleteSolve)
        }
        .listStyle(.inset)
    }
    
    @ViewBuilder
    private func listItem(solve: CDSolve) -> some View {
        Button {
            onSolveTapped(solve)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(solve.formattedTime)
                        .padding(.bottom, 4)
                    
                    Spacer()
                    
                    if (solve.penalty != .noPenalty) {
                        Text(solve.penalty.rawValue)
                            .foregroundColor(.red)
                    }
                }
                Text(solve.scramble ?? "").font(.caption)
            }
            .foregroundColor(Color.primary)
        }
    }
}

struct SolvesView_Previews: PreviewProvider {
    static var previews: some View {
        SolvesView(
            viewModel: SolvesViewModel(dependencies: appDependencies),
            onSolveTapped: { _ in }
        )
    }
}
