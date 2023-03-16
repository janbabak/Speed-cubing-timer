//
//  ViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit

class RootViewController: UIViewController {
    private var solvesViewModel = SolvesViewModel()
    private weak var tabBar: UITabBarController!

    override func loadView() {
        super.loadView()
        
        //timer
        let timerController = TimerViewController(solvesViewModel: solvesViewModel)
        let timerNavigationController = UINavigationController(rootViewController: timerController)
        timerNavigationController.tabBarItem.title = "Timer"
        timerNavigationController.tabBarItem.image = UIImage(systemName: "timer")
        
        //solves
        let solvesController = SolvesViewController(solvesViewModel: solvesViewModel)
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

