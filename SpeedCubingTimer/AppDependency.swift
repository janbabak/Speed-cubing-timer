//
//  AppDependency.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 13.06.2023.
//

import Foundation

let appDependencies = AppDependency()

final class AppDependency {
    lazy var dataControllerService: any DataControllerServicing = DataControllerService() // TODO: why any
}

protocol hasNoDependency {}

extension AppDependency: HasDataControllerService {}
