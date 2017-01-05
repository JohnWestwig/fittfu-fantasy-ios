//
//  LoginViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 12/31/16.
//  Copyright © 2016 John Westwig. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    struct TokenAuth {
        static let tokenDefault = "InvalidTokenIOS"
        static let tokenKey = "token"
    }
    
    //MARK: Properties

    @IBOutlet weak var myEmailTextField: UITextField!
    @IBOutlet weak var myPasswordTextField: UITextField!
    @IBOutlet weak var myLoginButton: UIButton!
    @IBOutlet weak var myRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login view did load")
        
        attemptAutoLogin()
        
        myEmailTextField.delegate = self
        myPasswordTextField.delegate = self
        
        //Button styling:
        styleButtons(buttons: [myLoginButton, myRegisterButton])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == myEmailTextField {
            myPasswordTextField.becomeFirstResponder()
            return false
        } else if textField == myPasswordTextField {
            login(sender: self)
            return true
        }
        return true
    }
    
    //MARK: Actions
    @IBAction func loginButton(_ sender: UIButton) {
        login(sender: sender)
    }
    
    @IBAction func myRegisterButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "gotoRegisterView", sender: self)
    }
    
    private func login (sender: Any) {
        let email = myEmailTextField.text
        let password = myPasswordTextField.text
        
        if (email == nil || password == nil) {
            return
        }
        
        let data: [String:String] = ["email": email!, "password": password!]
        APIHandler().makeHTTPRequest("/login", method: APIHandler.HTTPMethod.post, data: data, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                //Save token:
                let defaults = UserDefaults.standard
                defaults.set(data["token"] ?? TokenAuth.tokenDefault, forKey: TokenAuth.tokenKey)
                //Perform segue:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "gotoLeagueView", sender: sender)
                }
            } else {
                let errorCode = data["errorCode"] as! Int
                switch (errorCode) {
                case 2: //Email
                    self.showAlert(title: "Could not log in", message: "Email not found")
                    break
                case 4: //Password
                    self.showAlert(title: "Could not log in", message: "Password incorrect")
                    break
                default:
                    self.showAlert(title: "Could not log in", message: "Double check your email and password")
                    break
                }
            }
        })
    }
    
    private func attemptAutoLogin() {
        APIHandler().makeHTTPRequest("/api/validateToken", method: APIHandler.HTTPMethod.get, data: nil) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "gotoLeagueView", sender: self)
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
    
    private func showAlert (title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

