//
//  ServiceFactory.swift
//  
//
//  Created by Rusty Zarse on 3/12/22.
//

public protocol ServiceFactory {
    func profileService() -> ProfileService
}

public struct AppServiceFactory: ServiceFactory {

    public init() { }
    
    public func profileService() -> ProfileService {
        InMemoryProfileService(seedWith: SeedData.profiles)
    }
}

public enum SeedData {
    public static let profiles: [PersonProfile] = [
        PersonProfile(profileID: "1", imageName: "profile1"),
        PersonProfile(profileID: "2", imageName: "profile2")
    ]

    public static let additionalProfile = PersonProfile(profileID: "99", imageName: "profile3")
}
