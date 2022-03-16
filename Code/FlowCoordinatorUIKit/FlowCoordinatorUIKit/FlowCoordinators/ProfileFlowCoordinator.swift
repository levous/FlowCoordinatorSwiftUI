//
//  ProfileFlowCoordinator.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import Combine
import FlowCoordinatorShared
import Foundation
import UIKit

@MainActor class ProfileFlowCoordinator: FlowCoordinator {
    private(set) var rootViewController: UIViewController
    private let appState: AppState
    private let profileService: ProfileService
    private var subscriptions: [AnyCancellable] = []

    /// Convenience property to cast `rootViewController` to `UINavigationController`
    private var navigationController: UINavigationController {
        guard let navController = rootViewController as? UINavigationController else {
            preconditionFailure("rootViewController must be a UINavigationController")
        }
        return navController
    }

    // MARK: - init

    init(appState: AppState, profileService: ProfileService) {
        self.appState = appState
        self.profileService = profileService
        self.rootViewController = SplashScreenViewController.instantiateFromStoryboard()
    }

    // MARK: - Start Coordinated Flow

    /// entry point for Flow Coordinator
    func start() {
        rootViewController = UINavigationController(
            rootViewController: configureProfileListViewController()
        )

        subscribeToAppState()
    }

    private func subscribeToAppState() {
        appState
            .$routing
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] routing in
            guard let self = self else { return }
            if let profileID = routing.selectedProfileID {
                self.pushProfileController(profileID: profileID)
            }
        }.store(in: &subscriptions)
    }

    // MARK: - Navigation

    func presentProfile(profileID: String) {
        guard presentedProfileID() != profileID else {
            // already presented
            return
        }

        // update state then let subscription trigger pushProfileController
        appState.routing.selectedProfileID = profileID
    }

    func presentError(_ message: String, error: Error?) {
        let alert = UIAlertController(title: "So Sorry…", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.rootViewController.present(alert, animated: true, completion: nil)
    }

    // MARK: - View Controller Actions

    private func pushProfileController(profileID: String) {
        guard presentedProfileID() != profileID else { return }

        self.navigationController.popToRootViewController(animated: true)

        Task {
            do {
                let profile = try await profileService.profile(profileID: profileID)
                let profileController = self.configureProfileViewController(profile: profile)
                self.navigationController.pushViewController(profileController, animated: true)
            } catch {
                appState.routing.selectedProfileID = nil
                presentError("I could not present the profile", error: error)
            }
        }
    }

    private func presentedProfileID() -> String? {
        guard let profileViewController = self.navigationController.topViewController as? ProfileViewController,
            let profile = profileViewController.profile else { return nil }
        return profile.profileID
    }

    // MARK: - View Controller Configuration

    private func configureProfileListViewController() -> UIViewController {
        let profileController = ProfileListViewController.instantiateFromStoryboard()
        profileController.delegate = self
        profileController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addProfileToListViewController)
        )
        Task {
            profileController.profiles = await profileService.profiles()
        }
        return profileController
    }

    @objc private func addProfileToListViewController() {
        guard let viewController = navigationController
                .viewControllers
                .first(where: { $0 is ProfileListViewController }),
              let profileListController = viewController as? ProfileListViewController else {
                    return
              }

        let profile = SeedData.additionalProfile
        Task {
            await profileService.addProfile(profile)
            profileListController.profiles.append(profile)
            profileListController.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    private func configureProfileViewController(profile: PersonProfile) -> UIViewController {
        let profileController = ProfileViewController.instantiateFromStoryboard()
        profileController.delegate = self
        profileController.profile = profile
        return profileController
    }
}

extension ProfileFlowCoordinator: ProfileListViewControllerDelegate {
    func profileListViewControllerDelegateDidSelectProfile(_ profileID: String) {
        presentProfile(profileID: profileID)
    }
}

extension ProfileFlowCoordinator: ProfileViewControllerDelegate {
    func profileViewControllerDelegateDidDisappear() {
        appState.routing.selectedProfileID = nil
    }
}

