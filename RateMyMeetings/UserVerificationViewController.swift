//
//  UserVerificationViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import Parse

class UserVerificationViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var tabGesture: UITapGestureRecognizer!
    
    var userRepository: IUserRepository = UserRepository()
    let activityIndicator = UIActivityIndicatorView()
    
    var delegate: UserRegistrationCompleteDelegate?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        tabGesture.cancelsTouchesInView = false
        tabGesture.addTarget(self, action: Selector("dismissKeyBoard"))
        
        self.view.addGestureRecognizer(tabGesture)
        
        cancelButton.layer.cornerRadius = 2
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = cancelButton.titleColorForState(.Normal)?.CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createAccountButton(sender: AnyObject) {
        runRegistration()
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        if (emailField.text?.isEmpty == false || passwordField.text?.isEmpty == false) {
            
            let confirmation = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel? Your info will be lost.", preferredStyle: .Alert)
            
            confirmation.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            confirmation.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            
            self.presentViewController(confirmation, animated: true, completion: nil)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    var newUser: User?
    
    func dismissKeyBoard() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    func showActivityIndicatory(uiView: UIView) {
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        activityIndicator.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        
        self.view.userInteractionEnabled = false
        
        activityIndicator.startAnimating()
        uiView.addSubview(activityIndicator)
    }
    
    func runRegistration() {
        
        if (validateEmail()) {
        
            executeAsyncWithIndicator(UIActivityIndicatorView(), action: { () -> AnyObject? in
                
                    let newUser = self.userRepository.register(self.emailField.text!, password: self.passwordField.text!)
                
                    return newUser
                
                }, completion: { (result) -> Void in
                    
                    self.newUser = result as? User
                    self.didRegistrationFinish()
            })
        }
    }
    
    func didRegistrationFinish() {
        if (validateUser()) {
            
            // At this point an email has been sent to the new user
            
            let registrationDoneAlert = UIAlertController(title: "Registration Completed", message: "Check your email to verify your account.", preferredStyle: .Alert)
            
            registrationDoneAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(registrationDoneAlert, animated: true, completion: nil)
        }
    }
    
    func validationFailed() {
        let invalidEmail = UIAlertController(title: "Validation Failed", message: "Check your email and password", preferredStyle: .Alert)
        invalidEmail.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(invalidEmail, animated: true, completion: nil)
    }
    
    func registrationFailed() {
        let userExistsAlert = UIAlertController(title: "Registration Failed", message: "Seems you have an account already!", preferredStyle: .Alert)
        userExistsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(userExistsAlert, animated: true, completion: nil)
    }
    
    func validateEmail() -> Bool {
        
        if (emailField.text?.isValidEmail() == false || passwordField.text?.isEmpty == true) {
            validationFailed()
            
            return false
        }
        
        return true
    }
    
    func validateUser() -> Bool {
        let newUser = self.newUser
            
        if  newUser == nil {
            registrationFailed()

            return false
        }
            
        self.newUser = newUser
            
        return true
    }
}

extension UserVerificationViewController : UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
    
        if (textField == emailField) {
        
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else {
            passwordField.resignFirstResponder()
            runRegistration()
        }
        
        return true
    }
}