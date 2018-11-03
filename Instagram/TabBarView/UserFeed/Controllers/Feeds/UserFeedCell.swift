//
//  UserFeedCell.swift
//  Instagram
//
//  Created by Zhou Ti on 18/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

@available(iOS 10.0, *)
class UserFeedCell: UICollectionViewCell {

    @IBOutlet weak var photoAvatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var photoText: UILabel!
    @IBOutlet weak var firstComment: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var viewAllComments: UIButton!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameWithLocation: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var upperbar: UIView!

    var likeStatus = false
    var shareStatus = false
    var dataSource: UserFeedDataSource!
    var index: Int = 0
    var imageURL: URL!
    var height: Int!
    var width: Int!
    var photo_id: Int!
    var vc: UserFeedViewController!


    @IBAction func toggleLike(_ sender: UIButton) {
        if (likeStatus) {
            dataSource.updateState(index: self.index, key: "like", value: false)
            like.setImage(UIImage(named: "hollowHeart.jpg"), for: .normal)
            likeStatus = false
        } else {
            dataSource.updateState(index: self.index, key: "like", value: true)
            Util.animationButton(sender: sender)
            Util.hapticEngine()
            like.setImage(UIImage(named: "redHeart.jpg"), for: .normal)
            likeStatus = true
        }

        let url = Constants.URL + "/api/userfeed/like"
        let parameters: [String: Any] = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "photo_id": self.photo_id!
        ]

        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                return
            case .success(_):
                self.vc.refillSelector()
                break
            }
        }
    }


    @IBAction func postComment(_ sender: UIButton) {

        let textInput = self.textInput.text

        self.textInput.isEnabled = false
        self.textInput.text = ""
        self.postButton.isEnabled = false
        self.postButton.isHidden = true
        self.textInput.isEnabled = true

        let url = Constants.URL + "/api/userfeed/comment"

        let parameters: [String: Any] = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "photo_id": self.photo_id!,
            "comment": textInput!
        ]

        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                return
            case .success(_):
                self.vc.refillSelector()
                break
            }
        }
    }

    @IBAction func beginComment(_ sender: UITextField) {
        postButton.isHidden = false
        textInput.borderStyle = UITextBorderStyle.roundedRect
        if textInput.text != "" {
            postButton.isEnabled = true
        }
    }

    @IBAction func commentChange(_ sender: UITextField) {
        if (textInput.text != "") {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }

    @IBAction func endComment(_ sender: UITextField) {
        postButton.isHidden = true
        postButton.isEnabled = false
        textInput.borderStyle = UITextBorderStyle.none
    }

    override func prepareForReuse() {
        self.likeStatus = false
        like.setImage(UIImage(named: "hollowHeart.jpg"), for: .normal)
        self.shareStatus = false
        share.setImage(UIImage(named: "share_hollow.png"), for: .normal)
        self.photoAvatar.image = nil
        self.userAvatar.image = nil
        self.userPhoto.image = nil
        self.username.isHidden = false
        self.location.isHidden = false
        self.usernameWithLocation.isHidden = false
        super.prepareForReuse()
    }

    @IBAction func share(_ sender: UIButton) {
        if !self.shareStatus {
            dataSource.updateState(index: self.index, key: "shared", value: true)
            Util.animationButton(sender: sender)
            Util.hapticEngine()
            share.setImage(UIImage(named: "share.png"), for: .normal)
            self.shareStatus = true

            vc.sendFeedToPeer(dict: ["URL": self.imageURL, "height": self.height, "width": self.width])
        }
    }

    func fill(with feed: [String: Any], state: [String: Bool], index i: Int) {
        self.photo_id = feed["id"] as? Int
        self.share.isHidden = !state["showShare"]!
        let shareImageString = state["shared"]! ? "share.png" : "share_hollow.png"
        share.setImage(UIImage(named: shareImageString), for: .normal)
        self.index = i
//        share.setImage(UIImage(named: "share_hollow.png"), for: .normal)
        if let avatar = feed["avatar"] as? String {
            let avatarURL: URL = URL(string: avatar)!
            photoAvatar.af_setImage(withURL: avatarURL)
        } else {
            photoAvatar.image = UIImage(named: Constants.defaultAvatar)
        }
        photoAvatar.setRounded()


        if (feed["location"] as! String) != "" {
            username.isHidden = true
            usernameWithLocation.text = (feed["username"] as! String)
            location.text = (feed["location"] as! String)
        } else {
            usernameWithLocation.isHidden = true
            location.isHidden = true
            username.text = (feed["username"] as! String)
        }

        if (state["like"]!) {
            likeStatus = true
            like.setImage(UIImage(named: "redHeart.jpg"), for: .normal)
        }

        let imageURL: URL = URL(string: feed["image"] as! String)!
        self.imageURL = imageURL
        let screenSize = UIScreen.main.bounds
        let width = feed["width"] as! Int
        let height = feed["height"] as! Int
        self.width = width
        self.height = height
        let realHeight: CGFloat = screenSize.width / CGFloat(width) * CGFloat(height)
        userPhoto.frame = CGRect(x: 0, y: 52, width: screenSize.width, height: realHeight)
        userPhoto.af_setImage(withURL: imageURL)

        likeLabel.text = "\(String(describing: feed["number_of_likes"] as! Int)) likes"
        likeLabel.frame = CGRect(x: 8, y: 62 + realHeight, width: screenSize.width - 16, height: 21)
        likeLabel.accessibilityIdentifier = String(photo_id)

        photoText.attributedText = NSMutableAttributedString().bold(feed["username"] as! String).normal(" \((feed["text"] as! NSString))")
        photoText.frame = CGRect(x: 8, y: 80 + realHeight, width: screenSize.width - 16, height: 39)
        photoText.accessibilityIdentifier = (feed["username"] as! String)

        viewAllComments.setTitle("View all \(String(describing: feed["number_of_comments"] as! Int)) comments", for: .normal)
        viewAllComments.frame = CGRect(x: 8, y: 113 + realHeight, width: 159, height: 28)

        let first_comment = feed["first_comment"] as! [String: String]
        var offset: CGFloat = 0
        if first_comment.count == 0 {
            firstComment.isHidden = true
        } else {
            firstComment.isHidden = false
            firstComment.attributedText = NSMutableAttributedString().bold(first_comment["username"]!).normal(" \(first_comment["comment"]!)")
            firstComment.frame = CGRect(x: 8, y: 137 + realHeight, width: screenSize.width - 16, height: 39)
            offset = 41
            firstComment.accessibilityIdentifier = first_comment["username"]!
        }

        if UserDefaults.standard.string(forKey: "avatar") != "" {
            let avatarURL: URL = URL(string: UserDefaults.standard.string(forKey: "avatar") ?? "")!
            userAvatar.af_setImage(withURL: avatarURL)
        } else {
            userAvatar.image = UIImage(named: Constants.defaultAvatar)
        }

        userAvatar.frame = CGRect(x: 8, y: 140 + offset + realHeight, width: 30, height: 30)
        userAvatar.setRounded()
        
        textInput.placeholder = "Add a comment..."
        textInput.frame = CGRect(x: 52, y: 140 + offset + realHeight, width: screenSize.width - 102, height: 30)

        postButton.frame = CGRect(x: screenSize.width - 42, y: 140 + offset + realHeight, width: 32, height: 30)

        time.text = (feed["time"] as! String)
        time.frame = CGRect(x: 8, y: 179 + offset + realHeight, width: screenSize.width - 16, height: 19)
    }

}
