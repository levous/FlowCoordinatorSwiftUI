//
//  MockServiceFactory.swift
//  FlowCoordinatorUIKitTests
//
//  Created by Rusty Zarse on 3/11/22.
//

import FlowCoordinatorShared
@testable import FlowCoordinatorUIKit

struct MockServiceFactory: ServiceFactory {
    private let internalProfileService: ProfileService

    init(profileService: ProfileService? = nil) {
        self.internalProfileService = profileService ?? InMemoryProfileService(seedWith: MockData.profiles)
    }

    func profileService() -> ProfileService {
        internalProfileService
    }
}

enum MockData {
    static let profiles: [PersonProfile] = [
        PersonProfile(profileID: "1", imageName: "image1"),
        PersonProfile(profileID: "2", imageName: "image2"),
        PersonProfile(profileID: "3", imageName: "image3"),
        PersonProfile(profileID: "4", imageName: "image4"),
    ]
}
