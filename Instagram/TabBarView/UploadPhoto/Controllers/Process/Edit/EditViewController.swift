//
//  EditViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 21/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    var brightnessValue: Float = 0.0
    var contrastValue: Float = 1.0

    @IBAction func goToBrightness(_ sender: UIButton) {

    }

    @IBAction func goToContrast(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeBrightnessValue), name: NSNotification.Name(rawValue: "changeBrightnessValue"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeContrastValue), name: NSNotification.Name(rawValue: "changeContrastValue"), object: nil)
    }

    @objc func changeBrightnessValue(notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let value = dict["value"] as? Float {
                self.brightnessValue = value
            }
        }
    }

    @objc func changeContrastValue(notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let value = dict["value"] as? Float {
                self.contrastValue = value
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoBrightness") {
            let vc = segue.destination as! BrightnessViewController
            vc.sliderValue = brightnessValue
        }
        if (segue.identifier == "gotoContrast") {
            let vc = segue.destination as! ContrastViewController
            vc.sliderValue = contrastValue
        }
    }
}
