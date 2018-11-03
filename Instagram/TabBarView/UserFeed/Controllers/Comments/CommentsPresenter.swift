//
//  CommentsPresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 20/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class CommentsPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var vc: CommentsViewController?
    var datasource: CommentsDataSource?

    init(vc: CommentsViewController?) {
        super.init()
        self.vc = vc
        self.datasource = CommentsDataSource(vc: vc, presenter: self)
    }

    func fill(_ id: Int) {
        datasource!.fill(id)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
}
