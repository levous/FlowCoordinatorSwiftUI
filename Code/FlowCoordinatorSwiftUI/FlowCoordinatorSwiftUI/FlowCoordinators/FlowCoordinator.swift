//
//  FlowCoordinator.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/12/22.
//

protocol FlowCoordinator: AnyObject {
    /// Starts the coordinated flow
    @MainActor func start()
}
