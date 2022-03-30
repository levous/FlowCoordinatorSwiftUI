//
//  RoutingTests.swift
//  
//
//  Created by Rusty Zarse on 3/30/22.
//

import XCTest
@testable import FlowCoordinatorShared

final class RoutingTests: XCTestCase {

    func testResetTab_shouldClearRelatedState() {
        let routing = Routing(selectedTab: .profile, selectedProfileID: "99")
        let routingHomeReset = routing.reset(tab: .home)

        XCTAssertEqual(
            routing,
            routingHomeReset,
            "reset should do nothing because there is no home related routing state"
        )

        let routingProfileReset = routing.reset(tab: .profile)
        // configure expected reset routing result
        var expectedRouting = routing
        expectedRouting.selectedProfileID = nil

        XCTAssertEqual(
            expectedRouting,
            routingProfileReset,
            "reset should clear the profile related routing state"
        )
    }

}
