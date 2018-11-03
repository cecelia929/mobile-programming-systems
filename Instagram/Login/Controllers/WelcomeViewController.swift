//
//  WelcomeViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 7/10/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()

        loginButton.layer.cornerRadius = 4

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        self.navigationItem.hidesBackButton = true

        self.avatar.setRounded()
        if let avatar = UserDefaults.standard.string(forKey: "avatar") {
            if avatar == "" {
                self.avatar.image = UIImage(named: Constants.defaultAvatar)
            } else {
                let avatarURL: URL = URL(string: avatar)!
                self.avatar.af_setImage(withURL: avatarURL)
            }
        }

        username.text = UserDefaults.standard.string(forKey: "username") ?? ""
    }

    @IBAction func login(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TabBarView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabbarviewcontroller") as! TabBarViewController
        self.present(vc, animated: true, completion: nil)
    }

}
