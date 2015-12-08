//
//  LoginViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import LocalAuthentication

import SwiftKeychainWrapper



class LoginViewController: UIViewController {
    
    var userRepository = UserRepository()
    var userId = 0
    
    var loginViewController: PFLogInViewController?
    
    var usePassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        PFUser.logOutInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerNewUser(sender: AnyObject) {
        let registerViewController = PFSignUpViewController()
        registerViewController.delegate = self
        registerViewController.emailAsUsername = true
        
        self.presentViewController(registerViewController, animated: true, completion: nil)
    }
    @IBAction func loginUser(sender: AnyObject) {
        
        self.loginViewController = getLoginForm()
        
        self.presentViewController(loginViewController!, animated: true) { () -> Void in
            let returningUser = NSUserDefaults.standardUserDefaults().boolForKey("logged")
            
            if returningUser == true {
                self.accessingTouchId()
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
                
                let user = self.userRepository.longin(userName, password: password)
                
                if let _ = user?.objectId {
                    return user
                }
                
                return nil
                
            }, completion: { (result) -> Void in
                
                if let user = result as? User {
                    self.storeCredentials(user, pass: password!)
                
                    self.loginViewController?.dismissViewControllerAnimated(true, completion: nil)
                    self.loadMainAppPageFor(user)
                }
                else {
                    self.showAlert("Error", message: "Invalid user or password", handler: nil)
                }
        })
    }
    
    func getLoginForm() -> PFLogInViewController {
        
        let logInViewController = PFLogInViewController()
        logInViewController.delegate = self
        logInViewController.fields = [.UsernameAndPassword, .LogInButton, .PasswordForgotten, .DismissButton]
        logInViewController.emailAsUsername = true
        
        return logInViewController
    }
    
    func storeCredentials(user: User, pass: String) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "logged")
        NSUserDefaults.standardUserDefaults().setValue(user.email, forKey: "username")
        
        KeychainWrapper.setString(pass, forKey: kSecValueData as String)
    }
    
    func accessingTouchId() {
        let authContext = LAContext()
        var err: NSError?
        
        if authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &err) {
            authContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Fast and secure login", reply: { (access, error) -> Void in
                if access {
                    self.logingWithStoredCredentials()
                }
                else {
                    self.handleTouchIdFailure(error)
                }
            })
        }
    }
    
    func logingWithStoredCredentials() {
        if let userName = NSUserDefaults.standardUserDefaults().stringForKey("username") {
            if let pass = KeychainWrapper.stringForKey(kSecValueData as String) {
                
                self.loginUserAsync(userName, password: pass)
            }
        }
    }
    
    func handleTouchIdFailure(error: NSError?) {
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
}

extension LoginViewController : PFLogInViewControllerDelegate {
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        self.usePassword = password
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        if let loggedUser = user as? User {
            self.storeCredentials(loggedUser, pass: self.usePassword!)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.loadMainAppPageFor(loggedUser)
        }
        else {
            self.showAlert("Error", message: "Invalid user or password", handler: nil)
        }
    }
}

extension LoginViewController : PFSignUpViewControllerDelegate {
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        let userExistsAlert = UIAlertController(title: "Registration Failed", message: "Seems you have an account already!", preferredStyle: .Alert)
        
        userExistsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(userExistsAlert, animated: true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        let registrationDoneAlert = UIAlertController(title: "Registration Completed", message: "Check your email to verify your account.", preferredStyle: .Alert)
        
        registrationDoneAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        signUpController.presentViewController(registrationDoneAlert, animated: true, completion: nil)
    }
}
