//
//  ProcessViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 20/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import CoreImage

class ProcessViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var filteredImageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!

    var colorControl = ColorControl()

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        imageScrollView.delegate = self

        filteredImageView.backgroundColor = UIColor.black
        filteredImageView.image = self.image

        NotificationCenter.default.addObserver(self, selector: #selector(changeBrightness), name: NSNotification.Name(rawValue: "changeBrightness"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeContrast), name: NSNotification.Name(rawValue: "changeContrast"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFilterImage), name: NSNotification.Name(rawValue: "updateFilterImage"), object: nil)

        colorControl.input(filteredImageView.image!)
    }


    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return filteredImageView
    }


    @objc func changeContrast(notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let value = dict["value"] as? Float {
                self.colorControl.contrast(value)
                self.colorControl.input(self.image!)
                let image = self.colorControl.outputUIImage()
                self.filteredImageView.image = image
                Util.triggerNotification(name: "updateEmbedSelfImage", withData: ["image": image!])
            }
        }
    }

    @objc func changeBrightness(notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let value = dict["value"] as? Float {
                self.colorControl.brightness(value)
                self.colorControl.input(self.image!)
                let image = self.colorControl.outputUIImage()
                self.filteredImageView.image = image
                Util.triggerNotification(name: "updateEmbedSelfImage", withData: ["image": image!])
            }
        }
    }

    @objc func updateFilterImage(notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let image = dict["image"] as? UIImage {
                self.filteredImageView.image = image
                self.image = image
                Util.triggerNotification(name: "updateEmbedSelfImage", withData: ["image": image])
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEmbed" {
            if let destinationVC = segue.destination as? EmbeddedTabBarViewController {
                destinationVC.image = self.image
            }
        }
        if segue.identifier == "newpost" {
            if let destinationVC = segue.destination as? UploadPhotoViewController {
                destinationVC.image = self.image
            }
        }
    }
}
