//
//  FollwingPresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FollowingPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var vc: FollowingViewController?
    var datasource: FollowingDataSource?

    var imageNumList: [Int] = []

    init(vc: FollowingViewController?) {
        super.init()
        self.vc = vc
        self.datasource = FollowingDataSource(vc: vc, presenter: self)
    }

    func fill() {
        datasource!.fill()
    }

    func setImageNumberList(list: [Int]) {
        self.imageNumList = list
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.imageNumList.count > 0 {
            if indexPath.row < imageNumList.count {
                if imageNumList[indexPath.row] > 1 {
                    return CGSize(width: collectionView.frame.width, height: 102)
                }
                return CGSize(width: collectionView.frame.width, height: 55)
            }
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
