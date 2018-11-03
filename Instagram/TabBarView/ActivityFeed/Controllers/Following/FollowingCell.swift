//
//  FollowingCell.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FollowingCell: UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var inlineImage: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!

    @IBOutlet var imageViewList: [UIImageView]!

    override func prepareForReuse() {
        longLabel.isHidden = false
        shortLabel.isHidden = false
        inlineImage.isHidden = false
        img1.isHidden = false
        img2.isHidden = false
        img3.isHidden = false
        img4.isHidden = false
        img5.isHidden = false
        img6.isHidden = false
        img7.isHidden = false
        img1.image = nil
        img2.image = nil
        img3.image = nil
        img4.image = nil
        img5.image = nil
        img6.image = nil
        img7.image = nil
        super.prepareForReuse()
    }

    func fill(with following: [String: Any]) {
        if let avatar = following["avatar"] as? String {
            if avatar != "" {
                let avatarURL: URL = URL(string: avatar)!
                self.avatar.af_setImage(withURL: avatarURL)
            } else {
                self.avatar.image = UIImage(named: Constants.defaultAvatar)
            }
        } else {
            self.avatar.image = UIImage(named: Constants.defaultAvatar)
        }
        self.avatar.setRounded()

        let username = following["first_username"] as! String

        self.avatar.accessibilityIdentifier = username

        let time = following["time"] as! String

        if let imageIDs = following["image_id"] {
            if (imageIDs as! [NSNumber]).count == 1 {
                shortLabel.attributedText = NSMutableAttributedString().bold(username).normal(" liked your post. ").gray(time)
                shortLabel.accessibilityIdentifier = username
                // render image
                let image = (following["image"] as! [String])[0]
                let imageURL: URL = URL(string: image)!
                self.inlineImage.af_setImage(withURL: imageURL)
                self.inlineImage.accessibilityIdentifier = String((imageIDs as! [NSNumber])[0] as! Int)
                self.longLabel.isHidden = true
                hideSecondLineImages()
            } else {
                longLabel.attributedText = NSMutableAttributedString().bold(username).normal(" liked your posts. ").gray(time)
                longLabel.accessibilityIdentifier = username
                self.shortLabel.isHidden = true
                // render second line image
                self.inlineImage.isHidden = true
                var index = 0
                let images = following["image"] as! [String]
                for (id, image) in images.enumerated() {
                    let imageURL: URL = URL(string: image)!
                    self.imageViewList[id].af_setImage(withURL: imageURL)
                    self.imageViewList[id].accessibilityIdentifier = String((imageIDs as! [NSNumber])[id] as! Int)
                    index += 1
                }
                for i in index + 1...6 {
                    self.imageViewList[i].isHidden = true
                }
            }
        } else {
            longLabel.attributedText = NSMutableAttributedString().bold(username).normal(" started following you. ").gray(time)
            self.longLabel.accessibilityIdentifier = username
            self.shortLabel.isHidden = true
        }
    }

    func hideSecondLineImages() {
        img1.isHidden = true
        img2.isHidden = true
        img3.isHidden = true
        img4.isHidden = true
        img5.isHidden = true
        img6.isHidden = true
        img7.isHidden = true
    }
}
