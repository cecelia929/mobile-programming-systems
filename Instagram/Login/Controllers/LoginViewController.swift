//
//  LoginViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 11/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class LoginViewController: UIViewController {
    var pushed: Bool = false
    var username: String = ""
    let locationManager = CLLocationManager()

    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var RoundedCornerButton: UIButton!

    @IBAction func loginButton(_ sender: Any) {
        let url = Constants.URL + "/api/user/login"

        let parameters: [String: String] = [
            "username": UsernameField.text!,
            "password": PasswordField.text!
        ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resStatus = ((res as AnyObject)["status"]) {
                    if resStatus as! String == "rejected" {
                        if let resLog = ((res as AnyObject)["log"]) {
                            if resLog as! String == "user doesn't exist" {
                                let alert = UIAlertController(title: "Incorrect Username", message: "The username you entered doesn't appear to belong to an account. Please check your username and try again", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .default, handler: { _ in
                                    NSLog("The \"Incorrect Username\" alert occured.")
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else if resLog as! String == "incorrect password" {
                                let s: String = self.UsernameField.text!
                                let alert = UIAlertController(title: "Incorrect Password for \(s)", message: "The password you entered is incorrect. Please try again", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .default, handler: { _ in
                                    NSLog("The \"Incorrect Password\" alert occured.")
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }

                    } else if resStatus as! String == "accepted" {
                        let avatar = (((res as AnyObject)["data"]) as! [String: String])["avatar"]
                        UserDefaults.standard.set(avatar, forKey: "avatar")
                        UserDefaults.standard.set(self.UsernameField.text!, forKey: "username")
                        self.performSegue(withIdentifier: "EnterAccount", sender: self)
                    } else {
                        NSLog("There is an error getting status from login in request")
                        print(resStatus as! String)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RoundedCornerButton.layer.cornerRadius = 4
        RoundedCornerButton.isEnabled = false
        RoundedCornerButton.alpha = 0.5

        locationManager.requestWhenInUseAuthorization()

        if (pushed) {
            UsernameField.text = self.username
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton


        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        setupAddTargetIsNotEmptyTextFields()

        // register notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupAddTargetIsNotEmptyTextFields() {
        UsernameField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
            for: .editingChanged)
        PasswordField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
            for: .editingChanged)
    }

    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        if UsernameField?.text != "" && PasswordField?.text != "" {
            RoundedCornerButton.isEnabled = true
            RoundedCornerButton.alpha = 1
        } else {
            RoundedCornerButton.isEnabled = false
            RoundedCornerButton.alpha = 0.5
        }
    }

}
