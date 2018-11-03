//
//  DiscoverCollectionReusableView.swift
//  Instagram
//
//  Created by Zhou Ti on 8/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class DiscoverCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var suggestedLabel: UILabel!

    var suggested: String! {
        didSet {
            suggestedLabel.text = suggested
        }
    }
}
