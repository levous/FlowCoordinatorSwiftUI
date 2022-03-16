//
//  PreviewState.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/12/22.
//

import FlowCoordinatorShared
import Foundation
import SwiftUI

struct PreviewState {
    let appState: AppState
    @MainActor var profileListViewModel: ProfileListView.ProfileListViewModel {
        let viewModel = ProfileListView.ProfileListViewModel()
        viewModel.profiles = SeedData.profiles
        return viewModel
    }

    @MainActor var profile: PersonProfile {
        SeedData.profiles[0]
    }

    init(appState: AppState = AppState()) {
        self.appState = appState
    }
}

extension View {
    func previewEnvironment() -> some View {
        self.environmentObject(PreviewState().appState)
    }
}
