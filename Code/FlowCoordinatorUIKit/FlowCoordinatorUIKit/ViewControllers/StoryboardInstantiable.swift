//
//  StoryboardInstantiable.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import UIKit

/// Provide a simple interface for instantiating the view controller from a storyboard.
protocol StoryboardInstantiable: AnyObject {
    /// The name of the storyboard containing the VC's view.
    static var storyboardName: String { get }

    /// The identifier in `storyboardName` corresponding to the VC.
    static var storyboardIdentifier: String { get }

    /// The default implementation should suffice, unless you need to set the bundle.
    @MainActor static func instantiateFromStoryboard() -> Self
}

extension StoryboardInstantiable {

    /// Default storyboard name
    static var storyboardName: String { "Main" }

    /// Instantiate the view controller that conforms to this protocol from its configured storyboard.
    ///
    /// - Returns: The instantiated view controller
    @MainActor static func instantiateFromStoryboard() -> Self {
        guard let controller = UIStoryboard(
            name: storyboardName,
            bundle: Bundle(for: Self.self)
        ).instantiateViewController(
            withIdentifier: storyboardIdentifier
        ) as? Self else {
            fatalError("Failed to instantiate view controller with identifier \(storyboardIdentifier) from \(storyboardName).storyboard")
        }
        return controller
    }
}
