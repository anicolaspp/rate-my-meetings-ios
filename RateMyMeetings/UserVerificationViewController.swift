//
//  UserVerificationViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class UserVerificationViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var tabGesture: UITapGestureRecognizer!
    
    var userRepository: IUserRepository = UserRepositoryStub()
    
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
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyBoard() {
        passwordField.resignFirstResponder()
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if (identifier == "createAccountSegue") {
            if (emailField.text?.isValidEmail() == true && passwordField.text?.isEmpty == false) {
                
                let newUser = userRepository.register("", email: emailField.text!, password: passwordField.text!)
                
                if  newUser != nil {
                    let userExistsAlert = UIAlertController(title: "Registration Failed", message: "Seems you have an account already!", preferredStyle: .Alert)
                    userExistsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(userExistsAlert, animated: true, completion: nil)
                    
                    return false
                }
                
                self.newUser = newUser
                
                return true
            }
            else
            {
                let invalidEmail = UIAlertController(title: "Validation Failed", message: "Check your email and password", preferredStyle: .Alert)
                invalidEmail.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(invalidEmail, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "createAccountSegue") {
            let teamLookup = segue.destinationViewController as! FindTeamsTableViewController
                teamLookup.user = newUser
            }
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
        }
        
        return true
    }
}
