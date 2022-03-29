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
            errorAlert
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

    private var errorAlert: Alert {
        if let title = appState.userAlert?.title,
           let message = appState.userAlert?.message {
            return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
        } else {
            return Alert(title: Text("Uh oh"), message: Text("Something went wrong but I couldn't find the details"), dismissButton: .default(Text("OK")))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewEnvironment()
    }
}
