//
//  YouViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class YouViewController: UIViewController {

    @IBOutlet weak var collect: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResult: UILabel!

    let refreshControl = UIRefreshControl()
    var presenter: YouPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        collect.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refillSelctor), for: .valueChanged)

        setup()
        presenter.fill()
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }

    func performUserDetailSegue(username: String) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pushprofile") as! ProfileViewController
        vc.username = username
        vc.pushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func performPhotoDetailSegue(id: Int) {
        let storyboard = UIStoryboard(name: "UserFeed", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pushuserfeed") as! UserFeedViewController
        vc.id = id
        vc.pushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func refillSelctor() {
        presenter.fill()
    }

    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }

    func stopLoadingIndicator() {
        self.loadingIndicator.stopAnimating()
    }

    func refresh() {
        //reload data here
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }

    func setNoResultButton(show: Bool) {
        self.noResult.isHidden = !show
    }

    func setup() {
        presenter = YouPresenter(vc: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
    }

}
