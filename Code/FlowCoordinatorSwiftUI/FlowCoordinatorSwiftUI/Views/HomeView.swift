//
//  HomeView.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/29/22.
//

import FlowCoordinatorShared
import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var appState: AppState
    private let appFlowCoordinator = AppFlowCoordinator.sharedInstance

    var body: some View {
        VStack(spacing: 20) {
            Text("Home View").padding(.bottom, 60)

            Button("Show Profile 1") {
                appFlowCoordinator.presentProfile(profileID: "1")
            }

            Button("Show Profile 2") {
                appFlowCoordinator.presentProfile(profileID: "2")
            }

            Button("Update State") {

                appFlowCoordinator.jeuleeDoTheThing()
            }
        }
        .buttonStyle(BorderedButtonStyle()).tint(.blue)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewEnvironment()
    }
}

