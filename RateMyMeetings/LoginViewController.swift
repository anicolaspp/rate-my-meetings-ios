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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "registrationSegue") {
            let target = segue.destinationViewController as! UINavigationController
            let registrationController = target.viewControllers.first as! UserVerificationViewController
            registrationController.userRepository = self.userRepository
        
            print("here\n")
        }
        
        if (segue.identifier == "loginSegue") {
            let target = (segue.destinationViewController as! UITabBarController).viewControllers?.first as! UINavigationController
            let main = target.viewControllers.first as! FirstViewController
            
            main.loggedUser = loggedUser
        }
    }
    
    @IBAction func loginUser(sender: AnyObject) {
        
        let loginForm = getLoginForm()
        self.presentViewController(loginForm, animated: true, completion: nil)
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
}


extension UIViewController {
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: handler))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension UIViewController {

    func executeAsyncWithIndicator(activityIndicator: UIActivityIndicatorView, action: () -> AnyObject?, completion: (result: AnyObject?) -> Void) {
        showActivityIndicatory(activityIndicator, uiView: self.view)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
          
            let result = action()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                activityIndicator.stopAnimating()
                self.view.userInteractionEnabled = true
                
                completion(result: result)
            })
        })
    }
    
    func showActivityIndicatory(activityIndicator: UIActivityIndicatorView, uiView: UIView) {
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        activityIndicator.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        
        self.view.userInteractionEnabled = false
        
        activityIndicator.startAnimating()
        uiView.addSubview(activityIndicator)
    }
}