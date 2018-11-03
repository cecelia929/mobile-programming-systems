//
//  SortPopOverViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 19/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class SortPopOverViewController: UIViewController {
    var vc: UserFeedViewController!

    @IBAction func sortByLocation(_ sender: UIButton) {
        vc.sort = "location"
        vc.refillSelector()
        vc.dismissPopOver()
    }

    @IBAction func sortByTime(_ sender: UIButton) {
        vc.sort = "time"
        vc.refillSelector()
        vc.dismissPopOver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
