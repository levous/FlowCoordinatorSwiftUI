//
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import Combine
import FlowCoordinatorShared
import Foundation
import UIKit

@MainActor class AppFlowCoordinator: FlowCoordinator {
    private var window: UIWindow?
    private(set) var rootViewController: UIViewController
    private let appState: AppState
    private var tabBarDelegate: TabBarControllerDelegate?
    private var subscriptions: [AnyCancellable] = []

    // Child Flow Coordinators
    private let profileFlowCoordinator: ProfileFlowCoordinator

    /// Convenience property to cast `rootViewController` to `UINavigationController`
    private var tabBarController: UITabBarController {
        guard let tabBarController = rootViewController as? UITabBarController else {
            preconditionFailure("rootViewController must be a UITabBarController")
        }
        return tabBarController
    }

    // MARK: - init

    init(appState: AppState = AppState(), serviceFactory: ServiceFactory = AppServiceFactory()) {
        self.appState = appState
        self.rootViewController = SplashScreenViewController.instantiateFromStoryboard()
        self.profileFlowCoordinator = ProfileFlowCoordinator(appState: appState, profileService: serviceFactory.profileService())
    }

    /// entry point for `SceneCoordinator`
    func configure(with window: UIWindow) {
        self.window = window
    }

    // MARK: - Start Coordinated Flow

    func start() {
        let window = windowOrLogAndFail()
        rootViewController = configureTabBarController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        subscribeToAppState()
    }

    private func subscribeToAppState() {
        appState
            .$routing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routing in
                guard let self = self else { return }
                self.handleRouting(routing)
            }.store(in: &subscriptions)
    }

    private func handleRouting(_ routing: Routing) {
        if routing.selectedTab.rawValue != self.tabBarController.tabBar.selectedItem?.tag {
            self.selectTabControllerTab(routing.selectedTab)
        }
    }


    // MARK: - Navigation

    /// Selects the tab if it is present in the `tabBarController`
    func selectTab(_ tab: Tab) {
        appState.routing.selectedTab = tab
        // subscription to state will call back through but will not select the tab again 
        selectTabControllerTab(tab)
    }

    private func selectTabControllerTab(_ tab: Tab) {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(where: {
            $0.tabBarItem.tag == tab.rawValue
        }) else {
            Logger.logError("Tab \(tab) not present in UITabController")
            return
        }
        guard selectedIndex != tabBarController.selectedIndex else { return }
        tabBarController.selectedIndex = selectedIndex
    }

    /// Selects the profile tab and initiates profile flow with `profileID`
    func presentProfile(profileID: String) {
        selectTab(.profile)
        profileFlowCoordinator.presentProfile(profileID: profileID)
    }

    // MARK: - View Controller Configuration

    private func configureTabBarController() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = Tab.allCases.map{ configureTab($0) }
        // configure a delegate to respond to user initiated tab taps
        let delegate = TabBarControllerDelegate { [weak self] tab in
            // ensure state reflects the updated tab selection
            self?.selectTab(tab)
        }
        tabBarController.delegate = delegate
        // keep a reference because delegate is not retained
        self.tabBarDelegate = delegate
        return tabBarController
    }

    private func configureTab(_ tab: Tab) -> UIViewController {
        let viewController: UIViewController
        switch tab {
        case .home:
            viewController = configureHomeViewController()
        case .profile:
            viewController = configureProfileTabViewController()
        }

        viewController.tabBarItem = tab.tabBarItem
        return viewController
    }

    private func configureHomeViewController() -> UIViewController {
        let homeController = HomeViewController.instantiateFromStoryboard()
        homeController.delegate = self
        return homeController
    }

    private func configureProfileTabViewController() -> UIViewController {
        profileFlowCoordinator.start()
        return profileFlowCoordinator.rootViewController
    }
}

extension AppFlowCoordinator: HomeViewControllerDelegate {
    func homeViewControllerButton(_: UIButton, didTapWithProfileID profileID: String) {
        presentProfile(profileID: profileID)
    }

    func homeViewControllerUpdateStateButtonButtonTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.appState.routing.selectedTab = .profile
            self.appState.routing.selectedProfileID = "1"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            self.appState.routing.selectedProfileID = "2"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            self.appState.routing.selectedProfileID = "1"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8)) {
            self.appState.routing.selectedTab = .home
        }
    }
}

/// Implemented as a distinct class because `UITabBarControllerDelegate` must inherit from `NSObject`
private class TabBarControllerDelegate: NSObject, UITabBarControllerDelegate {

    private let didSelectTab: (Tab) -> Void

    init(_ onSelect: @escaping (Tab) -> Void) {
        self.didSelectTab = onSelect
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tab = Tab(rawValue: viewController.tabBarItem.tag) else { return }
        didSelectTab(tab)
    }
}

extension AppFlowCoordinator {
    // MARK: - Utility
    /// Returns the window or logs that it's missing
    private func windowOrLogAndFail(function: String = #function) -> UIWindow {
        guard let window = self.window else {
            Logger.logError("\(function) needs a window but it is unexpectedly nil")
            fatalError("Cannot continue without a window.  Did you forget to call `configure(with:)` prior to `start()`?")
        }
        return window
    }
}
