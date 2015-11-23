//
//  RegistrationViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit



class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var companyNameField: UITextField!
    @IBOutlet var tabRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var cancelButton: UIButton!
    
    var userRepository: IUserRepository?
    var delegate: UserRegistrationCompleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        companyNameField.returnKeyType = .Search
        
        tabRecognizer.cancelsTouchesInView = false
        tabRecognizer.addTarget(self, action: Selector("dismissKeyBoard"))
        
        cancelButton.layer.cornerRadius = 2
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = cancelButton.titleColorForState(.Normal)?.CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButton(sender: AnyObject) {
        
        if (companyNameField.text?.isEmpty == true) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let confirmation = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel? Your info will be lost.", preferredStyle: .Alert)
        
        confirmation.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        confirmation.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))

        self.presentViewController(confirmation, animated: true, completion: nil)
    }
    
    func dismissKeyBoard() {
        companyNameField.resignFirstResponder()
    }
    
    func isValidEmail(email: String) -> Bool {
        let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", pattern)
        return emailTest.evaluateWithObject(email)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
       
        if (identifier == "findTeamsSegue") {
            let teamToFiend = self.companyNameField.text
            
            if (teamToFiend?.isEmpty == true || isValidEmail(teamToFiend!) == false) {
                
                let alert = UIAlertController(title: "Error", message: "Check email entered", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }
            else{
                return true
            }
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "findTeamsSegue") {
            let teamToFiend = self.companyNameField.text
            
            let table = segue.destinationViewController as! FindTeamsTableViewController
            table.teamName = teamToFiend
            
        }
    }


}

extension RegistrationViewController : UITextFieldDelegate {
    
     func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (self.shouldPerformSegueWithIdentifier("findTeamsSegue", sender: self)) {
            self.performSegueWithIdentifier("findTeamsSegue", sender: self)
        }
        
        return true
    }
}
