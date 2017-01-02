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
    
    @IBAction func loginButton(sender: UIButton) {
        //First, get e-mail and password from associated text fields
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (email == nil || password == nil) {
            return;
        }
        
        let data: [String:String] = ["email": email!, "password": password!]
        
        APIHandler().makeHTTPRequest("/login", method: APIHandler.HTTPMethod.POST, data: data, onCompleted: {
            (data: AnyObject, response: NSURLResponse?, error: NSError?) in
            //TODO Move to next view
            let success = data["success"] as! Bool
            if (success) {
                //Save token:
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(data["token"], forKey: "token")
                
                //Move to next view:
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("gotoHomepageView", sender: nil)
                }
            } else {
                print("FAILURE")
            }

        })
    }

}

