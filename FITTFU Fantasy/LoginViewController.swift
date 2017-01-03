//
//  LoginViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 12/31/16.
//  Copyright © 2016 John Westwig. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties

    @IBOutlet weak var myEmailTextField: UITextField!
    @IBOutlet weak var myPasswordTextField: UITextField!
    @IBOutlet weak var myLoginButton: UIButton!
    @IBOutlet weak var myRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login view did load")
        
        //Button styling:
        styleButtons(buttons: [myLoginButton, myRegisterButton])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    @IBAction func loginButton(_ sender: UIButton) {
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
                defaults.set(data["token"] ?? "InvalidTokenIOS", forKey: "token")
                //Perform segue:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "gotoLeagueView", sender: sender)
                }
            } else {
                //Password or username incorrect
            }
        })
    }
    
    @IBAction func myRegisterButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "gotoRegisterView", sender: self)
    }
    
    
    private func styleButtons(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 10
            button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        }
    }
}

