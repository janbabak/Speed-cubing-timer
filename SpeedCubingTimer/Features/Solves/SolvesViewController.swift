//
//  SolvesViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class SolvesViewController: UIViewController {
    typealias Dependencies = HasDataControllerService
    
    private let viewModel = SolvesViewModel(dependencies: appDependencies)
    private let dataControllerService: any DataControllerServicing // TODO: why any
    
    init(dependencies: Dependencies) {
        dataControllerService = dependencies.dataControllerService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let rootView = SolvesView(viewModel: viewModel) { [weak self] solve in
            self?.onSolveTapped(solve: solve)
        }
        // inject core data context
        let rootViewWithCoreDataContext = rootView.environment(
            \.managedObjectContext,
             dataControllerService.container.viewContext
        )
        let vc = UIHostingController(rootView: rootViewWithCoreDataContext)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Solves"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(deleteAllSolves)
        )
    }
    
    @objc
    private func deleteAllSolves() {
        viewModel.deleteConfirmationDialogPresent = true
    }
    
    private func onSolveTapped(solve: CDSolve) {
        let vc = SolveDetailViewController(
            viewModel: SolveDetailViewModel(solve: solve, dependencies: appDependencies)
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
