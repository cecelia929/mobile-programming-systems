//
//  CommentsDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 20/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire

class CommentsDataSource: NSObject, UICollectionViewDataSource {
    var comments: [[String: Any]] = []
    let url = Constants.URL + "/api/userfeed/comment"
    var vc: CommentsViewController!
    var presenter: CommentsPresenter!

    init(vc: CommentsViewController?, presenter: CommentsPresenter) {
        super.init()
        self.vc = vc
        self.presenter = presenter
    }

    func fill(_ id: Int) {
        let parameters: [String: Any] = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "photo_id": id
        ]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resData = ((res as AnyObject)["data"]) {
                    self.comments = resData as! [[String: Any]]
                    self.vc.refresh()
                    self.vc.stopLoadingIndicator()
                    self.vc.endRefreshing()
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! CommentsCell
        registerTapGestures(cell: cell)
        let comment = self.comments[indexPath.item]
        cell.fill(with: comment)
        return cell
    }

    func registerTapGestures(cell: CommentsCell) {
        let commentUsernameTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        commentUsernameTap.numberOfTapsRequired = 1
        commentUsernameTap.numberOfTouchesRequired = 1

        cell.commentText.addGestureRecognizer(commentUsernameTap)
        cell.commentText.isUserInteractionEnabled = true

        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        avatarTap.numberOfTapsRequired = 1
        avatarTap.numberOfTouchesRequired = 1
        cell.commentAvatar.addGestureRecognizer(avatarTap)
        cell.commentAvatar.isUserInteractionEnabled = true
    }

    @objc func didTapText(_ sender: UITapGestureRecognizer) {
        let label = sender.view
        vc?.performUserDetailSegue(username: label!.accessibilityIdentifier ?? "")
    }
}
