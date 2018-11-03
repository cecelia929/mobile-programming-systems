//
//  EmbeddedTabBarViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 21/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class EmbeddedTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 15)!], for: .normal)

//        NotificationCenter.default.addObserver(self, selector: #selector(updateFilterViewImage), name: NSNotification.Name(rawValue: "updateFiterViewImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateEmbedSelfImage), name: NSNotification.Name(rawValue: "updateEmbedSelfImage"), object: nil)

        let vc = viewControllers?.first as? FilterViewController
        vc?.image = self.image

    }

    @objc func updateEmbedSelfImage(notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            if let image = dict["image"] as? UIImage {
                self.image = image
            }
        }
    }

//    @objc func updateFilterViewImage(notification: NSNotification){
//        if let dict = notification.userInfo as NSDictionary? {
//            if let image = dict["image"] as? UIImage {
//                let vc1 = viewControllers?.first as? FilterViewController
//                vc1?.image = image
//                let vc2 = viewControllers?[1] as? FilterViewController
//                vc2?.image = image
//            }
//        }
//    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // todo: check if call fill() in FilterViewController is wise once the image is updated
        let vc1 = viewControllers?.first as? FilterViewController
        vc1?.image = image

        let vc2 = viewControllers?[1] as? FilterViewController
        vc2?.image = image
    }
}
