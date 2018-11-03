//
//  ContrastViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 21/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class ContrastViewController: UIViewController {

    var sliderValue : Float = 0.0

    @IBOutlet weak var slider: UISlider!

    @IBAction func cancel(_ sender: UIButton) {
        self.performSegueToReturnBack()
        Util.triggerNotification(name: "changeContrast", withData: ["value": 1.0])
        Util.triggerNotification(name: "changeContrastValue", withData: ["value": 1.0])
    }

    @IBAction func done(_ sender: UIButton) {
        self.performSegueToReturnBack()
        Util.triggerNotification(name: "changeContrastValue", withData: ["value": self.slider.value])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = sliderValue
    }

    func updateForFeedbackPurpose(){
        if (slider.value > 0.9 && slider.value < 1.1 && !(sliderValue > 0.9 && sliderValue < 1.1) ){
            Util.selectionFeedback()
        }else if (slider.value == 0.0 && self.sliderValue != 0.0){
            Util.selectionFeedback()
        }else if (slider.value == 4.0 && self.sliderValue != 4.0){
            Util.selectionFeedback()
        }
        self.sliderValue = slider.value
    }

    @IBAction func onChange(_ sender: UISlider) {
        // uncomment below to enable the slider physical feedback
        // updateForFeedbackPurpose()
        Util.triggerNotification(name: "changeContrast", withData: ["value": self.slider.value])
    }

}
