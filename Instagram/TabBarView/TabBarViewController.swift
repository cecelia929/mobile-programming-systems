//
//  TabBarViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 20/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, UIPopoverPresentationControllerDelegate {

    let button = UIButton.init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        self.tabBar.unselectedItemTintColor = UIColor.black

    }

    func popOverPhotoController() {
        performSegue(withIdentifier: "selectphoto", sender: nil)
        Util.hapticEngine()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 58, width: 64, height: 64)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if (viewController.title == "dummy") {
            popOverPhotoController()
            return false
        }
        return true
    }

}
