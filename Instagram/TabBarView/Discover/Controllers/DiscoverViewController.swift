//
//  DiscoverViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 11/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collect: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResult: UILabel!


    var type: String? = nil
    let refreshControl = UIRefreshControl()
    var presenter: DiscoverPresenter!
    var filled: Bool = false
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        collect.refreshControl = refreshControl
        collect.keyboardDismissMode = .onDrag
        refreshControl.addTarget(self, action: #selector(refillSelctor), for: .valueChanged)

        setup()
        refillSelctor()
    }

    func setupSearchBar() {
        self.searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.black
        navigationItem.titleView = searchBar
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.type = nil
        } else {
            self.type = searchBar.text
        }
        if !filled {
            setNoResultButton(show: false)
            startLoadingIndicator()
        }
        self.refillSelctor()
        searchBar.setShowsCancelButton(true, animated: true)
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            self.type = searchBar.text
        } else {
            self.type = nil
        }
        if !filled {
            setNoResultButton(show: false)
            startLoadingIndicator()
        }
        self.refillSelctor()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.type = nil
        self.refillSelctor()
        searchBar.endEditing(true)
    }

    func setFilled(filled: Bool) {
        self.filled = filled
    }

    func setNoResultButton(show: Bool) {
        self.noResult.isHidden = !show
    }

    @objc func refillSelctor() {
        presenter.fill(type: self.type)
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
        //reload data here
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }

    func setup() {
        presenter = DiscoverPresenter(vc: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
    }

    func performUserDetailSegue(username: String) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pushprofile") as! ProfileViewController
        vc.username = username
        vc.pushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
