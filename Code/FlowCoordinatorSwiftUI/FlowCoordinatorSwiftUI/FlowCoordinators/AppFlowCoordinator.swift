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
        if appState.routing.selectedTab == tab {
            // tab selection on already selected tab,
            // reset routing state for tab to pop to root
            appState.routing = appState.routing.reset()
        }
        appState.routing.selectedTab = tab
    }

    /// Selects the profile tab and initiates profile flow with `profileID`
    func presentProfile(profileID: String) {
        selectTab(.profile)
        profileFlowCoordinator.presentProfile(profileID: profileID)
    }

    func jeuleeDoTheThing() {
        // this block allows the UI to reflect discreet changes in routing state though it is not functionally necessary
        let animatedNavigationToProfileID: (String) -> Void = { [weak self] profileID in
            guard let self = self else { return }
            // `selectTab` will pop to root when not changing tabs
            // ensure the action can execute animation before setting id
            withAnimation { self.selectTab(.profile) }
            // present profile with short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.presentProfile(profileID: profileID)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            animatedNavigationToProfileID("1")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            animatedNavigationToProfileID("2")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            animatedNavigationToProfileID("1")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8)) {
            self.selectTab(.home)
        }
    }
}
