//
//  SolvesViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class SolvesViewController: UIViewController {
    
    private let solvesViewModel: SolvesViewModel
    
    required init(solvesViewModel: SolvesViewModel) {
        self.solvesViewModel = solvesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let rootView = SolvesView(solvesViewModel: solvesViewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Solves"
    }
}
