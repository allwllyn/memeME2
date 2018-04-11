//
//  ViewController.swift
//  memeME2
//
//  Created by Andrew Llewellyn on 4/7/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import UIKit

class memeEditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var highText: UITextField!
    
    @IBOutlet weak var lowText: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var highToolBar: UIToolbar!
    
    @IBOutlet weak var lowToolBar: UIToolbar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        configureText(text: highText, startText: "TOP")
        
        configureText(text: lowText,startText: "BOTTOM")
        
        shareButton.isEnabled = false
        
        imageView.contentMode = .scaleAspectFit
    }
    
    // MARK: Subscribe to keyboard notifications
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        subscribeKeyboardNotifications()
    }

    // MARK: unsubscribe from keyboard notifications
    override func viewWillDisappear(_ animated: Bool)
    {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Configure the default text
    func configureText (text: UITextField, startText: String)
    {
        
        let memeTextAttributes: [String: Any] =
        [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "Helvetica", size: 60)!,
            NSAttributedStringKey.strokeWidth.rawValue : -3.0,
        ]
        
        text.delegate = self
        text.clearsOnBeginEditing = true
        text.enablesReturnKeyAutomatically = true
        text.defaultTextAttributes = memeTextAttributes
        text.textAlignment = .center
        text.autocapitalizationType = .allCharacters
        text.text = startText
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Clear default text
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textFieldShouldClear(textField)
    }
    
    // MARK: Clear default text method
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        if textField.text == "TOP"
        {
            return true
        }
        if textField.text == "BOTTOM"
        {
            return true
        }
        else {return false}
    }
    
    func presentPicker (source: UIImagePickerControllerSourceType)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImage(_ sender: Any)
    {
        presentPicker(source: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.image = image
            dismiss(animated: true, completion: nil)
            shareButton.isEnabled = true
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification)
    {
        if lowText.isFirstResponder == true
        {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification)
    {
        view.frame.origin.y = 0
    }
    
    func subscribeKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
    }
    
    func save()
    {
        // Create the meme
        let meme = Meme(topText: highText.text!, bottomText: lowText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        (UIApplication.shared.delegate as! AppDelegate).myMemes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
        highToolBar.isHidden = true
        lowToolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        highToolBar.isHidden = false
        lowToolBar.isHidden = false
        
        return memedImage
        
    }
    
    @IBAction func makeMeme(_ sender: Any)
    {
        generateMemedImage()
        
        let shareController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities:[])
        
        present(shareController, animated: true, completion:nil)
        
        shareController.completionWithItemsHandler =
        {
                (actvity, completed, items, error) -> Void in
                if (completed)
                {
                    self.save()
                }
        }
    }
    
    
}

