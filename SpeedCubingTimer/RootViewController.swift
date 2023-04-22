//
//  ViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit

class RootViewController: UIViewController {
    private var timerViewModel = TimerViewModel()
    private weak var tabBar: UITabBarController!

    override func loadView() {
        super.loadView()
        
        //timer
        let timerController = TimerViewController(timerViewModel: timerViewModel)
        let timerNavigationController = UINavigationController(rootViewController: timerController)
        timerNavigationController.tabBarItem.title = "Timer"
        timerNavigationController.tabBarItem.image = UIImage(systemName: "timer")
        
        //solves
        let solvesController = SolvesViewController(timerViewModel: timerViewModel)
        let solvesNavigationController = UINavigationController(rootViewController: solvesController)
        solvesNavigationController.tabBarItem.title = "Solves"
        solvesNavigationController.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        //statistics
        let statisticsController = StatisticsViewController()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        statisticsNavigationController.tabBarItem.title = "Statistics"
        statisticsNavigationController.tabBarItem.image = UIImage(systemName: "chart.xyaxis.line")
        
        //tab bar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            solvesNavigationController,
            timerNavigationController,
            statisticsNavigationController,
        ]
        tabBarController.selectedIndex = 1 //select 2nd tab = timer
        embedController(tabBarController)
        self.tabBar = tabBarController
    }
}

