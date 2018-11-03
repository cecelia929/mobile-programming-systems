//
//  LikeDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 9/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire

class LikeDataSource: NSObject, UICollectionViewDataSource {
    var likes: [[String: Any]] = []
    var vc: LikeViewController!
    var presenter: LikePresenter!

    init(vc: LikeViewController?, presenter: LikePresenter) {
        super.init()
        self.vc = vc
        self.presenter = presenter
    }

    func fill(id: Int) {
        var url: String
        var parameters: [String: Any]

        url = Constants.URL + "/api/userfeed/like"
        parameters = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "photo_id": id
        ]

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resData = ((res as AnyObject)["data"]) {
                    self.likes = resData as! [[String: Any]]
                    if self.likes.count > 0 {
                        self.vc.setNoResultButton(show: false)
                    } else {
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
        return self.likes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likeCell", for: indexPath) as! LikeCell
        cell.vc = self.vc
        registerTapGestures(cell: cell)
        let Like = self.likes[indexPath.item]
        cell.fill(with: Like)
        return cell
    }


    @objc func didTapAvatar(_ sender: UITapGestureRecognizer) {
        let avatar: UIImageView = sender.view as! UIImageView
        vc?.performUserDetailSegue(username: avatar.accessibilityIdentifier ?? "")
    }

    @objc func didTapText(_ sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view as! UILabel
        vc?.performUserDetailSegue(username: label.text ?? "")
    }

    func registerTapGestures(cell: LikeCell) {
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
