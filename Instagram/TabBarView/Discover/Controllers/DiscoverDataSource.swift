//
//  DiscoverDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 8/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire

class DiscoverDataSource: NSObject, UICollectionViewDataSource {
    var discovers: [[String: Any]] = []
    var vc: DiscoverViewController!
    var presenter: DiscoverPresenter!

    init(vc: DiscoverViewController?, presenter: DiscoverPresenter) {
        super.init()
        self.vc = vc
        self.presenter = presenter
    }

    func fill(type: String?) {
        var url: String
        var parameters: [String: Any]
        if (type == nil) {
            print("suggested")
            url = Constants.URL + "/api/discover/suggested"
            parameters = [
                "username": UserDefaults.standard.string(forKey: "username") ?? ""
            ]
        } else {
            print("search")
            url = Constants.URL + "/api/discover/search"
            parameters = [
                "username": UserDefaults.standard.string(forKey: "username") ?? "",
                "search": type!
            ]
        }

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resData = ((res as AnyObject)["data"]) {
                    self.discovers = resData as! [[String: Any]]
                    if self.discovers.count > 0 {
                        self.vc.setFilled(filled: true)
                        self.vc.setNoResultButton(show: false)
                    } else {
                        self.vc.setFilled(filled: false)
                        self.vc.setNoResultButton(show: true)
                    }
                    self.vc.refresh()
                    self.vc.stopLoadingIndicator()
                    self.vc.endRefreshing()
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.discovers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoverCell", for: indexPath) as! DiscoverCell
        registerTapGestures(cell: cell)
        let discover = self.discovers[indexPath.item]
        cell.fill(with: discover)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let discoverReusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "discoverreusable", for: indexPath) as! DiscoverCollectionReusableView
        if self.discovers.count == 0 {
            discoverReusable.suggested = ""
            return discoverReusable
        }
        discoverReusable.suggested = "Suggested"
        return discoverReusable
    }

    @objc func didTapAvatar(_ sender: UITapGestureRecognizer) {
        let avatar: UIImageView = sender.view as! UIImageView
        vc?.performUserDetailSegue(username: avatar.accessibilityIdentifier ?? "")
    }

    @objc func didTapText(_ sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view as! UILabel
        vc?.performUserDetailSegue(username: label.text ?? "")
    }

    func registerTapGestures(cell: DiscoverCell) {
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarTap.numberOfTapsRequired = 1
        avatarTap.numberOfTouchesRequired = 1
        cell.avatar.addGestureRecognizer(avatarTap)
        cell.avatar.isUserInteractionEnabled = true

        let usernameTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        usernameTap.numberOfTapsRequired = 1
        usernameTap.numberOfTouchesRequired = 1

        cell.username.addGestureRecognizer(usernameTap)
        cell.username.isUserInteractionEnabled = true
    }
}
