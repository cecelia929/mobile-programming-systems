//
//  CommentsCellCollectionViewCell.swift
//  Instagram
//
//  Created by Zhou Ti on 20/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {

    @IBOutlet weak var commentAvatar: UIImageView!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentDetail: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func fill(with comment: [String: Any]) {
        if let avatar = comment["avatar"] as? String {
            let avatarURL: URL = URL(string: avatar)!
            commentAvatar.af_setImage(withURL: avatarURL)
        } else {
            commentAvatar.image = UIImage(named: Constants.defaultAvatar)
        }
        commentAvatar.setRounded()

        let username = (comment["username"] as! String)
        commentText.attributedText = NSMutableAttributedString().bold(username).normal(" \((comment["text"] as! NSString))")
        commentText.accessibilityIdentifier = username
        commentAvatar.accessibilityIdentifier = username
        let time = (comment["time"] as! String)
//        let number_of_likes = String(comment["number_of_likes"] as! Int)
        commentDetail.text = time
    }
}
