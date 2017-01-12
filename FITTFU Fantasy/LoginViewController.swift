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
        
        attemptAutoLogin()
        myEmailTextField.delegate = self
        myPasswordTextField.delegate = self
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
            login(sender: textField)
            return true
        }
        return true
    }
    
    //MARK: Actions
    @IBAction func loginButton(_ sender: UIButton) {
        login(sender: sender)
    }
    
    @IBAction func myRegisterButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "gotoRegisterView", sender: sender)
    }
    
    private func login (sender: Any) {
        let email = myEmailTextField.text
        let password = myPasswordTextField.text
        
        if (email == nil || password == nil) {
            return
        }
        
        APIMethods.login(email: email!, password: password!, onSuccess: { (token) in
            UserDefaults.standard.set(token, forKey: TokenAuth.tokenKey)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "gotoLeagueView", sender: sender)
            }
        }, onError: { (error) in
            self.showAlert(title: error.message, message: error.details)
        }, senderView: self.view)

    }
    
    private func attemptAutoLogin() {
        APIMethods.validateToken(onSuccess: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "gotoLeagueView", sender: self)
            }
        }, onError: {error in
            print(error)
        }, senderView: self.view)
    }
    
    private func showAlert (title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

