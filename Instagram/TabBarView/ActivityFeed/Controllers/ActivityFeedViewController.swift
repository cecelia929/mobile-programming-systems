//
//  ActivityFeedViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 11/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import SwipeViewController

class ActivityFeedViewController: SwipeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "ActivityFeed", bundle: nil)
        let following = storyboard.instantiateViewController(withIdentifier: "following") as! FollowingViewController
        following.title = "Following"
        let you = storyboard.instantiateViewController(withIdentifier: "you") as! YouViewController
        you.title = "Following"
        you.title = "You"

        setViewControllerArray([following, you])

        setFirstViewController(1)

        setButtonsWithSelectedColor(UIFont.boldSystemFont(ofSize: 15), color: UIColor.gray, selectedColor: UIColor.black)

//        setButtonsOffset(0, bottomOffset: -10)

        equalSpaces = false

        setSelectionBar(UIScreen.main.bounds.width / 2, height: 1, color: .black)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
