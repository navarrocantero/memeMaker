//
//  ViewController.swift
//  memeMaker
//
//  Created by navarrocantero on 02/01/2018.
//  Copyright © 2018 ___joseantonionavarrocantero___. All rights reserved.
//

import UIKit


struct GeneratedMeme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

// String constants
    let TOP: String = "TOP"
    let BOTTOM: String = "BOTTOM"
    let CAMERA: String = "CAMERA"
    let PHOTOLIBRARY: String = "PHOTOLIBRARY"

    var control: Bool = false


    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var UITopText: UITextField!
    @IBOutlet weak var UIbottomText: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!

    @IBOutlet weak var UIToolBar: UIToolbar!

    let memeTextAttribues = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.strokeWidth.rawValue: NSNumber(value: -4.0),
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UITopText.text = TOP
        UIbottomText.text = BOTTOM

    }

    private func setAttributes(_ UITextField: UITextField!) {
        UITextField.defaultTextAttributes = memeTextAttribues
        UITextField.textAlignment = .center
        UIbottomText.delegate = self
        UITopText.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {

        print("viewWillAppear")


        setAttributes(UITopText)
        setAttributes(UIbottomText)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        actionButton.isEnabled = control

    }

    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDissapear")

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }


    // Select a image from the album
    @IBAction func pickOneImage(_ sender: Any) {
        print("pickAImage")
        pickAnImageFrom(PHOTOLIBRARY)
    }

    // Select a image from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        print("pickImageFromCamera")
        pickAnImageFrom(CAMERA)
    }

    @IBAction func cancelMeme(_ sender: Any) {
        UITopText.text = TOP
        UIbottomText.text = BOTTOM
        imageView.image = nil
        control = false;
        actionButton.isEnabled = control
    }

    private func pickAnImageFrom(_ string: String) {


        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        if string == CAMERA {
            imagePicker.sourceType = .camera
        } else if string == PHOTOLIBRARY {
            imagePicker.sourceType = .photoLibrary
        }

        present(imagePicker, animated: true, completion: nil)
    }

    // Share the finaly meme @objc
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }

        present(activityController, animated: true, completion: nil)


    }

    // Add image to UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        print("imagePickerController")

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            control = true
        }
        dismiss(animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePIckerControllerDidCancel")

        dismiss(animated: true, completion: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {

        print("keyboardWillShow")
        if UIbottomText.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)

        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        print("keyboardWillHIde")

        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        print("keyboardHeight")

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func subscribeToKeyboardNotifications() {
        print("suscribeTokeyboard")

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        print("unsuscribeKeyboard")

        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func generateMemedImage() -> UIImage {
        print("generatedMeme")

        UIToolBar.isHidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIToolBar.isHidden = false


        return memedImage
    }

    func save() {
        print("save")

        // Create the meme
        let memedImage = generateMemedImage()
        let _ = GeneratedMeme(topText: UITopText.text!,
                bottomText: UIbottomText.text!,
                originalImage: imageView.image!,
                memedImage: memedImage)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditting")
        let inputText = String(textField.text!)
        print(inputText)

        if inputText == TOP {
            UITopText.text = ""
        } else if inputText == BOTTOM {
            UIbottomText.text = ""
        }
    }
}

