//
//  FeedInRangeCell.swift
//  Instagram
//
//  Created by Zhou Ti on 29/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import AlamofireImage

class FeedInRangeCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
    }


    func fill(with dict: NSDictionary) {
        let width = dict["width"] as! Int
        let height = dict["height"] as! Int
        let url = dict["URL"] as! URL
        let screenSize = UIScreen.main.bounds
        let realHeight: CGFloat = screenSize.width / CGFloat(width) * CGFloat(height)
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: realHeight)
        imageView.af_setImage(withURL: url)
    }
}
