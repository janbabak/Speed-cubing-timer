//
//  SolveDetailViw.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import SwiftUI

struct SolveDetailView: View {
    
    @State var solve: Solve
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            time
            
            date
            
            scramble
            
            note
            
            penaltyButtons
        }
        .padding(.all, 16)
    }
    
    var time: some View {
        Text(solve.formattedTime)
            .font(.system(size: 44, weight: .semibold, design: .monospaced))
    }
    
    var date: some View {
        Text(DateFormatters.joinedFormatter.string(from: solve.date))
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
            TextEditor(text: $solve.note)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        } label: {
            Text("Note:")
        }
    }
    
    // penalty buttons
    var penaltyButtons: some View {
        HStack {
            //no penalty
            FullwidthButton(label: "no penalty", tint: .green, font: .headline, fullHeight: true) {
                print("no penalty")
            }
            // did not finished
            FullwidthButton(label: "DNF", tint: .orange, fullHeight: true) {
                print("dnf")
            }
            // +2 seconds
            FullwidthButton(label: "+2", tint: .blue, fullHeight: true) {
                print("+2")
            }
        }
        .frame(maxHeight: 75)
    }
}

struct SolveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SolveDetailView(solve: Solve(
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
