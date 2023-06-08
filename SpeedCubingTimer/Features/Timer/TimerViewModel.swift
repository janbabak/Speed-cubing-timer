//
//  TimerViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

final class TimerViewModel: ObservableObject {
    
    @Published private(set) var solves: [Solve] = []
    @Published private(set) var scramble = ScrambleGenerator.generate()
    @Published private(set) var holdingScreen = false
    
    var lastSolve: Solve {
        get {
            solves.last ?? Solve(scramble: scramble)
        }
        set {
            guard solves.count > 0 else { return }
            solves[solves.count - 1] = newValue
        }
    }
    
    var solvesReversed: [Solve] {
        solves.reversed()
    }
    
    private var timer = Timer()
    private var timerIsRunning = false
    private let timerInterval = 0.01
    
    // MARK: - public functions
    
    init() {
        //TODO: remove after testing
        self.solves = [
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 16,
                fractions: 34,
                penalty: .DNF
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 12,
                fractions: 59,
                penalty: .plus2
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 59,
                fractions: 99,
                penalty: .noPenalty
            )
        ]
    }
    
    // on tab gesture - stop the timer based on its state (running or not)
    func onTapGesture() -> Void {
        guard timerIsRunning else { return }
        
        stopTimer()
        lastSolve.date = Date()
        scramble = ScrambleGenerator.generate() // prepare next scramle
        print(lastSolve)
    }
    
    // when drag (hold) gesture starts
    func onDragGestureChange() {
        if !holdingScreen {
            holdingScreen = true
        }
    }
    
    // on end of hold gesture - fires the timer (if not running)
    func onTouchUpGesture() {
        guard !timerIsRunning else { return }
        holdingScreen = false
        startTimer()
    }
    
    // set last solve penalty to dnf
    func setDnfToLastSolve() {
        setPenaltyBySolveId(penalty: .DNF, solveId: solves.last?.id ?? "")
    }
    
    // add penalty of 2 seconds to last solve
    func setPlus2toLastSolve() {
        setPenaltyBySolveId(penalty: .plus2, solveId: solves.last?.id ?? "")
    }
    
    // set penalty of solve by its id
    func setPenaltyBySolveId(penalty: Solve.Penalty, solveId: String) -> Solve? {
        guard let solveIndex = solves.firstIndex(where: { $0.id == solveId }) else { return nil }
        
        solves[solveIndex].penalty = penalty
        
        return solves[solveIndex]
    }
    
    // delete solve by id
    func deleteSolveById(solveId: String) {
        solves.removeAll(where: { $0.id == solveId })
    }
    
    // delete solve
    func deleteSolve(at offsets: IndexSet) {
        var inOrderOffsets = IndexSet()
        for offset in offsets {
            inOrderOffsets.insert(solves.count - offset - 1)
        }
        solves.remove(atOffsets: inOrderOffsets)
    }
    
    // delete last solve
    func deleteLastSolve() {
        solves.removeLast()
    }
    
    // set note to solve selected by its id
    func setNoteBySolveId(note: String, solveId: String) -> Solve? {
        guard let solveIndex = solves.firstIndex(where: { $0.id == solveId }) else { return nil }
        
        solves[solveIndex].note = note
        
        return solves[solveIndex]
    }
    
    // MARK: - private functions
    
    // create new solve - add new solve to solves array
    private func createSolve() {
        solves.append(Solve(scramble: scramble))
    }
    
    // start timer
    private func startTimer() {
        print("⏱️ Timer started.")
        createSolve()
        timerIsRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] timer in
            self!.lastSolve.fractions += 1
            self!.carryToHigherOrder()
        }
    }
    
    // carray fractions or seconds or minutes overflow to higher order
    private func carryToHigherOrder() {
        if lastSolve.fractions > 99 {
            lastSolve.seconds += 1
            lastSolve.fractions = 0
        }
        
        if lastSolve.seconds > 59 {
            lastSolve.minutes += 1
            lastSolve.seconds = 0
        }
        
        if lastSolve.minutes > 59 {
            lastSolve.hours += 1
            lastSolve.minutes = 0
        }
    }
    
    // stop timer
    private func stopTimer() {
        timer.invalidate()
        timerIsRunning = false
        print("⏱️ Timer stopped.")
    }
}
