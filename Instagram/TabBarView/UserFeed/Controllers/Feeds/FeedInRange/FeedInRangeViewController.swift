//
//  FeedInRangeViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 29/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FeedInRangeViewController: UIViewController {

    var presenter: FeedInRangePresenter!
    var datasource: FeedInRangeDataSource!
    @IBOutlet weak var collect: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        NotificationCenter.default.addObserver(self, selector: #selector(inrangeReload), name: NSNotification.Name(rawValue: "inrangeLoad"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fill), name: NSNotification.Name(rawValue: "inrangeAppend"), object: nil)

        setup()
    }

    func setup() {
        presenter = FeedInRangePresenter(viewController: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
    }

    @objc func fill(notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            presenter.fill(dict: dict["dict"] as! NSDictionary)
        }
    }

    @objc func inrangeReload(){
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }
}
