//
//  Tab+extensions.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import FlowCoordinatorShared
import UIKit

extension Tab {
    /// Returns the styled `UITabBarItem` for the case
    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(
                title: NSLocalizedString("Home", comment: "Title for Home tab"),
                image: UIImage(systemName: "house"),
                tag: self.rawValue
            )
        case .profile:
            return UITabBarItem(
                title: NSLocalizedString("Profile", comment: "Title for Profile tab"),
                image: UIImage(systemName: "person"),
                tag: self.rawValue
            )
        }
    }
}
