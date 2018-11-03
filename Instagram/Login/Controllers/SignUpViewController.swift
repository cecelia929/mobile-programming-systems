//
//  SignUpViewController.swift
//  Instagram
//
//  Created by macbook pro on 2018/9/30.
//  Copyright © 2018年 com.team48. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    let url = Constants.URL + "/api/user/register"

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmedPassword: UITextField!

    @IBOutlet weak var register: UIButton!

    @IBAction func onCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func register(_ sender: Any) {
        print("register")
        if password.text != confirmedPassword.text {
            print("not equal")
            let alert = UIAlertController(title: "Unidentical Passwords", message: "Please Confirm Your Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let parameters: [String: String] = [
            "username": username.text!,
            "name": name.text!,
            "password": password.text!,
        ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if let res = response.result.value {
                if let resStatus = ((res as AnyObject)["status"]) {
                    if resStatus as! String == "rejected" {
                        if let resLog = ((res as AnyObject)["log"]) {
                            if resLog as! String == "user already exist" {
                                let s: String = self.username.text!
                                let alert = UIAlertController(title: "Log in as \(s)?", message: "It looks like you already have an Instagram account", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Login as \(s)", comment: "Default action"), style: .default, handler: { _ in
                                    self.performSegue(withIdentifier: "hasaccountgotologin", sender: self)
                                }))
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "dismiss action"), style: .default, handler: {_ in
                                    self.username.text = ""
                                    self.name.text = ""
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                NSLog("There is something wrong with log from sign up request")
                                print(resLog as! String)
                            }
                        }

                    } else if resStatus as! String == "accepted" {
                        UserDefaults.standard.set("", forKey: "avatar")
                        UserDefaults.standard.set(self.username.text!, forKey: "username")
                        self.performSegue(withIdentifier: "registerSuccess", sender: self)
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LoginViewController {
            vc.username = username.text!
            vc.pushed = true
        }
        if let vc = segue.destination as? RegisterSuccessViewController {
            vc.name = name.text!
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        register.layer.cornerRadius = 4
        register.isEnabled = false
        register.alpha = 0.5

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        let backButton = UIBarButtonItem()
        backButton.tintColor = UIColor.black
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupAddTargetIsNotEmptyTextFields() {
        username.addTarget(self, action: #selector(textFieldsIsNotEmpty),
            for: .editingChanged)
        name.addTarget(self, action: #selector(textFieldsIsNotEmpty),
            for: .editingChanged)
        password.addTarget(self, action: #selector(textFieldsIsNotEmpty),
            for: .editingChanged)
        confirmedPassword.addTarget(self, action: #selector(textFieldsIsNotEmpty),
            for: .editingChanged)
    }

    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        if username.text != "" && name.text != "" && password.text != "" && confirmedPassword.text != "" {
            register.isEnabled = true
            register.alpha = 1.0
        } else {
            self.register.isEnabled = false
            register.alpha = 0.5
        }
    }

}
