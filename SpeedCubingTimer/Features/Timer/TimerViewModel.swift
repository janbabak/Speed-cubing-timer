//
//  TimerViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

final class TimerViewModel: ObservableObject {
    
    @Published var holdingScreen = false
    @Published var scramble = ScrambleGenerator.generate()
    @Published var solve = Solve()
    
    private var solvesViewModel: SolvesViewModel
    private var timer = Timer()
    private var timerIsRunning = false
    private let timerInterval = 0.01
    
    init(solvesViewMode: SolvesViewModel) {
        self.solvesViewModel = solvesViewMode
        
        guard let lastSolve = solvesViewMode.solves.last else { return }
        
        solve = Solve(scramble: "", date: Date(), hours: lastSolve.hours, minutes: lastSolve.minutes, seconds: lastSolve.seconds, fractions: lastSolve.fractions, penalty: lastSolve.penalty)
    }
    
    //start or stop the timer based on its state (running or not)
    func onTapGesture() -> Void {
        guard timerIsRunning else { return }
        stopTimer()
        solve.date = Date()
        solve.scramble = scramble
        scramble = ScrambleGenerator.generate()
        print(solve)
        solvesViewModel.addSolve(solve: solve)
    }
    
    //when drag (hold) gesture starts
    func onDragGestureChange() {
        if !holdingScreen {
            holdingScreen = true
        }
    }
    
    //hold (drag) gesture end - fires the timer (if not running)
    func onTouchUpGesture() {
        guard !timerIsRunning else { return }
        holdingScreen = false
        startTimer()
    }
    
    func dnf() {
        solve.penalty = .DNF
    }
    
    func plus2Seconds() {
        solve.penalty = .plus2
    }
    
    func createSolve() -> Solve {
        solve.date = Date()
        solve.scramble = scramble
        return solve
    }
    
    private func startTimer() {
        print("⏱️ Timer started.")
        solve = Solve()
        timerIsRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] timer in
            self!.solve.fractions += 1
            
            self!.carryToHigherOrder()
        }
    }
    
    private func carryToHigherOrder() {
        if solve.fractions > 99 {
            solve.seconds += 1
            solve.fractions = 0
        }
        
        if solve.seconds > 59 {
            solve.minutes += 1
            solve.seconds = 0
        }
        
        if solve.minutes > 59 {
            solve.hours += 1
            solve.minutes = 0
        }
    }
    
    private func stopTimer() {
        print("⏱️ Timer stopped.")
        timerIsRunning = false
        timer.invalidate()
    }
}
