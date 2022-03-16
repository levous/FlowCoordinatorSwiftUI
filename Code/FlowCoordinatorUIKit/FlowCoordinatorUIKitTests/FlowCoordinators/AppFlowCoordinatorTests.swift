//
//  AppFlowCoordinatorTests.swift
//  FlowCoordinatorUIKitTests
//
//  Created by Rusty Zarse on 3/11/22.
//

import Combine
import FlowCoordinatorShared
import XCTest
@testable import FlowCoordinatorUIKit

class AppFlowCoordinatorTests: XCTestCase {

    private var cancellables: [AnyCancellable] = []
    private var testFixture: FlowCoordinatorTestFixture = FlowCoordinatorTestFixture()

    @MainActor func makeAndStartTestAppFlowCoordinator(_ testFixture: FlowCoordinatorTestFixture) -> AppFlowCoordinator {
        let appFlowCoordinator = AppFlowCoordinator(appState: testFixture.appState, serviceFactory: testFixture.serviceFactory)
        let window = UIWindow()
        appFlowCoordinator.configure(with: window)
        appFlowCoordinator.start()
        return appFlowCoordinator
    }

    override func setUpWithError() throws {
        testFixture = FlowCoordinatorTestFixture()
    }

    @MainActor func testStart_verifyInitialNavigationStack() throws {
        let appFlowCoordinator = self.makeAndStartTestAppFlowCoordinator(self.testFixture)
        let rootViewController = appFlowCoordinator.rootViewController
        XCTAssert(rootViewController is UITabBarController)

        let viewControllers = (rootViewController as? UITabBarController)?.viewControllers ?? []
        XCTAssertEqual(2, viewControllers.count)

        XCTAssert(viewControllers[0] is HomeViewController)
        let tab2VC = viewControllers[1]
        XCTAssert(tab2VC is UINavigationController)
        let tab2RootVC = (tab2VC as? UINavigationController)?.topViewController
        XCTAssert(tab2RootVC is ProfileListViewController)
    }

    @MainActor func testSelectTab_verifyTabIsSelectedAndStateIsUpdated() throws {
        let testFixture = self.testFixture
        let appState = testFixture.appState
        let appFlowCoordinator = self.makeAndStartTestAppFlowCoordinator(testFixture)
        assertTab(.home, isSelectedBy: appFlowCoordinator)
        XCTAssertEqual(Tab.home, appState.routing.selectedTab)

        var updatedTab: Tab?
        let expectation = self.expectation(description: "State Updated")

        appState.$routing
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { routing in
                updatedTab = routing.selectedTab
                expectation.fulfill()
            }
            .store(in: &cancellables)

        appFlowCoordinator.selectTab(.profile)

        wait(for: [expectation], timeout: 2)

        assertTab(.profile, isSelectedBy: appFlowCoordinator)
        XCTAssertEqual(Tab.profile, updatedTab)
        XCTAssertEqual(Tab.profile, appState.routing.selectedTab)
    }

    @MainActor func testPresentProfile_verifyProfileTabIsSelected() throws {
        let appFlowCoordinator = self.makeAndStartTestAppFlowCoordinator(self.testFixture)
        assertTab(.home, isSelectedBy: appFlowCoordinator)
        appFlowCoordinator.presentProfile(profileID: "1")
        assertTab(.profile, isSelectedBy: appFlowCoordinator)
    }

    @MainActor private func assertTab(_ tab: Tab, isSelectedBy appFlowCoordinator: AppFlowCoordinator, file: StaticString = #file, line: UInt = #line) {
        guard let tabBarController = appFlowCoordinator.rootViewController as? UITabBarController else {
            XCTFail("Expected rootViewController to be UITabBarController", file: file, line: line)
            return
        }
        let selectedTabBarItem = tabBarController.tabBar.items?[tabBarController.selectedIndex]
        XCTAssertEqual(tab.rawValue, selectedTabBarItem?.tag, "Selected tab tag [\(selectedTabBarItem?.tag ?? -1)] does not match `\(tab)` [\(tab.rawValue)]", file: file, line: line)
    }
}
