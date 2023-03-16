//
//  StatisticsViewController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import UIKit
import SwiftUI

final class StatisticsViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        let rootView = StatisticsView()
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Statistics"
    }
}
