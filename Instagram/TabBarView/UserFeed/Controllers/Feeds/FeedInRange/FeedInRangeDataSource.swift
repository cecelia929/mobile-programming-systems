//
//  FeedInRangeDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 29/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FeedInRangeDataSource: NSObject, UICollectionViewDataSource {

    var inRangeFeeds: [NSDictionary] = []

    func fill(dict: NSDictionary){
        self.inRangeFeeds.append(dict)
        Util.triggerNotification(name: "updateInrangeArray", withData: ["dict": self.inRangeFeeds])
        Util.triggerNotification(name: "inrangeLoad", withData: [:])
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inrangecell", for: indexPath) as! FeedInRangeCell
        let inRangeFeed = self.inRangeFeeds[indexPath.item]
        cell.fill(with: inRangeFeed)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inRangeFeeds.count
    }
}
