//
//  registerViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/3/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    static let firstNameMaxLength = 32
    static let lastNameMaxLength = 32
    static let emailMaxLength = 64
    static let passwordMaxLength = 32
    
    //MARK: Properties
    @IBOutlet weak var myFirstNameTextField: UITextField!
    @IBOutlet weak var myLastNameTextField: UITextField!
    @IBOutlet weak var myEmailTextField: UITextField!
    @IBOutlet weak var myPasswordTextField: UITextField!
    @IBOutlet weak var myRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myFirstNameTextField.delegate = self
        myLastNameTextField.delegate = self
        myEmailTextField.delegate = self
        myPasswordTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == myFirstNameTextField) {
            myLastNameTextField.becomeFirstResponder()
            return false;
        } else if (textField == myLastNameTextField) {
            myEmailTextField.becomeFirstResponder()
            return false;
        } else if (textField == myEmailTextField) {
            myPasswordTextField.becomeFirstResponder()
            return false;
        } else if (textField == myPasswordTextField) {
            register()
            return true
        }
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        let newLength = currentCharacterCount + string.characters.count - range.length
        if (textField == myFirstNameTextField) {
            return newLength <= RegisterViewController.firstNameMaxLength
        } else if (textField == myLastNameTextField) {
            return newLength <= RegisterViewController.lastNameMaxLength
        } else if (textField == myEmailTextField) {
            return newLength <= RegisterViewController.emailMaxLength
        } else if (textField == myPasswordTextField) {
            return newLength <= RegisterViewController.passwordMaxLength
        }
        
        return false
    }
    
    //MARK: Actions
    @IBAction func myDoneButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myRegisterButtonClicked(_ sender: UIButton) {
        register()
    }
    
    private func register() {
        let firstName = myFirstNameTextField.text
        let lastName = myLastNameTextField.text
        let email = myEmailTextField.text
        let password = myPasswordTextField.text
        
        if (firstName == nil || lastName == nil || email == nil || password == nil) {
            return
        }
        
        APIMethods.register(email: email!, password: password!, firstName: firstName!, lastName: lastName!, onSuccess: {
            self.showAlert(title: "Good to go!", message: "Hit OK to proceed to login", actionClicked: {() in
                self.dismiss(animated: true)
            })
        }, onError: { (error) in
            self.showAlert(title: error.message, message: error.details)
        }, senderView: self.view)
    }
    
    private func showAlert (title: String, message: String, actionClicked: (() -> Void)? = {}) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (alert: UIAlertAction!) in
                actionClicked!()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
