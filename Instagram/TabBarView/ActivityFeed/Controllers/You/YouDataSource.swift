//
//  YouDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire

class YouDataSource: NSObject, UICollectionViewDataSource {

    var yous: [String: Any] = [:]
    var today: [[String: Any]] = []
    var thisWeek: [[String: Any]] = []
    var thisMonth: [[String: Any]] = []
    var earlier: [[String: Any]] = []
    var realSections: [[[String: Any]]] = []
    var imageNumList: [[Int]] = []
    var sectionTitles: [String] = []
    var numSection = 0

    let url = Constants.URL + "/api/activityfeed"
    var vc: YouViewController!
    var presenter: YouPresenter!


    init(vc: YouViewController?, presenter: YouPresenter) {
        super.init()
        self.vc = vc
        self.presenter = presenter
    }

    func fill() {
        let parameters: [String: Any] = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "type": "You"
        ]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resData = ((res as AnyObject)["data"]) {
                    self.yous = resData as! [String: Any]
                    if !self.emptyObject() {
                        self.vc.setNoResultButton(show: false)
                    } else {
                        print("there are not yous")
                        self.vc.setNoResultButton(show: true)
                    }
                    self.readYours(yous: self.yous)
                    self.presenter.setImageNumberList(list: self.imageNumList)
                    self.vc.refresh()
                    self.vc.stopLoadingIndicator()
                    self.vc.endRefreshing()
                }
            }
        }
    }

    func emptyObject() -> Bool {
        for you in self.yous {
            if (you.value as! NSArray).count > 0 {
                return false
            }
        }
        return true
    }

    func readYours(yous: [String: Any]) {
        self.numSection = 0
        self.realSections = []
        self.sectionTitles = []
        self.today = yous["Today"] as! [[String: Any]]
        if today.count > 0 {
            self.readImgNum(yous: self.today)
            self.numSection += 1
            self.realSections.append(today)
            sectionTitles.append("Today")
        }
        self.thisWeek = yous["This Week"] as! [[String: Any]]
        if thisWeek.count > 0 {
            self.readImgNum(yous: self.thisWeek)
            self.numSection += 1
            self.realSections.append(thisWeek)
            sectionTitles.append("This Week")
        }
        self.thisMonth = yous["This Month"] as! [[String: Any]]
        if thisMonth.count > 0 {
            self.readImgNum(yous: self.thisMonth)
            self.numSection += 1
            self.realSections.append(thisMonth)
            sectionTitles.append("This Month")
        }
        self.earlier = yous["Earlier"] as! [[String: Any]]
        if earlier.count > 0 {
            self.readImgNum(yous: self.earlier)
            self.numSection += 1
            self.realSections.append(earlier)
            sectionTitles.append("Earlier")
        }
    }

    func readImgNum(yous: [[String: Any]]) {
        var numbers: [Int] = []
        for you in yous {
            if let imageIDs = you["image_id"] {
                numbers.append((imageIDs as! [NSNumber]).count)
            } else {
                numbers.append(0)
            }
        }
        self.imageNumList.append(numbers)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.realSections[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionNum = indexPath.section
        let dataList: [[String: Any]] = self.realSections[sectionNum]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "youCell", for: indexPath) as! YouCell
        registerTapGestures(cell: cell)
        let you = dataList[indexPath.item]
        cell.fill(with: you)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let youReusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "youreusable", for: indexPath) as! YouCollectionReusableView
        youReusable.timePeriod = self.sectionTitles[indexPath.section]
        return youReusable
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numSection
    }

    @objc func didTapAvatar(_ sender: UITapGestureRecognizer) {
        let avatar: UIImageView = sender.view as! UIImageView
        vc?.performUserDetailSegue(username: avatar.accessibilityIdentifier ?? "")
    }

    @objc func didTapImage(_ sender: UITapGestureRecognizer) {
        let image: UIImageView = sender.view as! UIImageView
        vc.performPhotoDetailSegue(id: Int(image.accessibilityIdentifier ?? "0")!)
    }

    @objc func didTapText(_ sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view as! UILabel
        let username = label.accessibilityIdentifier ?? ""
        vc?.performUserDetailSegue(username: label.accessibilityIdentifier ?? "")
    }

    func registerTapGestures(cell: YouCell) {
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
