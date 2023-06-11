//
//  SolvesViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class SolvesViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        let rootView = SolvesView { [weak self] solve in
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
    
    private func onSolveTapped(solve: CDSolve) {
        let vc = SolveDetailViewController(
            viewModel: SolveDetailViewModel(solve: solve)
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
