//
//  ProfileFlowCoordinator.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/12/22.
//

import FlowCoordinatorShared
import SwiftUI

@MainActor class ProfileFlowCoordinator: FlowCoordinator {

    private let appState: AppState
    private let profileService: ProfileService

    init(appState: AppState, profileService: ProfileService) {
        self.appState = appState
        self.profileService = profileService
    }

    // MARK: - Start Coordinated Flow

    func start() {
        // nothing to do
    }

    // MARK: - Navigation

    func presentProfile(profileID: String) {
        guard appState.routing.selectedProfileID != profileID else {
            // already presented
            return
        }

        if appState.routing.selectedProfileID != nil {

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.presentProfile(profileID: profileID)
            }
            withAnimation {
                appState.routing.selectedProfileID = nil
            }
            return 
        }

        // update state
        withAnimation {
            appState.routing.selectedProfileID = profileID
        }
    }

    func presentError(_ message: String, error: Error?) {
        appState.userAlert = .error(title: "So Sorry…", message: message, error: error)
    }
}


