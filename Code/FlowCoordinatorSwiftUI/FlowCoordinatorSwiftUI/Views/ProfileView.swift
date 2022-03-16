//
//  ProfileView.swift
//  FlowCoordinatorSwiftUI
//
//  Created by Rusty Zarse on 3/12/22.
//

import SwiftUI
import FlowCoordinatorShared

struct ProfileView: View {

    let profile: PersonProfile

    var body: some View {
        Image(profile.imageName)
            .resizable()
            .frame(width: 300.0, height: 300.0)
            .clipShape(Circle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: PreviewState().profile)
    }
}
