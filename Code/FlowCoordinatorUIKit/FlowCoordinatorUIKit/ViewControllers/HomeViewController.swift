//
//  HomeViewController.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    @MainActor func homeViewControllerButton(_:UIButton, didTapWithProfileID profileID: String)
    @MainActor func homeViewControllerUpdateStateButtonButtonTapped()
}

class HomeViewController: UIViewController {

    @IBAction private func showProfileButton1Tapped(_ button: UIButton) {
        delegate?.homeViewControllerButton(button, didTapWithProfileID: "1")
    }

    @IBAction private func showProfileButton2Tapped(_ button: UIButton) {
        delegate?.homeViewControllerButton(button, didTapWithProfileID: "2")
    }

    @IBAction private func updateStateButtonTapped(_ button: UIButton) {
        delegate?.homeViewControllerUpdateStateButtonButtonTapped()
    }

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension HomeViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        "Home"
    }
}
