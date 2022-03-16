//
//  FlowCoordinatorSwiftUIApp.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/11/22.
//

import FlowCoordinatorShared
import SwiftUI

@main
struct FlowCoordinatorSwiftUIApp: App {

    private let appState: AppState

    init() {
        self.appState = AppState()
        AppFlowCoordinator.configureSharedInstance(appState: self.appState)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
        }
    }
}
