//
//  UploadPhotoViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 20/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class SelectPhotoViewController: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nextButton: UIBarButtonItem!

    private let imageView = UIImageView()

    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default

    private var croppedRect = CGRect.zero
    private var croppedAngle = 0

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else {
            return
        }

        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self

        self.image = image

        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
            //self.navigationController!.pushViewController(cropController, animated: true)
        })

        nextButton.isEnabled = true
    }

    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }

    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }

    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        layoutImageView()

        self.navigationItem.rightBarButtonItem?.isEnabled = true

        imageView.isHidden = true

        cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
            toView: imageView,
            toFrame: CGRect.zero,
            setup: { self.layoutImageView() },
            completion: { self.imageView.isHidden = false })
    }

    override func viewWillAppear(_ animated: Bool) {
        if (self.image == nil) {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.isTranslucent = false
        selectImage()
        NotificationCenter.default.addObserver(self, selector: #selector(selectImage), name: NSNotification.Name(rawValue: "selectImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissUploadPhoto), name: NSNotification.Name(rawValue: "dismissUploadPhoto"), object: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false

        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit

        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
        view.addSubview(imageView)

        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapRecognizer)

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(cancelUpload))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeRecognizer)


    }

    @objc func cancelUpload() {
        if (self.image == nil) {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc func dismissUploadPhoto() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }


    @objc public func selectImage() {
        let alertController = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.croppingStyle = .default

            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }

        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.croppingStyle = .default

            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }

        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alertController.modalPresentationStyle = .popover
        present(alertController, animated: true, completion: nil)
    }

    @objc public func didTapImageView() {
        // When tapping the image view, restore the image to the previous cropping state
        let cropViewController = CropViewController(croppingStyle: self.croppingStyle, image: self.image!)
        cropViewController.delegate = self
        let viewFrame = view.convert(imageView.frame, to: navigationController!.view)

        cropViewController.presentAnimatedFrom(self,
            fromImage: self.imageView.image,
            fromView: nil,
            fromFrame: viewFrame,
            angle: self.croppedAngle,
            toImageFrame: self.croppedRect,
            setup: { self.imageView.isHidden = true },
            completion: nil)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutImageView()
    }

    public func layoutImageView() {
        guard imageView.image != nil else {
            return
        }

        let padding: CGFloat = 20.0

        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))

        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;

        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        } else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }

    @IBAction func gotoFilter(_ sender: UIBarButtonItem) {
//        print("go")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotofilter" {
            if let destinationVC = segue.destination as? ProcessViewController {
                let imageData = UIImageJPEGRepresentation(self.imageView.image!, 0.1)!
                destinationVC.image = UIImage(data: imageData)
            }
        }
    }
}

