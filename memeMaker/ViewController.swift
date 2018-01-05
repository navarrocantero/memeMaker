//
//  ViewController.swift
//  memeMaker
//
//  Created by navarrocantero on 02/01/2018.
//  Copyright © 2018 ___joseantonionavarrocantero___. All rights reserved.
//

import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

// String constants
    let TOP: String = "TOP"
    let BOTTOM: String = "BOTTOM"

    var control = false

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var UITopText: UITextField!
    @IBOutlet weak var UIbottomText: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    @IBOutlet weak var UIToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UITopText.text = TOP
        UIbottomText.text = BOTTOM
        self.UITopText.delegate = self;
        self.UIbottomText.delegate = self;
    }

    override func viewWillAppear(_ animated: Bool) {

        print("viewWillAppear")
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

        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)

    }

    // Select a image from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        print("pickImageFromCamera")

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    // Share the finaly meme @objc
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            self.dismiss(animated: true, completion: nil)
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

        view.frame.origin.y = 0 - getKeyboardHeight(notification)
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
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIToolBar.isHidden = false


        return memedImage
    }

    func save() {
        print("save")

        // Create the meme
        let memedImage = generateMemedImage()
        let _ = Meme(topText: UITopText.text!,
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

