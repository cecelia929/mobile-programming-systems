//
//  FollowingDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire

class FollowingDataSource: NSObject, UICollectionViewDataSource {

    var followings: [[String: Any]] = []

    let url = Constants.URL + "/api/activityfeed"
    var vc: FollowingViewController!
    var presenter: FollowingPresenter!


    init(vc: FollowingViewController?, presenter: FollowingPresenter) {
        super.init()
        self.vc = vc
        self.presenter = presenter
    }

    func fill() {
        let parameters: [String: Any] = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "type": "Following"
        ]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resData = ((res as AnyObject)["data"]) {
                    self.followings = resData as! [[String: Any]]
                    if self.followings.count > 0 {
                        self.vc.setNoResultButton(show: false)
                    } else {
                        self.vc.setNoResultButton(show: true)
                    }
                    let imageNumberList = self.readImageNumber()
                    self.presenter.setImageNumberList(list: imageNumberList)
                    self.vc.refresh()
                    self.vc.stopLoadingIndicator()
                    self.vc.endRefreshing()
                }
            }
        }
    }

    func readImageNumber() -> [Int] {
        var numbers: [Int] = []
        for following in self.followings {
            if let imageIDs = following["image_id"] {
                numbers.append((imageIDs as! [NSNumber]).count)
            } else {
                numbers.append(0)
            }
        }
        return numbers
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.followings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followingCell", for: indexPath) as! FollowingCell
        registerTapGestures(cell: cell)
        let following = self.followings[indexPath.item]
        cell.fill(with: following)
        return cell
    }

    @objc func didTapAvatar(_ sender: UITapGestureRecognizer) {
        let avatar: UIImageView = sender.view as! UIImageView
        vc?.performUserDetailSegue(username: avatar.accessibilityIdentifier ?? "")
    }

    @objc func didTapImage(_ sender: UITapGestureRecognizer) {
        let image: UIImageView = sender.view as! UIImageView
        print("tapped: ", Int(image.accessibilityIdentifier ?? "0")!)
        vc.performPhotoDetailSegue(id: Int(image.accessibilityIdentifier ?? "0")!)
    }

    @objc func didTapText(_ sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view as! UILabel
        vc?.performUserDetailSegue(username: label.accessibilityIdentifier ?? "")
    }

    func registerTapGestures(cell: FollowingCell) {
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarTap.numberOfTapsRequired = 1
        avatarTap.numberOfTouchesRequired = 1
        cell.avatar.addGestureRecognizer(avatarTap)
        cell.avatar.isUserInteractionEnabled = true

        for imgView in cell.imageViewList {
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
            imageTap.numberOfTapsRequired = 1
            imageTap.numberOfTouchesRequired = 1

            imgView.addGestureRecognizer(imageTap)
            imgView.isUserInteractionEnabled = true
        }

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageTap.numberOfTapsRequired = 1
        imageTap.numberOfTouchesRequired = 1

        cell.inlineImage.addGestureRecognizer(imageTap)
        cell.inlineImage.isUserInteractionEnabled = true

        let shortLabelTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        shortLabelTap.numberOfTapsRequired = 1
        shortLabelTap.numberOfTouchesRequired = 1

        cell.shortLabel.addGestureRecognizer(shortLabelTap)
        cell.shortLabel.isUserInteractionEnabled = true


        let longLabelTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        longLabelTap.numberOfTapsRequired = 1
        longLabelTap.numberOfTouchesRequired = 1

        cell.longLabel.addGestureRecognizer(longLabelTap)
        cell.longLabel.isUserInteractionEnabled = true
    }
}
