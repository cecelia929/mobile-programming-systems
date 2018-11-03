//
//  CommentsViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 19/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

@available(iOS 9.0, *)
class CommentsViewController: UIViewController {

    var text: NSMutableAttributedString = NSMutableAttributedString()
    var time: String = ""
    var avatar: String = ""
    var id: Int = 0
    var username: String = ""
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var presenter: CommentsPresenter!

    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var myAvatar: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postAvatar: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postTime: UILabel!

    @IBOutlet weak var collect: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        avatarTap.numberOfTapsRequired = 1
        avatarTap.numberOfTouchesRequired = 1
        self.postAvatar.addGestureRecognizer(avatarTap)
        self.postAvatar.isUserInteractionEnabled = true

        let textTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        textTap.numberOfTapsRequired = 1
        textTap.numberOfTouchesRequired = 1
        self.postText.addGestureRecognizer(textTap)
        self.postText.isUserInteractionEnabled = true

        collect.keyboardDismissMode = .onDrag
        collect.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refillSelctor), for: .valueChanged)
//        refreshControl.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)

        postView.addBorders(edges: .bottom, color: .lightGray, width: 0.4)

        // register notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.resetBackBarItem()

        // init view component
        if UserDefaults.standard.string(forKey: "avatar") != "" {
            let avatarURL: URL = URL(string: UserDefaults.standard.string(forKey: "avatar") ?? "")!
            myAvatar.af_setImage(withURL: avatarURL)
        } else {
            myAvatar.image = UIImage(named: Constants.defaultAvatar)
        }
        myAvatar.setRounded()
        if self.avatar != "" {
            let avatarURL: URL = URL(string: self.avatar)!
            postAvatar.af_setImage(withURL: avatarURL)
        } else {
            postAvatar.image = UIImage(named: Constants.defaultAvatar)
        }
        postAvatar.setRounded()
        postText.attributedText = text
        postTime.text = time

        setup()
        presenter.fill(self.id)
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }

    @objc func refillSelctor() {
        presenter.fill(self.id)
    }

    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }

    func stopLoadingIndicator() {
        self.loadingIndicator.stopAnimating()
    }

    func refresh() {
        //reload data here
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }


    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    func setup() {
        presenter = CommentsPresenter(vc: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
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
            "photo_id": self.id,
            "comment": textInput!
        ]

        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                return
            case .success(_):
                self.refillSelctor()
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

    func performUserDetailSegue(username: String) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pushprofile") as! ProfileViewController
        vc.username = username
        vc.pushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapText(_ sender: UITapGestureRecognizer) {
        performUserDetailSegue(username: self.username)
    }

    func resetBackBarItem (){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
