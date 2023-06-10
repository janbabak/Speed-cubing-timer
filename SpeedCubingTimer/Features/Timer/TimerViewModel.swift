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
    @Published private(set) var timerIsRunning = false
    @Published private(set) var cube = Cube()
    @Published var deleteConfirmationDialogPresent = false
    
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
    
    var solvesReversed: [Solve] {
        solves.reversed()
    }
    
    var notDnfSolves: [Solve] {
        solves.filter({ $0.penalty != .DNF })
    }
    
    var currentMeanOf3: String {
        currentAverage(of: 3)
    }
    
    var bestMeanOf3: String {
        bestAverage(of: 3)
    }
    
    var currentAverageOf5: String {
        currentAverage(of: 5)
    }
    
    var bestAverageOf5: String {
        bestAverage(of: 5)
    }
    
    var currentAverageOf12: String {
        currentAverage(of: 12)
    }
    
    var bestAverageOf12: String {
        bestAverage(of: 12)
    }
    
    var currentAverageOf50: String {
        currentAverage(of: 50)
    }
    
    var bestAverageOf50: String {
        bestAverage(of: 50)
    }
    
    var currentAverageOf100: String {
        currentAverage(of: 100)
    }
    
    var bestAverageOf100: String {
        bestAverage(of: 100)
    }
    
    var currentAverageOfAll: String {
        currentAverage()
    }
    
    var bestTime: String {
        return TimeFormatters.formatTime(seconds: notDnfSolves.min(by: { $0.inSeconds < $1.inSeconds })?.inSeconds)
    }
    
    var worstTime: String {
        return TimeFormatters.formatTime(seconds:notDnfSolves.max(by: { $0.inSeconds < $1.inSeconds })?.inSeconds)
    }
    
    // MARK: - private props
    
    private var timer = Timer()
    private let timerInterval = 0.01
    
    // MARK: - public methods
    
    init() {
        //TODO: remove after testing
        addExampleData()
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
    
    /// computes average of last `numberOfSolves` solves
    private func currentAverage(of numberOfSolves: Int = -1) -> String {
        let numberOfSolves = (numberOfSolves == -1 ? solves.count : numberOfSolves)

        // e. g. can compute average of 12, when there are only 5 solves
        if (solves.count < numberOfSolves) {
            return "-"
        }
        
        return TimeFormatters.formatTime(seconds: average(fromIdx: solves.count - numberOfSolves, numberOfSolves: numberOfSolves))
    }
    
    /// computes best average of `numberOfSolves`
    private func bestAverage(of numberOfSolves: Int) -> String {
        if (numberOfSolves > solves.count) {
            return "-"
        }
        
        var bestAverage: Double? = nil
        
        for i in 0...(solves.count - numberOfSolves) {
            let nextAverage = average(fromIdx: i, numberOfSolves: numberOfSolves)
            if nextAverage != nil && (bestAverage ==  nil || nextAverage! < bestAverage!) {
                    bestAverage = nextAverage
            }
        }
        
        return TimeFormatters.formatTime(seconds: bestAverage)
    }
    
    private func average(fromIdx: Int, numberOfSolves: Int) -> Double? {
        if fromIdx + numberOfSolves > solves.count || numberOfSolves > solves.count || fromIdx < 0 || numberOfSolves < 0 {
            return nil
        }
        var numberOfRemovedSolves: Int
        
        if numberOfSolves < 5 {
            numberOfRemovedSolves = 0
        } else if numberOfSolves < 12 {
            numberOfRemovedSolves = 1
        } else if numberOfSolves < 40 {
            numberOfRemovedSolves = Int(floor(Double(numberOfSolves) / 12.0))
        } else {
            numberOfRemovedSolves = Int(floor(Double(numberOfSolves) / 20.0))
        }
        
        let currentTimes = solves[fromIdx...(fromIdx + numberOfSolves - 1)]
            .sorted(by: { a, b in
                // sort by times (from best to worst), DNF is the worst time regardless the inSeconds prop
                if a.penalty == .DNF {
                    return false
                } else if b.penalty == .DNF {
                    return true
                }
                return a.inSeconds < b.inSeconds
            })[numberOfRemovedSolves...(numberOfSolves - numberOfRemovedSolves - 1)]
        
        // check if there left any solve with DNF penalty - if so, average is undefined
        if currentTimes.first(where: { $0.penalty == .DNF }) != nil {
            return nil
        }
        
        // compute the average
        return currentTimes.reduce(0) { partialResult, solve in
            partialResult + solve.inSeconds
        } / Double(currentTimes.count)
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
