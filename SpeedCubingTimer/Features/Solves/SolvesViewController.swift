//
//  SolvesViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class SolvesViewController: UIViewController {
    
    private let timerViewModel: TimerViewModel
    
    required init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let rootView = SolvesView() { [weak self] solve in
            self?.onSolveTapped(solve: solve)
        }
        // inject core data context
        let rootViewWithCoreDataContext = rootView.environment(
            \.managedObjectContext,
             DataController.shared.container.viewContext
        )
        let vc = UIHostingController(rootView: rootViewWithCoreDataContext)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Solves"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func onSolveTapped(solve: Solve) {
        let vc = SolveDetailViewController(timerViewModel: timerViewModel, solve: solve)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
