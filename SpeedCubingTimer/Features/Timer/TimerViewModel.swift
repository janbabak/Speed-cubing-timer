//
//  TimerViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI
import ActivityKit

final class TimerViewModel: ObservableObject {
    @Published var deleteConfirmationDialogPresent = false
    @Published private(set) var solves: [CDSolve] = []
    @Published private(set) var activeSolve = Solve()
    @Published private(set) var scramble = ScrambleGenerator.generate()
    @Published private(set) var holdingScreen = false
    @Published private(set) var timerIsRunning = false
    @Published private(set) var cube = Cube()
    @Published private(set) var inspectionRunning = false
    @Published private(set) var inspectionSeconds = 0
    @Published private(set) var overInpecting = false // true inspection is > inspection limit
    
    @AppStorage(SettingsViewModel.scrambleVisualizationOnKey) private(set) var scrambleVisualizationOn = true
    @AppStorage(SettingsViewModel.inspectionOnKey) private(set) var inspectionOn = false
    
    // MARK: - private props
    
    @AppStorage(SettingsViewModel.inspectionLimitKey) private var inspectionLimit = 15
    
    private var timer = Timer()
    private let timerInterval = 0.01
    private let inspectionTimerInterval = 1.0 // 1 second
    private var inspectionPenalty = Solve.Penalty.noPenalty
    private var _activity: AnyObject?
    
    @available(iOS 16.1, *)
    private var activity: Activity<TimerActivityWidgetAttributes>? {
        get {
            return _activity as? Activity<TimerActivityWidgetAttributes>
        }
        set {
            _activity = newValue
        }
    }
    
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
        
        inspectionSeconds = 0
        inspectionPenalty = .noPenalty
        
        inspectionRunning = true
        
        startLiveActivity(
            state: TimerActivityWidgetAttributes.ContentState(
                time: TimeFormatters.formatTime(seconds: self.inspectionSeconds)
            )
        )
        
        timer = Timer.scheduledTimer(withTimeInterval: inspectionTimerInterval, repeats: true) { [weak self] timer in
            self!.inspectionSeconds += 1
            
            if #available(iOS 16.1, *) {
                let state = TimerActivityWidgetAttributes.ContentState(
                    time: TimeFormatters.formatTime(seconds: self!.inspectionSeconds),
                    timerColor: .inspectionRunning
                )
                if let activity = self?.activity {
                    Task {
                        await activity.update(using: state)
                    }
                }
            }
            
            if self!.inspectionSeconds >= self!.inspectionLimit {
                self!.overInpecting = true
            }
            if self!.inspectionSeconds >= self!.inspectionLimit + 2 {
                self!.endInspection()
            }
        }
    }
    
    // end inspection time
    private func endInspection() {
        timer.invalidate()
        inspectionRunning = false
        overInpecting = false
        
        print("👀 Inspection ended.")
        
        // if limit was eceeded by more than 2 seconds, solve is DNF
        if inspectionSeconds >= inspectionLimit + 2 {
            print("🚨 inspection exeeded, DNF penalty")
            DataController.shared.addSolve(solve: Solve(scramble: scramble, penalty: .DNF))
            scramble = ScrambleGenerator.generate()
            activeSolve.penalty = .DNF
            fetchSolves()
            
            endLiveActivity()
        }
        // inspection limit was eceeded add +2 penalty
        else if inspectionSeconds >= inspectionLimit {
            inspectionPenalty = .plus2
            print("🚨 inspection exeeded, + 2 penalty")
        }
    }
    
    // start live activity timer
    private func startLiveActivity(state: TimerActivityWidgetAttributes.ContentState) {
        endLiveActivity() // ends the previous activity
        
        if #available(iOS 16.1, *) {
            activity = try? Activity<TimerActivityWidgetAttributes>.request(
                attributes: TimerActivityWidgetAttributes(),
                contentState: state,
                pushType: nil
            )
        }
    }
    
    // end live activity timer
    private func endLiveActivity() {
        if #available(iOS 16.1, *) {
            Task {
                await activity?.end(
                    using: TimerActivityWidgetAttributes.ContentState(time: ""),
                    dismissalPolicy: .immediate
                )
            }
        }
    }
    
    // start timer
    private func startTimer() {
        print("⏱️ Timer started.")
        activeSolve = Solve(scramble: scramble, penalty: inspectionPenalty) // reset the active solve
        timerIsRunning = true
        
        startLiveActivity(
            state: TimerActivityWidgetAttributes.ContentState(
                time: TimeFormatters.formatTime(seconds: activeSolve.isSecondsInteger)
            )
        )
        
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] timer in
            self!.activeSolve.fractions += 1
            self!.carryToHigherOrder()
            
            if #available(iOS 16.1, *) {
                let state = TimerActivityWidgetAttributes.ContentState(time: self!.activeSolve.formattedTimeWithoutFractions)
                
                if let activity = self?.activity {
                    Task {
                        await activity.update(using: state)
                    }
                }
            }
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
        
        endLiveActivity()
        
        // save solve to core data
        DataController.shared.addSolve(solve: activeSolve)
        
        fetchSolves()
    }
}
