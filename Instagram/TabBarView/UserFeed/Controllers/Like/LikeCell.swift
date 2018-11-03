//
//  LikeCell.swift
//  Instagram
//
//  Created by Zhou Ti on 9/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire

class LikeCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var followButton: UIButton!

    var vc: LikeViewController!

    override func prepareForReuse() {
        self.avatar.image = nil
        self.name.text = ""
        self.username.text = ""
        super.prepareForReuse()
    }

    @IBAction func follow(_ sender: UIButton) {
        sendFollowRequest()
    }

    func sendFollowRequest() {
        let url = Constants.URL + "/api/profile/follow"

        let parameters: [String: Any] = [
            "my_username": UserDefaults.standard.string(forKey: "username") ?? "",
            "follow_username": self.username.text!
        ]

        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                return
            case .success(_):
                self.vc.refillSelctor()
                break
            }
        }
    }

    func fill(with like: [String: Any]) {
        followButton.layer.cornerRadius = 5.0

        if let avatar = like["avatar"] as? String {
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

        let username = like["username"] as! String
        self.username.text = username

        self.avatar.accessibilityIdentifier = username


        if like.keys.contains("name") {
            let name = like["name"] as! String
            self.name.text = name
        }

        let following_him = like["following_him"] as! Bool
        let get_followed = like["get_followed"] as! Bool

        let localUsername = UserDefaults.standard.string(forKey: "username") ?? ""

        if username == localUsername || username == localUsername.lowercased() {
            setYouButton()
        } else if following_him {
            setFollowedButton()
        } else {
            if get_followed {
                setFollowBackButton()
            } else {
                setFollowButton()
            }
        }
    }

    func setYouButton() {
        followButton.isEnabled = false
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.backgroundColor = UIColor.clear.cgColor
        followButton.setTitleColor(UIColor.lightGray, for: .normal)
        followButton.setTitle("You", for: .normal)
    }

    func setFollowedButton(){
        followButton.isEnabled = false
        let blueColor = UIColor(red: 14 / 255.0, green: 122 / 255.0, blue: 1, alpha: 1)
        followButton.layer.borderColor = blueColor.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.backgroundColor = UIColor.clear.cgColor
        followButton.setTitleColor(blueColor, for: .normal)
        followButton.setTitle("Following", for: .normal)
    }

    func setFollowButton() {
        followButton.setTitle("Follow", for: .normal)
        let blueColor = UIColor(red: 14 / 255.0, green: 122 / 255.0, blue: 1, alpha: 1)
        followButton.layer.borderColor = blueColor.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.backgroundColor = blueColor.cgColor
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.isEnabled = true
    }

    func setFollowBackButton() {
        followButton.setTitle("Follow Back", for: .normal)
        let blueColor = UIColor(red: 14 / 255.0, green: 122 / 255.0, blue: 1, alpha: 1)
        followButton.layer.borderColor = blueColor.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.backgroundColor = blueColor.cgColor
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.isEnabled = true
    }
}
