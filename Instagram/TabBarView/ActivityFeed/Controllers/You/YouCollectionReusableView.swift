//
//  YouCollectionReusableView.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class YouCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var timePeriodLabel: UILabel!

    var timePeriod: String! {
        didSet {
            timePeriodLabel.text = timePeriod
        }
    }
}
