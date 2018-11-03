//
//  LikeViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 9/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController {

    @IBOutlet weak var collect: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResult: UILabel!
    let refreshControl = UIRefreshControl()
    var presenter: LikePresenter!
    var id: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetBackBarItem()
        collect.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refillSelctor), for: .valueChanged)

        setup()
        refillSelctor()
    }

    func resetBackBarItem (){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    @objc func refillSelctor() {
        presenter.fill(id: self.id)
    }

    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }

    func stopLoadingIndicator() {
        self.loadingIndicator.stopAnimating()
    }

    func startLoadingIndicator() {
        self.loadingIndicator.startAnimating()
    }

    func refresh() {
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }
    
    func setNoResultButton(show: Bool) {
        self.noResult.isHidden = !show
    }
    
    func performUserDetailSegue(username: String) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pushprofile") as! ProfileViewController
        vc.username = username
        vc.pushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func setup() {
        presenter = LikePresenter(vc: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
    }

}
