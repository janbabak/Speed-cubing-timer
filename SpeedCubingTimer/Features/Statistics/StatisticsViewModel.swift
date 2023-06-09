//
//  StatisticsViewModel.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import Foundation

protocol StatisticsViewModeling: ObservableObject {
    var selectedItemIdx: Int? { get set }
    var solves: [CDSolve] { get }
    var notDnfSolves: [CDSolve] { get }
    var currentMeanOf3: String { get }
    var bestMeanOf3: String { get }
    var currentAverageOf5: String { get }
    var bestAverageOf5: String { get }
    var currentAverageOf12: String { get }
    var bestAverageOf12: String { get }
    var currentAverageOf50: String { get }
    var bestAverageOf50: String { get }
    var currentAverageOf100: String { get }
    var bestAverageOf100: String { get }
    var currentAverageOfAll: String { get }
    var formattedBestTime: String { get }
    var formattedWorstTime: String { get }
    var worstTime: Double? { get }
    static var numberOfMarks: Int { get }
    var xAxisMarks: [Int] { get }
    
    func fetchSolves()
    
    /// computes average of last `numberOfSolves` solves
    static func currentAverage(of numberOfSolves: Int, from solves: [CDSolve]) -> String

    /// computes best average of `numberOfSolves`
    static func bestAverage(of numberOfSolves: Int, from solves: [CDSolve]) -> String
}

// MARK: - implementation

final class StatisticsViewModel: StatisticsViewModeling {
    typealias Dependencies = HasDataControllerService
    
    @Published var selectedItemIdx: Int? = nil
    @Published private(set) var solves: [CDSolve] = []
    @Published private(set) var notDnfSolves: [CDSolve] = []
    
    static let numberOfMarks = 5
    
    private var dataControllerService: any DataControllerServicing // TODO: why any
    
    // MARK: - computed props
    
    var currentMeanOf3: String {
        Self.currentAverage(of: 3, from: solves)
    }
    
    var bestMeanOf3: String {
        Self.bestAverage(of: 3, from: solves)
    }
    
    var currentAverageOf5: String {
        Self.currentAverage(of: 5, from: solves)
    }
    
    var bestAverageOf5: String {
        Self.bestAverage(of: 5, from: solves)
    }
    
    var currentAverageOf12: String {
        Self.currentAverage(of: 12, from: solves)
    }
    
    var bestAverageOf12: String {
        Self.bestAverage(of: 12, from: solves)
    }
    
    var currentAverageOf50: String {
        Self.currentAverage(of: 50, from: solves)
    }
    
    var bestAverageOf50: String {
        Self.bestAverage(of: 50, from: solves)
    }
    
    var currentAverageOf100: String {
        Self.currentAverage(of: 100, from: solves)
    }
    
    var bestAverageOf100: String {
        Self.bestAverage(of: 100, from: solves)
    }
    
    var currentAverageOfAll: String {
        Self.currentAverage(from: solves)
    }
    
    var formattedBestTime: String {
        TimeFormatters.formatTime(
            seconds: notDnfSolves.min(by: { $0.inSeconds < $1.inSeconds })?.inSeconds
        )
    }
    
    var formattedWorstTime: String {
        TimeFormatters.formatTime(
            seconds: worstTime
        )
    }
    
    var worstTime: Double? {
        notDnfSolves.max(by: { $0.inSeconds < $1.inSeconds })?.inSeconds
    }
    
    var xAxisMarks: [Int] {
        let gap = max(1, Int(ceil((self.worstTime ?? 0) / Double(Self.numberOfMarks))))
        var marks: [Int] = []
        for i in 0..<Self.numberOfMarks {
            marks.append(i * gap)
        }
        return marks
    }
    
    // MARK: - public methods
    
    init(dependencies: Dependencies) {
        dataControllerService = dependencies.dataControllerService
    }
    
    // fetch solves
    func fetchSolves() {
        solves = dataControllerService.fetchSolves()
        notDnfSolves = dataControllerService.fetchNotDNFSolves()
    }
    
    // MARK: - static methods
    
    /// computes average of last `numberOfSolves` solves
    static func currentAverage(of numberOfSolves: Int = -1, from solves: [CDSolve]) -> String {
        let numberOfSolves = (numberOfSolves == -1 ? solves.count : numberOfSolves)
        
        // e.g. can compute average of 12, when there are only 5 solves
        if (solves.count < numberOfSolves) {
            return "-"
        }
        
        return TimeFormatters.formatTime(
            seconds: average(
                fromIdx: solves.count - numberOfSolves,
                numberOfSolves: numberOfSolves,
                from: solves
            )
        )
    }
    
    /// computes best average of `numberOfSolves`
    static func bestAverage(of numberOfSolves: Int, from solves: [CDSolve]) -> String {
        if (numberOfSolves > solves.count) {
            return "-"
        }
        
        var bestAverage: Double? = nil
        
        for i in 0...(solves.count - numberOfSolves) {
            let nextAverage = average(fromIdx: i, numberOfSolves: numberOfSolves, from: solves)
            if nextAverage != nil && (bestAverage ==  nil || nextAverage! < bestAverage!) {
                bestAverage = nextAverage
            }
        }
        
        return TimeFormatters.formatTime(seconds: bestAverage)
    }
    
    private static func average(fromIdx: Int, numberOfSolves: Int, from solves: [CDSolve]) -> Double? {
        if fromIdx + numberOfSolves > solves.count || numberOfSolves > solves.count || fromIdx < 0 || numberOfSolves < 0 || solves.count == 0 {
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
}
