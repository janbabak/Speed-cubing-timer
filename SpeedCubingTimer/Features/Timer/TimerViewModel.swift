//
//  TimerViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

final class TimerViewModel: ObservableObject {
    @Published var activeSolve = Solve()
    @Published var solves: [CDSolve] = []
    @Published var deleteConfirmationDialogPresent = false
    @Published private(set) var scramble = ScrambleGenerator.generate()
    @Published private(set) var holdingScreen = false
    @Published private(set) var timerIsRunning = false
    @Published private(set) var cube = Cube()
    
    @AppStorage(SettingsViewModel.scrambleVisualizationOnKey) var scrambleVisualizationOn = true
    
    // MARK: - computed props
    
    var currentMeanOf3: String {
        StatisticsViewModel.currentAverage(of: 3, from: solves)
    }
    
    var currentAverageOf5: String {
        StatisticsViewModel.currentAverage(of: 5, from: solves)
    }
    
    var currentAverageOf12: String {
        StatisticsViewModel.currentAverage(of: 12, from: solves)
    }
    
    var currentAverageOf50: String {
        StatisticsViewModel.currentAverage(of: 50, from: solves)
    }
    
    // MARK: - private props
    
    private var timer = Timer()
    private let timerInterval = 0.01
    
    // MARK: - public methods
    
    init() {
        fetchSolves()
        cube.scramble(scramble)
    }
    
    // fetch solves
    func fetchSolves() {
        solves = DataController.shared.fetchSolves()
    }
    
    // on tab gesture - stop the timer based on its state (running or not)
    func onTapGesture() -> Void {
        guard timerIsRunning else { return }
        
        stopTimer()
        activeSolve.date = Date()
        scramble = ScrambleGenerator.generate() // prepare next scramble
        cube.scramble(scramble) // visualize next scramble on the cube
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
        if let lastSolve = solves.last {
            if lastSolve.penalty == penalty {
                lastSolve.penalty = .noPenalty
            } else {
                lastSolve.penalty = penalty
            }
            DataController.shared.save()
            fetchSolves()
        }
    }
    
    // delete last solve
    func deleteLastSolve() {
        // first is last, when solves are sorted in descending order
        if let lastSolve = solves.last {
            DataController.shared.deleteSolve(solve: lastSolve)
            fetchSolves()
        }
    }
    
    // MARK: - private methods
    
    // start timer
    private func startTimer() {
        print("⏱️ Timer started.")
        activeSolve = Solve(scramble: scramble)
        timerIsRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] timer in
            self!.activeSolve.fractions += 1
            self!.carryToHigherOrder()
        }
    }
    
    // carray fractions or seconds or minutes overflow to higher order
    private func carryToHigherOrder() {
        if activeSolve.fractions > 99 {
            activeSolve.seconds += 1
            activeSolve.fractions = 0
        }
        
        if activeSolve.seconds > 59 {
            activeSolve.minutes += 1
            activeSolve.seconds = 0
        }
        
        if activeSolve.minutes > 59 {
            activeSolve.hours += 1
            activeSolve.minutes = 0
        }
    }
    
    // stop timer
    private func stopTimer() {
        timer.invalidate()
        timerIsRunning = false
        print("⏱️ Timer stopped.")
        
        // save solve to core data
        DataController.shared.addSolve(solve: activeSolve)
        
        fetchSolves()
    }
}
