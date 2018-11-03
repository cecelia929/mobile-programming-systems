//
//  ProfileCell.swift
//  Instagram
//
//  Created by Zhou Ti on 2/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!

    override func prepareForReuse() {
        self.photo.image = nil
        super.prepareForReuse()
    }

    func fill(with photo: String) {
        let imageURL: URL = URL(string: photo)!
        self.photo.af_setImage(withURL: imageURL)
    }
}
