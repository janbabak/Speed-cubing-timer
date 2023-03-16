//
//  TimerViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class TimerViewController: UIViewController {
    
    private let viewModel = TimerViewModel()
    
    override func loadView() {
        super.loadView()
        
        let rootView = TimerView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Timer"
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
