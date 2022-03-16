//
//  AppFlowCoordinator.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/12/22.
//

import FlowCoordinatorShared
import SwiftUI

@MainActor class AppFlowCoordinator: FlowCoordinator {

    private let appState: AppState

    private static var _sharedInstance: AppFlowCoordinator?
    static var sharedInstance: AppFlowCoordinator {
        guard let shared = _sharedInstance else {
            Logger.logError("AppFlowCoordinator sharedInstance not configured.  Did you call `configureSharedInstance(appState:)`?")
            preconditionFailure("Cannot continue without configured shared instance")
        }
        return shared
    }

    // Child Flow Coordinators
    private let profileFlowCoordinator: ProfileFlowCoordinator

    // MARK: - init

    init(appState: AppState, serviceFactory: ServiceFactory = AppServiceFactory()) {
        self.appState = appState
        self.profileFlowCoordinator = ProfileFlowCoordinator(appState: appState, profileService: serviceFactory.profileService())
    }

    static func configureSharedInstance(appState: AppState) {
        guard _sharedInstance == nil else {
            Logger.logError("AppFlowCoordinator configureSharedInstance(appState:) called when already initialized.  Ignoring.")
            return
        }
        _sharedInstance = AppFlowCoordinator(appState: appState)
    }

    // MARK: - Start Coordinated Flow

    func start() {
        // nothing to do
    }

    // MARK: - Navigation

    /// Selects the tab
    func selectTab(_ tab: Tab) {
        appState.routing.selectedTab = tab
    }

    /// Selects the profile tab and initiates profile flow with `profileID`
    func presentProfile(profileID: String) {
        selectTab(.profile)
        profileFlowCoordinator.presentProfile(profileID: profileID)
    }
}
