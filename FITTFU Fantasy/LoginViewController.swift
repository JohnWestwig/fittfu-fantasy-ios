//
//  ViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 12/31/16.
//  Copyright © 2016 John Westwig. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //test
    }
    //MARK: Actions
    
    @IBAction func loginButton(_ sender: UIButton) {
        //First, get e-mail and password from associated text fields
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (email == nil || password == nil) {
            return;
        }
        
        let data: [String:String] = ["email": email!, "password": password!]
        
        APIHandler().makeHTTPRequest("/login", method: APIHandler.HTTPMethod.post, data: data, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                //Save token:
                let defaults = UserDefaults.standard
                defaults.set(data["token"] ?? "Invalid token", forKey: "token")
                
                //Move to next view:
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "gotoHomepageView", sender: nil)
                }
            } else {
                print("FAILURE")
            }

        })
    }

}

