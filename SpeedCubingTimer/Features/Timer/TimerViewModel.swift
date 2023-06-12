//
//  TimerViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

final class TimerViewModel: ObservableObject {
    @Published var deleteConfirmationDialogPresent = false
    @Published private(set) var solves: [CDSolve] = []
    @Published private(set) var activeSolve = Solve()
    @Published private(set) var scramble = ScrambleGenerator.generate()
    @Published private(set) var holdingScreen = false
    @Published private(set) var timerIsRunning = false
    @Published private(set) var cube = Cube()
    @Published private(set) var inspectionRunning = false
    @Published private(set) var inspectionsSeconds = 0
    
    @AppStorage(SettingsViewModel.scrambleVisualizationOnKey) private(set) var scrambleVisualizationOn = true
    @AppStorage(SettingsViewModel.inspectionOnKey) private(set) var inspectionOn = false
    
    // MARK: - private props
    
    @AppStorage(SettingsViewModel.inspectionLimitKey) private var inspectionLimit = 15
    
    private var timer = Timer()
    private let timerInterval = 0.01
    private let inspectionTimerInterval = 1.0 // 1 second
    private var inspectionPenalty = Solve.Penalty.noPenalty
    
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
    func onTapGesture() {
        if !timerIsRunning && inspectionOn {
            startInspection()
            return
        } else if !timerIsRunning {
            return
        }
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
        endInspection()
        startTimer()
    }
    
    // toggle penalty of last solve (toggle between penalty and no penalty)
    func toggleLastSolvePenalty(penalty: Solve.Penalty) {
        if let lastSolve = solves.last {
            if lastSolve.penalty == penalty {
                lastSolve.penalty = .noPenalty
                activeSolve.penalty = .noPenalty
            } else {
                lastSolve.penalty = penalty
                activeSolve.penalty = penalty
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
    
    // start inspection time
    private func startInspection() {
        guard !inspectionRunning else { return }
        
        print("👀 Inspection started.")
        
        inspectionsSeconds = 0
        inspectionPenalty = .noPenalty
        inspectionRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: inspectionTimerInterval, repeats: true) { [weak self] timer in
            self!.inspectionsSeconds += 1
            if self!.inspectionsSeconds >= self!.inspectionLimit + 2 {
                self!.endInspection()
            }
        }
    }
    
    // end inspection time
    private func endInspection() {
        timer.invalidate()
        inspectionRunning = false
        print("👀 Inspection ended.")
        // if limit was eceeded by more than 2 seconds, solve is DNF
        if inspectionsSeconds >= inspectionLimit + 2 {
            print("🚨 inspection exeeded, DNF penalty")
            DataController.shared.addSolve(solve: Solve(scramble: scramble, penalty: .DNF))
            scramble = ScrambleGenerator.generate()
            activeSolve.penalty = .DNF
            fetchSolves()
        }
        // inspection limit was eceeded add +2 penalty
        else if inspectionsSeconds >= inspectionLimit {
            inspectionPenalty = .plus2
            print("🚨 inspection exeeded, + 2 penalty")
        }
    }
    
    // start timer
    private func startTimer() {
        print("⏱️ Timer started.")
        activeSolve = Solve(scramble: scramble, penalty: inspectionPenalty) // reset the active solve
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
