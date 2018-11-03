//
//  UserFeedDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 18/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

@available(iOS 10.0, *)
class UserFeedDataSource: NSObject, UICollectionViewDataSource {

    var userFeed: [[String: Any]] = []
    var imageSizeArray: [[String: Int]] = []
    var firstCommentArray: [Bool] = []
    var states: [[String: Bool]] = []
    var vc: UserFeedViewController?
    var presenter: UserFeedPresenter?

    init(vc: UserFeedViewController?, presenter: UserFeedPresenter) {
        super.init()
        self.vc = vc
        self.presenter = presenter
    }

    func triggerShareButton() {
        for row in self.states.indices {
            self.states[row]["showShare"] = !self.states[row]["showShare"]!
            self.states[row]["shared"] = false
        }
    }

    func fill(id: Int, hosted: Bool, sort: String) {
        print("fill with id ", id)
        print("self is ", self)
        var parameters: [String: Any]
        var url: String
        if id < 0 {
            url = Constants.URL + "/api/userfeed"

            parameters = [
                "username": UserDefaults.standard.string(forKey: "username") ?? "",
                "sort": sort
            ]

            if CLLocationManager.locationServicesEnabled() {
                if let (longitude, latitude) = getLongLat() {
                    parameters["longitude"] = longitude
                    parameters["latitude"] = latitude
                }
            }
        } else {
            url = Constants.URL + "/api/photo/detail"

            parameters = [
                "username": UserDefaults.standard.string(forKey: "username") ?? "",
                "photo_id": id
            ]
        }
        print(parameters)
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resData = ((res as AnyObject)["data"]) {
                    self.userFeed = resData as! [[String: Any]]
                    if self.userFeed.count == 0{
                        self.vc?.showNoFeedLabel()
                        self.vc?.setFilled(filled: false)
                    }else{
                        self.vc?.hideNoFeedLabel()
                        self.vc?.setFilled(filled: true)
                    }
                    self.generateArrays()
                    self.generateStates(hosted: hosted)
                    self.vc?.loadList()
                    self.vc?.stopLoadingIndicator()
                    self.vc?.endRefreshing()
                    self.vc?.updateFeedData(userfeed: self.userFeed)
                    self.presenter?.updateArrays(imageSizeArray: self.imageSizeArray, firstCommentArray: self.firstCommentArray)
                } else {
                    print((res as AnyObject)["log"] as Any)
                }
            }
        }

    }

    func generateStates(hosted: Bool) {
        self.states.removeAll()
        for feed in self.userFeed {
            let state: [String: Bool] = [
                "like": feed["like"] as! Bool,
                "showShare": hosted,
                "shared": false
            ]
            self.states.append(state)
        }
        print("state count: ", self.states.count)
    }


    func generateArrays() {
        self.imageSizeArray.removeAll()
        self.firstCommentArray.removeAll()
        for feed in self.userFeed {
            let width = feed["width"] as! Int
            let height = feed["height"] as! Int
            let hasComment = (feed["first_comment"] as! [String: String]).count > 0
            self.imageSizeArray.append(["width": width, "height": height])
            self.firstCommentArray.append(hasComment)
        }
        print("imagearray count: ", self.imageSizeArray.count)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("numberofitemsinsection")
        return self.userFeed.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("cellforitemat")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! UserFeedCell
        cell.vc = self.vc
        cell.dataSource = self
        registerTapGestures(cell: cell)
        let userfeed = self.userFeed[indexPath.item]
        cell.fill(with: userfeed, state: self.states[indexPath.item], index: indexPath.item)
        return cell
    }

    func getLongLat() -> (Double, Double)? {
        if let location = CLLocationManager().location {
            return (Double(location.coordinate.longitude), Double(location.coordinate.latitude))
        }
        return nil
    }

    func updateState(index: Int, key: String, value: Bool) {
        self.states[index][key] = value
    }

    @objc func didTapUpperBar(_ sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view?.subviews[2] as! UILabel
        vc?.performUserDetailSegue(username: label.text ?? "")
    }

    @objc func didTapText(_ sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view as! UILabel
        vc?.performUserDetailSegue(username: label.accessibilityIdentifier ?? "")
    }

    @objc func didTapLike(_ sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view as! UILabel
        print(Int(label.accessibilityIdentifier ?? "")!)
        vc?.performLikeSegue(photo_id: Int(label.accessibilityIdentifier ?? "")!)
    }

    func registerTapGestures(cell: UserFeedCell) {
        let upperbarTap = UITapGestureRecognizer(target: self, action: #selector(didTapUpperBar))
        upperbarTap.numberOfTapsRequired = 1
        upperbarTap.numberOfTouchesRequired = 1
        cell.upperbar.addGestureRecognizer(upperbarTap)
        cell.upperbar.isUserInteractionEnabled = true

        let captionUsernameTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        captionUsernameTap.numberOfTapsRequired = 1
        captionUsernameTap.numberOfTouchesRequired = 1

        cell.photoText.addGestureRecognizer(captionUsernameTap)
        cell.photoText.isUserInteractionEnabled = true

        let commentUsernameTap = UITapGestureRecognizer(target: self, action: #selector(didTapText))
        commentUsernameTap.numberOfTapsRequired = 1
        commentUsernameTap.numberOfTouchesRequired = 1
        cell.firstComment.addGestureRecognizer(commentUsernameTap)
        cell.firstComment.isUserInteractionEnabled = true

        let likeTap = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        likeTap.numberOfTapsRequired = 1
        likeTap.numberOfTouchesRequired = 1
        cell.likeLabel.addGestureRecognizer(likeTap)
        cell.likeLabel.isUserInteractionEnabled = true
    }
}
