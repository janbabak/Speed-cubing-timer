//
//  SolvesDetailController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import UIKit
import SwiftUI

final class SolveDetailViewController: UIViewController {
    private let timerViewModel: TimerViewModel
    private let solve: Solve
    
    init(timerViewModel: TimerViewModel, solve: Solve) {
        self.timerViewModel = timerViewModel
        self.solve = solve
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let rootView = SolveDetailView(viewModel: timerViewModel, solve: solve)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Solve detail"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(deleteSolve)
        )
    }
    
    @objc
    private func deleteSolve() {
        timerViewModel.deleteSolveById(solveId: solve.id)
        navigationController?.popViewController(animated: true)
    }
}
