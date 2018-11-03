//
//  FilterCell.swift
//  Instagram
//
//  Created by Zhou Ti on 22/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var filterName: UILabel!

    func fill(with filter: [String: Any]){
        self.filterName.text = (filter["filterName"] as! String)
        self.image.image = (filter["image"] as! UIImage)
        if ((filter["selected"] as! Bool)){
            filterName.textColor = UIColor.black
        }else{
            filterName.textColor = UIColor.lightGray
        }
    }

}
