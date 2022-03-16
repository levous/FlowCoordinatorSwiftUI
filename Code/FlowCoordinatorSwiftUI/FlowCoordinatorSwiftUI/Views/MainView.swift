//
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/11/22.
//

import FlowCoordinatorShared
import SwiftUI

struct MainView: View {

    @EnvironmentObject private var appState: AppState
    private let profileListViewModel = ProfileListView.ProfileListViewModel()

    var showErrorBinding: Binding<Bool> {
        Binding(
            get: { appState.userAlert != nil },
            set: { if !$0 { appState.userAlert = nil } }
        )
    }

    var body: some View {
        TabView(selection: $appState.routing.selectedTab) {

            HomeView().tabItem{ Label("Home", systemImage: "house") }
            .tag(Tab.home)

            profileTab.tabItem { Label("Profile", systemImage: "person") }
            .tag(Tab.profile)

        }
        .foregroundColor(.blue)
        .alert(isPresented: showErrorBinding) {
            //Alert(title: appState.errorAlert?.title, message: Text(appState.errorAlert?.message), dismissButton: .default(Text("OK")))
            Alert(title: Text("This"), message: Text("That"), dismissButton: .default(Text("OK")))
        }
    }

    private var profileTab: some View {
        NavigationView {
            ProfileListView(viewModel: profileListViewModel)
                .onAppear {
                    profileListViewModel.loadProfiles()
                }
        }
    }
}

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

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.appState.routing.selectedTab = .profile
                    self.appFlowCoordinator.presentProfile(profileID: "1")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                    self.appFlowCoordinator.presentProfile(profileID: "2")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
                    self.appFlowCoordinator.presentProfile(profileID: "1")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8)) {
                    self.appState.routing.selectedTab = .home
                }
            }
        }
        .buttonStyle(BorderedButtonStyle()).tint(.blue)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewEnvironment()
    }
}
