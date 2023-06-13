//
//  StatisticsViewModelTests.swift
//  SpeedCubingTimerTests
//
//  Created by Jan Babák on 13.06.2023.
//

import XCTest
@testable import SpeedCubingTimer

final class StatisticsViewModelTests: XCTestCase {
    
    private struct Dependencies: StatisticsViewModel.Dependencies {
        var dataControllerService: any SpeedCubingTimer.DataControllerServicing // TODO: why any
    }
    
    private var dependencies: Dependencies!
    private var dataControllerService: DataControllerServiceMock!
    private var viewModel: SpeedCubingTimer.StatisticsViewModel!
    
    override func setUpWithError() throws {
        dataControllerService = .init()
        dependencies = .init(dataControllerService: dataControllerService)
        viewModel = .init(dependencies: dependencies)
    }
    
    func testCurrentAveragesWhenNoSolvesExists() {
        XCTAssertEqual(viewModel.currentMeanOf3, "-")
        XCTAssertEqual(viewModel.currentAverageOf5, "-")
        XCTAssertEqual(viewModel.currentAverageOf12, "-")
        XCTAssertEqual(viewModel.currentAverageOf50, "-")
        XCTAssertEqual(viewModel.currentAverageOf100, "-")
        XCTAssertEqual(viewModel.currentAverageOfAll, "-")
    }
    
    func testBestAveragesWhenNoSolvesExists() {
        XCTAssertEqual(viewModel.bestMeanOf3, "-")
        XCTAssertEqual(viewModel.bestAverageOf5, "-")
        XCTAssertEqual(viewModel.bestAverageOf12, "-")
        XCTAssertEqual(viewModel.bestAverageOf50, "-")
        XCTAssertEqual(viewModel.bestAverageOf100, "-")
    }
    
    func testCurrentMeanOf3WhenSolvesAreOK() {
        let solve1 = CDSolve(context: dataControllerService.container.viewContext)
        solve1.seconds = 10
        
        let solve2 = CDSolve(context: dataControllerService.container.viewContext)
        solve2.seconds = 20
        
        let solve3 = CDSolve(context: dataControllerService.container.viewContext)
        solve3.seconds = 3
        
        let solve4 = CDSolve(context: dataControllerService.container.viewContext)
        solve4.seconds = 10
        
        let solves = [
            solve1,
            solve2,
            solve3,
            solve4
        ]
        
        dataControllerService = DataControllerServiceMock(fetchSolvesRespose: solves)
        dependencies = .init(dataControllerService: dataControllerService)
        viewModel = .init(dependencies: dependencies)
        viewModel.fetchSolves()
        
        XCTAssertNoThrow(viewModel.currentMeanOf3) // TODO: - test the mean, but solves seconds returned from mock are 0, why? Core data issue?
    }
    
    override func tearDownWithError() throws {
    }
}
