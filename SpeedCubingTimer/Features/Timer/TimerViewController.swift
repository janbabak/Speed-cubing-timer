//
//  TimerViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class TimerViewController: UIViewController {
    
    private var solvesViewModel: SolvesViewModel
    private let viewModel = TimerViewModel()
    
    required init(solvesViewModel: SolvesViewModel) {
        self.solvesViewModel = solvesViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let rootView = TimerView(timerViewModel: viewModel, solvesViewModel: solvesViewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Timer"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self, action: #selector(openSettings)
        )
    }
    
    @objc
    private func openSettings() {
        let vc = SettingsViewController()
        show(vc, sender: self)
    }
}
