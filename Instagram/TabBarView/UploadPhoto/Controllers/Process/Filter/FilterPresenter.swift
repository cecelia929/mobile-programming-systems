//
//  FilterPresenter.swift
//  Instagram
//
//  Created by Zhou Ti on 22/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FilterPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var viewController: FilterViewController?
    let datasource: FilterDataSource = FilterDataSource()
    var image: UIImage?

    init(viewController: FilterViewController?) {
        super.init()
        self.viewController = viewController
    }


    func fill(image: UIImage, selectedIndex: Int) {
        self.image = image
        datasource.fill(image: image, selectedIndex: selectedIndex)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fill(image: self.image!, selectedIndex: indexPath.row)
        Util.triggerNotification(name: "filterLoad", withData: [:])
        Util.selectionFeedback()
    }
}
