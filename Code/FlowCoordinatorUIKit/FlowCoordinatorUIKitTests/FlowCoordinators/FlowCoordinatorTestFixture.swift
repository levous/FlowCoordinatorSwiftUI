//
//  FlowCoordinatorFixture.swift
//  FlowCoordinatorUIKitTests
//
//  Created by Rusty Zarse on 3/11/22.
//

import FlowCoordinatorShared
@testable import FlowCoordinatorUIKit
import XCTest

class FlowCoordinatorTestFixture {

    var serviceFactory: ServiceFactory
    var appState: AppState

    init(profileService: ProfileService? = nil) {
        self.serviceFactory = MockServiceFactory(profileService: profileService)
        self.appState = AppState()
        self.appState.routing = Routing(selectedTab: .home, selectedProfileID: nil)
    }
}
