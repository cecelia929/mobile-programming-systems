//
//  UploadPhotoViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 22/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class UploadPhotoViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    var image: UIImage?
    let locationManager = CLLocationManager()
    @IBOutlet weak var captionLocationView: UIView!

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!


    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        scrollView.delegate = self
        caption.delegate = self

        caption.text = "Write a caption..."
        caption.textColor = UIColor.lightGray
        caption.layer.borderWidth = 1
        caption.layer.borderColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0).cgColor
        caption.layer.cornerRadius = 15.0
        caption.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)


        imageView.backgroundColor = UIColor.black
        imageView.image = self.image

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


        self.locationButton.sizeToFit()
        self.locationButton.layer.cornerRadius = 5.0
        self.locationButton.layer.masksToBounds = true

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            lookUpCurrentLocation { (geoLoc) in
                self.locationButton.setTitle("  " + (geoLoc?.locality ?? " ") + "  ", for: .normal)
            }
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 64 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 64 {
            self.view.frame.origin.y = 64
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if (caption.textColor == UIColor.lightGray) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if (caption.text.isEmpty) {
            caption.textColor = UIColor.lightGray
            caption.text = "Write a caption..."
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        caption.endEditing(true)
    }

    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()

            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                } else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        } else {
            // No location was available.
            completionHandler(nil)
        }
    }

    @IBAction func share(_ sender: UIBarButtonItem) {

        let caption = self.caption.textColor == UIColor.lightGray ? "" : (self.caption.text ?? "")
        let location = locationButton.titleLabel!.text ?? ""
        let url = Constants.URL + "/api/photo"
        let imageData = UIImageJPEGRepresentation(self.image!, 0.5)!
        let image = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)

        var parameters: [String: Any] = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "caption": caption,
            "location": location,
            "photo": image,
            "width": Int((self.image?.size.width)!),
            "height": Int((self.image?.size.height)!)
        ]

        if CLLocationManager.locationServicesEnabled() {
            if let (longitude, latitude) = getLongLat(){
                parameters["longitude"] = longitude
                parameters["latitude"] = latitude
            }
        }

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result{
                case .failure(let error):
                    print (error)
                    return
                case .success(_): break
            }
        }

        Util.triggerNotification(name: "dismissUploadPhoto", withData: [:])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        caption.endEditing(true)
    }

    func getLongLat() -> (Double, Double)? {
        if let location = self.locationManager.location {
            return (Double(location.coordinate.longitude), Double(location.coordinate.latitude))
        }
        return nil
    }
}
