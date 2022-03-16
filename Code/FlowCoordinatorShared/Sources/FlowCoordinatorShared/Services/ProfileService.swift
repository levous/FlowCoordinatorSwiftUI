//
//  File.swift
//  
//
//  Created by Rusty Zarse on 3/11/22.
//

/// Provides async profile data services
public protocol ProfileService {

    /// Fetch all available `PersonProfile`s
    func profiles() async -> [PersonProfile]

    /// Fetch the matching `PersonProfile` or throw `ServiceError.notFound`
    func profile(profileID: String) async throws -> PersonProfile

    /// Insert new `PersonProfile`
    func addProfile(_ profile: PersonProfile) async
}


/// Provides async profile data services
public class InMemoryProfileService: ProfileService {

    /// We're mocking a remote store using an in memory array
    private var inMemoryProfileStore: [PersonProfile] = []

    public init(seedWith profiles: [PersonProfile]) {
        self.inMemoryProfileStore = profiles
    }

    /// Fetch all available `PersonProfile`s
    public func profiles() async -> [PersonProfile] {
        inMemoryProfileStore
    }

    /// Fetch the matching `PersonProfile` or throw `ServiceError.notFound`
    public func profile(profileID: String) async throws -> PersonProfile {
        guard let matchingProfile = inMemoryProfileStore.first(where: {
            $0.profileID == profileID
        }) else {
            throw ServiceError.notFound
        }
        return matchingProfile
    }

    /// Insert new `PersonProfile`
    public func addProfile(_ profile: PersonProfile) async {
        inMemoryProfileStore.append(profile)
    }
}
