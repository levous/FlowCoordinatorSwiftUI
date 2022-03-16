//
//  ProfileListViewController.swift
//  FlowCoordinatorUIKit
//
//  Created by Rusty Zarse on 3/11/22.
//

import FlowCoordinatorShared
import Foundation
import UIKit

protocol ProfileListViewControllerDelegate: AnyObject {
    @MainActor func profileListViewControllerDelegateDidSelectProfile(_ profileID: String)
}

class ProfileListViewController: UICollectionViewController {

    private enum Section: CaseIterable {
        case main
    }

    weak var delegate: ProfileListViewControllerDelegate?
    private lazy var dataSource = makeDataSource()

    var profiles: [PersonProfile] = [] {
        didSet {
            applySnapshot()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        applySnapshot(animatingDifferences: false)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let profile = dataSource.itemIdentifier(for: indexPath) {
            delegate?.profileListViewControllerDelegateDidSelectProfile(profile.profileID)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PersonProfile>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(profiles)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func configureLayout() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, PersonProfile> {
        UICollectionViewDiffableDataSource<Section, PersonProfile>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, profile) -> UICollectionViewCell? in

                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileListItemCell.reuseIdentifier,
                    for: indexPath
                ) as? ProfileListItemCell
                cell?.profile = profile
                return cell
            }
        )
    }
}

extension ProfileListViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        "ProfileList"
    }
}

class ProfileListItemCell: UICollectionViewCell {

    static let reuseIdentifier = "ProfileListItemCell"
    @IBOutlet weak var thumbnailView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?

    var profile: PersonProfile? {
        didSet {
            guard let profile = self.profile else {
                thumbnailView?.image = UIImage(systemName: "ladybug")
                titleLabel?.text = nil
                return
            }

            thumbnailView?.image = UIImage(named: profile.imageName)
            titleLabel?.text = profile.profileID
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.clipImageToCircle()
    }

    private func clipImageToCircle() {
        guard let imageView = self.thumbnailView else { return }
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
    }
}
