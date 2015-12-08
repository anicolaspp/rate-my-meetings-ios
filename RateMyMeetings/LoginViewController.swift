//
//  LoginViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import Parse
import LocalAuthentication

import SwiftKeychainWrapper


class LoginViewController: UIViewController {
    
    var userRepository = UserRepositoryStub()
    var userId = 0
    
    var loginViewController: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()

        PFUser.logOutInBackground()
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
        }
    }
    
    @IBAction func loginUser(sender: AnyObject) {
        
        self.loginViewController = getLoginForm()
        
        self.presentViewController(loginViewController!, animated: true) { () -> Void in
            let returningUser = NSUserDefaults.standardUserDefaults().boolForKey("logged")
            
            if returningUser == true {
                
                let authContext = LAContext()
                var err: NSError?
                
                if authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &err) {
                    authContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Fast and secure login", reply: { (access, error) -> Void in
                        if access {
                            if let userName = NSUserDefaults.standardUserDefaults().stringForKey("username"){
                                if let pass = KeychainWrapper.stringForKey(kSecValueData as String) {
                                    self.loginUserAsync(userName, password: pass)
                                }
                            }
                        }
                        else {
                            // If authentication failed then show a message to the console with a short description.
                            // In case that the error is a user fallback, then show the password alert view.
                            print(error?.localizedDescription)
                            
                            switch error!.code {
                                
                            case LAError.SystemCancel.rawValue:
                                print("Authentication was cancelled by the system")
                                
                            case LAError.UserCancel.rawValue:
                                print("Authentication was cancelled by the user")
                                
                            case LAError.UserFallback.rawValue:
                                print("User selected to enter custom password")
                               
                                
                            default:
                                print("Authentication failed")
                               
                            }
                        }
                    })
                    
                    
                }
            }
        }
    }
    
    func loadMainAppPageFor(user: User) {
        
        let tabController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTabController") as! MainTabBarViewController
        tabController.user = user
        
        self.presentViewController(tabController, animated: true, completion: nil)
    }
    
    func loginUserAsync(userName: String?, password: String?) {
        self.executeAsyncWithIndicator(UIActivityIndicatorView(),
            action: { () -> AnyObject? in
                
                let loginTask = PFUser.logInWithUsernameInBackground(userName!, password: password!)
                loginTask.waitUntilFinished()
                
                let user = PFUser.currentUser()
                
                if let _ = user?.objectId {
                    return user
                }
                
                return nil
                
            }, completion: { (result) -> Void in
                
                if let user = result as? User {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "logged")
                    NSUserDefaults.standardUserDefaults().setValue(user.email, forKey: "username")
                    
                    KeychainWrapper.setString(password!, forKey: kSecValueData as String)
                    
                    self.loginViewController?.dismissViewControllerAnimated(true, completion: nil)
                    self.loadMainAppPageFor(user)
                }
                else {
                    self.showAlert("Error", message: "Invalid user or password", handler: nil)
                }
        })
    }
    
    func getLoginForm() -> UIAlertController {
        
        let login = UIAlertController(title: "Login", message: "Enter Credentials", preferredStyle: .Alert)
        
        login.addTextFieldWithConfigurationHandler { (field: UITextField) -> Void in
            
            field.placeholder = "User Name"
            field.keyboardType = .EmailAddress
        }
        
        login.addTextFieldWithConfigurationHandler { (field) -> Void in
            
            field.placeholder = "Password"
            field.secureTextEntry = true
        }
        
        let ok = UIAlertAction(title: "Login", style: .Default) { (taction) -> Void in
            let user = login.textFields?[0].text
            let pass = login.textFields?[1].text
            
            self.loginUserAsync(user, password: pass)
        }
        
        login.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        login.addAction(ok)
        
        return login
    }
}