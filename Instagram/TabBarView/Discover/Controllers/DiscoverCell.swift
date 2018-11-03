//
//  DiscoverCell.swift
//  Instagram
//
//  Created by Zhou Ti on 8/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class DiscoverCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatar: UIImageView!

    override func prepareForReuse() {
        self.avatar.image = nil
        self.name.text = ""
        self.username.text = ""
        super.prepareForReuse()
    }

    func fill(with discover: [String: Any]) {
        if let avatar = discover["avatar"] as? String {
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

        let username = discover["username"] as! String
        self.username.text = username

        self.avatar.accessibilityIdentifier = username


        if discover.keys.contains("name") {
            let name = discover["name"] as! String
            self.name.text = name
        }

    }
}
