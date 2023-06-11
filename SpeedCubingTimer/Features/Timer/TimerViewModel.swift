//
//  TimerViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI
import CoreData

final class TimerViewModel: ObservableObject {
    
    @Published private(set) var solves: [Solve] = []
    @Published private(set) var scramble = ScrambleGenerator.generate()
    @Published private(set) var holdingScreen = false
    @Published private(set) var timerIsRunning = false
    @Published private(set) var cube = Cube()
    @Published var deleteConfirmationDialogPresent = false
    @Published var cdSolves: [CDSolve] = []
    
    // MARK: - computed props
    
    var lastSolve: Solve {
        get {
            solves.last ?? Solve(scramble: scramble)
        }
        set {
            guard solves.count > 0 else { return }
            solves[solves.count - 1] = newValue
        }
    }
    
    var currentMeanOf3: String {
        StatisticsViewModel.currentAverage(of: 3, from: cdSolves)
    }
    
    var currentAverageOf5: String {
        StatisticsViewModel.currentAverage(of: 5, from: cdSolves)
    }
    
    var currentAverageOf12: String {
        StatisticsViewModel.currentAverage(of: 12, from: cdSolves)
    }
    
    var currentAverageOf50: String {
        StatisticsViewModel.currentAverage(of: 50, from: cdSolves)
    }
    
    // MARK: - private props
    
    private var timer = Timer()
    private let timerInterval = 0.01
    
    // MARK: - public methods
    
    init() {
        //TODO: remove after testing
        addExampleData()
    }
    
    // fetch solves
    func fetchSolves() {
        cdSolves = DataController.shared.fetchSolves()
    }
    
    // on tab gesture - stop the timer based on its state (running or not)
    func onTapGesture() -> Void {
        guard timerIsRunning else { return }
        
        stopTimer()
        lastSolve.date = Date()
        scramble = ScrambleGenerator.generate() // prepare next scramle
        cube.scramble(scramble)
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
    
    // toggle penalty of last solve (toggle between penalty and no penalty)
    func toggleLastSolvePenalty(penalty: Solve.Penalty) {
        togglePenalty(penalty: penalty, solveId: solves.last?.id ?? "")
    }
    
    // toggle between penalty and nopenalty
    func togglePenalty(penalty: Solve.Penalty, solveId: String) -> Solve? {
        guard let solveIndex = solves.firstIndex(where: { $0.id == solveId }) else { return nil }
        
        if solves[solveIndex].penalty == penalty {
            solves[solveIndex].penalty = .noPenalty
        } else {
            solves[solveIndex].penalty = penalty
        }
        
        return solves[solveIndex]
    }
    
    // delete solve by id
    func deleteSolveById(solveId: String) {
        solves.removeAll(where: { $0.id == solveId })
    }
    
    // delete last solve
    func deleteLastSolve() {
        solves.removeLast()
    }
    
    // visualize scramble on the cube
    func visualizeScramble(scramble: String) {
        cube.scramble(scramble)
    }
    
    // visualize current scramble (scramble which will be solved next)
    func visualizeCurrentScramble() {
        visualizeScramble(scramble: scramble)
    }
    
    // MARK: - private methods
    
    // create new solve - add new solve to solves array
    private func createSolve() {
        let solve = Solve(scramble: scramble)
        solves.append(solve)
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
        
        // save solve to core data
        DataController.shared.addSolve(
            scramble: lastSolve.scramble,
            date: lastSolve.date,
            hours: Int16(lastSolve.hours),
            minutes: Int16(lastSolve.minutes),
            seconds: Int16(lastSolve.seconds),
            fractions: Int16(lastSolve.fractions),
            penalty: lastSolve.penalty.rawValue
        )
    }
    
    private func addExampleData() {
        self.solves = [
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F2 B' R' L U' L",
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
                seconds: 35,
                fractions: 99,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 16,
                fractions: 34,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 15,
                fractions: 59,
                penalty: .plus2
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 23,
                fractions: 99,
                penalty: .noPenalty
            ),
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
                seconds: 15,
                fractions: 99,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 20,
                fractions: 34,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 16,
                fractions: 59,
                penalty: .plus2
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 19,
                fractions: 99,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 16,
                fractions: 34,
                penalty: .plus2
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
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 16,
                fractions: 34,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 1,
                seconds: 23,
                fractions: 59,
                penalty: .plus2
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 0,
                seconds: 23,
                fractions: 99,
                penalty: .noPenalty
            ),
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
                seconds: 15,
                fractions: 99,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 1,
                seconds: 20,
                fractions: 34,
                penalty: .noPenalty
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 2,
                seconds: 16,
                fractions: 59,
                penalty: .plus2
            ),
            Solve(
                scramble: "R U R2 F' B D2 L' F U2 R' D' R2 L' B2 F' R D L R D",
                date: Date(),
                hours: 0,
                minutes: 1,
                seconds: 19,
                fractions: 99,
                penalty: .noPenalty
            )
        ]
    }
}
