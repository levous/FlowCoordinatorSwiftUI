//
//  ProfileViewController.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import FlowCoordinatorShared
import Foundation
import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    @MainActor func profileViewControllerDelegateDidDisappear()
}

class ProfileViewController: UIViewController {

    @IBOutlet private var profileImageView: UIImageView?
    weak var delegate: ProfileViewControllerDelegate?

    var profile: PersonProfile? {
        didSet {
            configureProfileImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutSubviews()
        configureProfileImage()
        clipProfileImageToCircle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.profileViewControllerDelegateDidDisappear()
    }

    private func configureProfileImage() {
        guard let profile = self.profile else {
            self.profileImageView?.image =  UIImage(systemName: "person")
            return
        }
        self.profileImageView?.image = UIImage(named: profile.imageName)
    }

    private func clipProfileImageToCircle() {
        guard let profileImageView = self.profileImageView else {
            Logger.logError("profileImage outlet not connected to storyboard")
            return
        }

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true

        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
}

extension ProfileViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        "Profile"
    }
}
