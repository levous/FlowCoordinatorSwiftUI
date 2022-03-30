//
//  ProfileListView.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/12/22.
//

import FlowCoordinatorShared
import SwiftUI

struct ProfileListView: View {

    @MainActor class ProfileListViewModel: ObservableObject {
        private let profileService: ProfileService

        @Published var profiles: [PersonProfile] = []

        init(profileService: ProfileService = AppServiceFactory().profileService()) {
            self.profileService = profileService
        }

        func loadProfiles() {
            Task {
                self.profiles = await profileService.profiles()
            }
        }

        func addProfile() {
            Task {
                let profile = SeedData.additionalProfile
                await profileService.addProfile(profile)
                self.profiles.append(profile)
            }
        }
    }

    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel: ProfileListViewModel

    var body: some View {
        List(viewModel.profiles) { profile in
            NavigationLink(
                tag: profile.id,
                selection: $appState.routing.selectedProfileID,
                destination: { ProfileView(profile: profile) }
            ) {
                ProfileListItemView(profile: profile)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: { viewModel.addProfile() }
                ) {
                    Image(systemName: "plus")
                }
            }
        }
        .foregroundColor(.blue)
    }
}

struct ProfileListItemView: View {

    let profile: PersonProfile

    var body: some View {
        HStack(spacing: 20) {
            ProfileThumbnailView(profile: profile)
            Text(profile.profileID)
        }
    }
}

struct ProfileThumbnailView: View {

    let profile: PersonProfile

    var body: some View {
        Image(profile.imageName)
            .resizable()
            .frame(width: 60.0, height: 60.0)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(Color.white))
    }
}


struct ProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListView(viewModel: PreviewState().profileListViewModel)
    }
}
