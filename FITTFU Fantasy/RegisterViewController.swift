//
//  registerViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/3/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
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
        
        styleButtons(buttons: [myRegisterButton])
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
        
        let data = ["firstName" : firstName!, "lastName": lastName!, "email": email!, "password": password!]
        print(data)
        APIHandler().makeHTTPRequest("/register", method: APIHandler.HTTPMethod.post, data: data) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                self.showAlert(title: "Good to go!", message: "Hit OK to proceed to login", actionClicked: {() in
                    self.dismiss(animated: true)
                })
            } else {
                let errorCode = data["errorCode"] as! Int
                let alertTitle: String = "Could not register"
                switch (errorCode) {
                case 1: //Unknown error
                    break
                case 2: //Invalid email
                    self.showAlert(title: alertTitle, message: "Email already in use")
                    break
                default: //Unknown error code
                    break
                }
            }
        }
    }
    
    
    private func styleButtons(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 10
            button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        }
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
