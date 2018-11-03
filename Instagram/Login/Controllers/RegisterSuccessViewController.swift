//
//  RegisterSuccessViewController.swift
//  Instagram
//
//  Created by macbook pro on 2018/10/6.
//  Copyright © 2018年 com.team48. All rights reserved.
//

import UIKit

class RegisterSuccessViewController: UIViewController {

    var name = ""

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        continueButton.layer.cornerRadius = 4

        welcomeLabel.text = "Welcome to Instagram, \(name)"
        // Do any additional setup after loading the view.
    }
}
