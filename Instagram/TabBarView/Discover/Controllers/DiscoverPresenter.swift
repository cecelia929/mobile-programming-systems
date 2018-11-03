//
//  DiscoverPresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 8/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class DiscoverPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var vc: DiscoverViewController?
    var datasource: DiscoverDataSource?
    var type: String?

    init(vc: DiscoverViewController?) {
        super.init()
        self.vc = vc
        self.datasource = DiscoverDataSource(vc: vc, presenter: self)
    }

    func fill(type: String?) {
        self.type = type
        datasource!.fill(type: type)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.type == nil {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}
