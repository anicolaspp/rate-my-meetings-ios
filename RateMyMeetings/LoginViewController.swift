//
//  LoginViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    var userRepository = UserRepositoryStub()
    var userId = 0
    var loggedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLoginForm() -> UIAlertController {
        
        let login = UIAlertController(title: "Login", message: "Enter Credentials", preferredStyle: .Alert)
        
        login.addTextFieldWithConfigurationHandler { (field: UITextField) -> Void in
            
            field.placeholder = "User Name"
        }
        
        login.addTextFieldWithConfigurationHandler { (field) -> Void in
            
            field.placeholder = "Password"
            field.secureTextEntry = true
        }
        
        let ok = UIAlertAction(title: "Login", style: .Default) { (taction) -> Void in
            let user = login.textFields?[0].text
            let pass = login.textFields?[1].text
            
            if let user = self.userRepository.longin(user, password: pass) {
                self.loggedUser = user
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
                self.showAlert("Error", message: "Invalid user or password", handler: nil)
            }
        }

        login.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        login.addAction(ok)
        
        return login
    }
    
    @IBAction func loginUser(sender: AnyObject) {
       
        let loginForm = getLoginForm()
        self.presentViewController(loginForm, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "registrationSegue") {
            let target = segue.destinationViewController as! UINavigationController
            let registrationController = target.viewControllers.first as! UserVerificationViewController
            registrationController.userRepository = self.userRepository
            registrationController.delegate = self
        
            print("here\n")
        }
        
        if (segue.identifier == "loginSegue") {
            let target = (segue.destinationViewController as! UITabBarController).viewControllers?.first as! UINavigationController
            let main = target.viewControllers.first as! FirstViewController
            
            main.loggedUser = loggedUser
        }
    }
}

extension LoginViewController : UserRegistrationCompleteDelegate {
    
    func registrationComplete(user: User?) -> Void {
        self.loggedUser = user
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: handler))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
