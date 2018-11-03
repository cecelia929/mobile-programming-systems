//
//  YouPresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class YouPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var vc: YouViewController?
    var datasource: YouDataSource?

    var imageNumList: [[Int]] = []

    init(vc: YouViewController?) {
        super.init()
        self.vc = vc
        self.datasource = YouDataSource(vc: vc, presenter: self)
    }

    func setImageNumberList(list: [[Int]]) {
        self.imageNumList = list
    }

    func fill() {
        datasource!.fill()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionNum = indexPath.section
        let imgSize = self.imageNumList[sectionNum]
        let itemId = indexPath.item
        if imgSize.count > 0 {
            if itemId < imgSize.count {
                if imgSize[itemId] > 1 {
                    return CGSize(width: collectionView.frame.width, height: 102)
                }
                return CGSize(width: collectionView.frame.width, height: 55)
            }
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
