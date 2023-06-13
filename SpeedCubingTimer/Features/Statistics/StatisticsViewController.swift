//
//  StatisticsViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class StatisticsViewController: UIViewController {
    private let viewModel = StatisticsViewModel(dependencies: appDependencies)
    
    override func loadView() {
        super.loadView()
        
        let rootView = StatisticsView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Statistics"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchSolves() // refresh the view (load solves from Core Data)
    }
}
