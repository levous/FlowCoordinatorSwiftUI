//
//  SplashScreenViewController.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet private var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator?.startAnimating()
    }

}

extension SplashScreenViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        "SplashScreen"
    }
}
