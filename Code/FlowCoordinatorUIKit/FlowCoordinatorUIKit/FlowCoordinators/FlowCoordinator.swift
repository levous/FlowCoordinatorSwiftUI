//
//  FlowCoordinator.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/12/22.
//

import UIKit

protocol FlowCoordinator {
    /// Initial view controller for the flow
    @MainActor var rootViewController: UIViewController { get }
    /// Starts the coordinated flow
    @MainActor func start()
}
