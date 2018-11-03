//
//  ProfilePresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 2/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class ProfilePresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var viewController: ProfileViewController?
    let datasource: ProfileDataSource = ProfileDataSource()
    var ids: [Int]!

    init(viewController: ProfileViewController?) {
        super.init()
        self.viewController = viewController
    }

    func fill(photos: [String], ids: [Int]) {
        self.ids = ids
        datasource.fill(photos: photos)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = CGFloat((collectionView.frame.width - 1.5) / 3.0)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.performPhotoDetailSegue(id: self.ids[indexPath.row])
    }
}
