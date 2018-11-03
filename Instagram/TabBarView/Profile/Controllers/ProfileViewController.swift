//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 11/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController {

    var myself: Bool = false
    var filled: Bool = false
    var presenter: ProfilePresenter!
    let refreshControl = UIRefreshControl()
    var username: String = ""
    var pushed: Bool?

    @IBOutlet weak var NoPhotoLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collect: UICollectionView!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        if !filled {
            self.loadIndicator.startAnimating()
        }
        self.NoPhotoLabel.layer.zPosition = -1
        refillSelctor()
    }
    override func viewWillLayoutSubviews() {
        avatarView.setRounded()
    }

    func setFilled(filled: Bool) {
        self.filled = filled
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadIndicator.layer.zPosition = 1

        if pushed ?? false {
            resetBackBarItem()
            self.navigationItem.title = self.username
            nameLabel.text = self.username
            if self.username == (UserDefaults.standard.string(forKey: "username") ?? "") {
                self.myself = true
            }
        } else {
            self.navigationItem.title = UserDefaults.standard.string(forKey: "username")
            nameLabel.text = UserDefaults.standard.string(forKey: "username")
            self.myself = true
            // set my avatar photo from userdefault
            // maybe better save the avatar as base64 data when received in login page
        }


        collect.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refillSelctor), for: .valueChanged)


        followButton.layer.cornerRadius = 5.0


        if self.myself {
            followButton.isEnabled = true
            followButton.layer.borderColor = UIColor.red.cgColor
            followButton.layer.borderWidth = 1
            followButton.layer.backgroundColor = UIColor.clear.cgColor
            followButton.setTitleColor(UIColor.red, for: .normal)
            followButton.setTitle("Log out", for: .normal)
        }

        setup()
        fetchProfileData()
    }

    @objc func refillSelctor() {
        hideNoFeedLabel()
        fetchProfileData()
    }

    func setup() {
        presenter = ProfilePresenter(viewController: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
    }


    func performPhotoDetailSegue(id: Int) {
        let storyboard = UIStoryboard(name: "UserFeed", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pushuserfeed") as! UserFeedViewController
        vc.id = id
        vc.pushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func followOrLogOut(_ sender: UIButton) {
        if self.myself {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! WelcomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            sendFollowRequest()
        }
    }

    func sendFollowRequest() {
        let url = Constants.URL + "/api/profile/follow"

        let parameters: [String: Any] = [
            "my_username": UserDefaults.standard.string(forKey: "username") ?? "",
            "follow_username": self.username
        ]

        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                return
            case .success(_):
                self.fetchProfileData()
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func fetchProfileData() {
        let parameters: [String: String]
        if pushed ?? false {
            parameters = [
                "my_username": UserDefaults.standard.string(forKey: "username") ?? "",
                "profile_username": self.username
            ]
        } else {
            parameters = [
                "my_username": UserDefaults.standard.string(forKey: "username") ?? "",
                "profile_username": UserDefaults.standard.string(forKey: "username") ?? ""
            ]
        }
        let url = Constants.URL + "/api/profile"
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resData = ((res as AnyObject)["data"]) {
                    self.loadIndicator.stopAnimating()
                    let photos = resData as! [String: Any]
                    if photos.count > 0 {
                        self.setFilled(filled: true)
                    }else{
                        self.setFilled(filled: true)
                    }
                    self.processData(photos)
                }
            }
        }
    }

    func processData(_ data: [String: Any]) {
        var avatar = ""
        if (!(data["avatar"] is NSNull)) {
            avatar = data["avatar"] as! String
        }
        let followingHim = data["following_him"] as! Bool
        let getFollowed = data["get_followed"] as! Bool
        print(self.username)
        if !self.myself {
            if followingHim {
                followButton.isEnabled = false
                let blueColor = UIColor(red: 14 / 255.0, green: 122 / 255.0, blue: 1, alpha: 1)
                followButton.layer.borderColor = blueColor.cgColor
                followButton.layer.borderWidth = 1
                followButton.layer.backgroundColor = UIColor.clear.cgColor
                followButton.setTitleColor(blueColor, for: .normal)
                followButton.setTitle("Following", for: .normal)
            } else {
                if getFollowed {
                    followButton.setTitle("Follow Back", for: .normal)
                    followButton.isEnabled = true
                } else {
                    followButton.setTitle("Follow", for: .normal)
                    followButton.isEnabled = true
                }
            }
        }
        if (avatar == "") {
            avatarView.image = UIImage(named: Constants.defaultAvatar)
        } else {
            let avatarURL: URL = URL(string: avatar)!
            self.avatarView.af_setImage(withURL: avatarURL)
        }

        let posts = data["posts"]
        let followers = data["followers"]
        let following = data["following"]
        self.posts.text = String(posts as! Int)
        self.followers.text = String(followers as! Int)
        self.following.text = String(following as! Int)
        let photoArray = (data["photos"] as! [String])
        if photoArray.count == 0 {
            showNoFeedLabel()
        } else {
            hideNoFeedLabel()
        }
        let idArray = (data["id"] as! [Int])
        presenter.fill(photos: photoArray, ids: idArray)
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
        self.refreshControl.endRefreshing()
    }

    func resetBackBarItem() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = nil;
    }

    func stopLoadingIndicator() {
        self.loadIndicator.stopAnimating()
    }

    func showNoFeedLabel() {
        self.NoPhotoLabel.layer.zPosition = 1
    }

    func hideNoFeedLabel() {
        self.NoPhotoLabel.layer.zPosition = -1
    }
}
