//
//  ProfileFlowCoordinatorTests.swift
//  FlowCoordinatorUIKitTests
//
//  Created by Rusty Zarse on 3/11/22.
//

import Combine
import FlowCoordinatorShared
import XCTest
@testable import FlowCoordinatorUIKit

class MockProfileService: ProfileService {

    var profilesWasCalled: () -> Void = {}
    var profileWasCalledWithID: (String) -> Void = { _ in }

    private let internalService = MockServiceFactory().profileService()

    func profiles() async -> [PersonProfile] {
        defer { profilesWasCalled() }
        return await internalService.profiles()
    }

    func profile(profileID: String) async throws -> PersonProfile {
        defer { profileWasCalledWithID(profileID) }
        return try await internalService.profile(profileID: profileID)
    }

    func addProfile(_ profile: PersonProfile) async {
        await internalService.addProfile(profile)
    }
}


class ProfileFlowCoordinatorTests: XCTestCase {

    private var cancellables: [AnyCancellable] = []
    private var testFixture: FlowCoordinatorTestFixture = FlowCoordinatorTestFixture()
    private var profileService: MockProfileService = MockProfileService()

    @MainActor func makeAndStartTestProfileFlowCoordinator(_ testFixture: FlowCoordinatorTestFixture) -> ProfileFlowCoordinator {
        let profileFlowCoordinator = ProfileFlowCoordinator(
            appState: testFixture.appState,
            profileService: testFixture.serviceFactory.profileService()
        )
        profileFlowCoordinator.start()
        return profileFlowCoordinator
    }

    override func setUpWithError() throws {
        profileService = MockProfileService()
        testFixture = FlowCoordinatorTestFixture(profileService: profileService)
    }

    @MainActor func testPresentProfile_whenValidProfileID_profileViewControllerIsPushed() throws {
        let profileFlowCoordinator = self.makeAndStartTestProfileFlowCoordinator(self.testFixture)
        let testProfileID = "3"
        let expectation = XCTestExpectation(description: "Service Called")
        var serviceProfileID: String?
        profileService.profileWasCalledWithID = { profileID in
            serviceProfileID = profileID
            expectation.fulfill()
        }
        profileFlowCoordinator.presentProfile(profileID: testProfileID)
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(testProfileID, serviceProfileID)
        guard let navController = profileFlowCoordinator.rootViewController as? UINavigationController,
              let profileVC = navController.topViewController as? ProfileViewController else {
                  XCTFail("Navigation stack expected to have UINavigationController with ProfileViewController on top")
                  return
              }
        XCTAssertEqual(testProfileID, profileVC.profile?.profileID)
        XCTAssertEqual(testProfileID, testFixture.appState.routing.selectedProfileID)
    }
}

