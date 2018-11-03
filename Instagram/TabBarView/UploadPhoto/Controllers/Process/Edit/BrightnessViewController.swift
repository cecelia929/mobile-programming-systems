//
//  BrightnessViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 21/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class BrightnessViewController: UIViewController {

    var sliderValue: Float = 0.0

    @IBOutlet weak var slider: UISlider!

    @IBAction func cancel(_ sender: UIButton) {
        self.performSegueToReturnBack()
        Util.triggerNotification(name: "changeBrightness", withData: ["value": 0.0])
        Util.triggerNotification(name: "changeBrightnessValue", withData: ["value": 0.0])
    }

    @IBAction func done(_ sender: UIButton) {
        self.performSegueToReturnBack()
        Util.triggerNotification(name: "changeBrightnessValue", withData: ["value": self.slider.value])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = sliderValue
    }

    func updateForFeedbackPurpose() {
        if (slider.value > -0.05 && slider.value < 0.05 && !(sliderValue > -0.05 && sliderValue < 0.05)) {
            Util.selectionFeedback()
        } else if (slider.value == 1 && self.sliderValue != 1) {
            Util.selectionFeedback()
        } else if (slider.value == -1 && self.sliderValue != -1) {
            Util.selectionFeedback()
        }
        self.sliderValue = slider.value
    }

    @IBAction func onChange(_ sender: UISlider) {
        // uncomment below to enable the slider physical feedback
        // updateForFeedbackPurpose()
        Util.triggerNotification(name: "changeBrightness", withData: ["value": self.slider.value])
    }
}
