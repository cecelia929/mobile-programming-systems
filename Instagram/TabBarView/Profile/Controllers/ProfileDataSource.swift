//
//  ProfileDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 2/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class ProfileDataSource: NSObject, UICollectionViewDataSource {

    var photos: [String] = []

    func fill(photos: [String]) {
        self.photos = photos
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! ProfileCell
        let photo = self.photos[indexPath.item]
        cell.fill(with: photo)
        return cell
    }

}
