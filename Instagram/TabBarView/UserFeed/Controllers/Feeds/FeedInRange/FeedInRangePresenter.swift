//
//  FeedInRangePresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 29/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FeedInRangePresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var viewController: FeedInRangeViewController?
    let datasource: FeedInRangeDataSource = FeedInRangeDataSource()
    var inrangeDicts: [NSDictionary] = []

    init(viewController: FeedInRangeViewController?) {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(updateArrays), name: NSNotification.Name(rawValue: "updateInrangeArray"), object: nil)
        self.viewController = viewController
    }

    @objc func updateArrays(notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            if let dicts = dict["dict"] {
                self.inrangeDicts = dicts as! [NSDictionary]
            }
        }
    }

    func fill(dict: NSDictionary){
        datasource.fill(dict: dict)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.inrangeDicts.count > 0 {
            let size = self.inrangeDicts[indexPath.row]
            let screenSize = UIScreen.main.bounds
            let realHeight = screenSize.width / CGFloat(size["width"] as! Int) * CGFloat(size["height"] as! Int)
            return CGSize(width: collectionView.frame.width, height: realHeight)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
