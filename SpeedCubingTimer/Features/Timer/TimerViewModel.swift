//
//  TimerViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import SwiftUI

final class TimerViewModel: ObservableObject {
    
    @Published var hours = 0
    @Published var minutes = 0
    @Published var seconds = 0
    @Published var fractions = 0
    @Published var holdingScreen = false
    @Published var scramble = ScrambleGenerator.generate()
    
    private var timer = Timer()
    private var timerIsRunning = false
    private let timerInterval = 0.01
    
    //start or stop the timer based on its state (running or not)
    func onTapGesture() -> Solve? {
        guard timerIsRunning else { return nil }
        stopTimer()
        let solve = createSolve()
        scramble = ScrambleGenerator.generate()
        return solve
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
    
    func createSolve() -> Solve {
        Solve(
            scramble: scramble,
            date: Date(),
            hours: hours,
            minutes: minutes,
            seconds: seconds,
            fractions: fractions,
            penalty: .noPenalty
        )
    }
    
    private func startTimer() {
        print("⏱️ Timer started.")
        timerIsRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] timer in
            self!.fractions += 1
            
            if self!.fractions > 99 {
                self!.seconds += 1
                self!.fractions = 0
            }
            
            if self!.seconds > 59 {
                self!.minutes += 1
                self!.seconds = 0
            }
            
            if self!.minutes > 59 {
                self!.hours += 1
                self!.minutes = 0
            }
        }
    }
    
    private func stopTimer() {
        print("⏱️ Timer stopped.")
        timerIsRunning = false
        timer.invalidate()
    }
}
