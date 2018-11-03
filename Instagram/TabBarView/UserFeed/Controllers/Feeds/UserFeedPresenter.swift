//
//  UserFeedPresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 18/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@available(iOS 10.0, *)
class UserFeedPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var vc: UserFeedViewController?
    var datasource: UserFeedDataSource?
    var imageSizeArray: [[String: Int]] = []
    var firstCommentArray: [Bool] = []

    init(vc: UserFeedViewController?) {
        super.init()
        self.vc = vc
        self.datasource = UserFeedDataSource(vc: vc, presenter: self)
    }

    func updateArrays(imageSizeArray: [[String: Int]], firstCommentArray: [Bool]) {
        self.imageSizeArray = imageSizeArray
        self.firstCommentArray = firstCommentArray
    }

    func fill(id: Int, hosted: Bool, sort: String) {
        datasource!.fill(id: id, hosted: hosted, sort: sort)
    }

    func triggerShareButton() {
        datasource!.triggerShareButton()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        vc?.performUserDetailSegue(id: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.imageSizeArray.count > 0 {
            if indexPath.row < imageSizeArray.count {
                let size = self.imageSizeArray[indexPath.row]
                let screenSize = UIScreen.main.bounds
                let realHeight = screenSize.width / CGFloat(size["width"]!) * CGFloat(size["height"]!)
                if !self.firstCommentArray[indexPath.row] {
                    return CGSize(width: collectionView.frame.width, height: realHeight + 195)
                }
                return CGSize(width: collectionView.frame.width, height: realHeight + 236)
            }
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
