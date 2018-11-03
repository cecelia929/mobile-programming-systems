//
//  LikePresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 9/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class LikePresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var vc: LikeViewController?
    var datasource: LikeDataSource?

    init(vc: LikeViewController?) {
        super.init()
        self.vc = vc
        self.datasource = LikeDataSource(vc: vc, presenter: self)
    }

    func fill(id: Int) {
        datasource!.fill(id: id)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}
