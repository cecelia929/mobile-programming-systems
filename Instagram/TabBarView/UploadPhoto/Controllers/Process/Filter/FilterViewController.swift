//
//  FilterViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 21/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var collect: UICollectionView!

    var image: UIImage?
    var presenter: FilterPresenter!


    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(loadFilter), name: NSNotification.Name(rawValue: "filterLoad"), object: nil)

        setup()
        presenter.fill(image: self.image!, selectedIndex: 0)
        collect.reloadData()
    }

    func setup() {
        presenter = FilterPresenter(viewController: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
    }

    @objc func loadFilter(notification: NSNotification) {
        //reload data here
        self.collect.reloadData()
    }

}
