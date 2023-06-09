//
//  StatisticsViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class StatisticsViewController: UIViewController {
    private let timerViewModel: TimerViewModel
    
    init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let rootView = StatisticsView(viewModel: StatisticsViewModel(timerViewModel: timerViewModel))
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Statistics"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
