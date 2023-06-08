//
//  SolvesDetailController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import UIKit
import SwiftUI

final class SolveDetailController: UIViewController {
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
        
        let rootView = SolveDetailView(solve: .init())
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
}
