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
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
             
    }


}

//extension RegistrationViewController : UserRegistrationCompleteDelegate {
//    func registrationComplete(user: User?) -> Void {
//        self.dismissViewControllerAnimated(true) { () -> Void in
//            self.delegate?.registrationComplete(user)
//        }
//        
//    }
//}

extension RegistrationViewController : UITextFieldDelegate {
    
     func textFieldShouldReturn(textField: UITextField) -> Bool {
        
//        textField.resignFirstResponder()
//        
//        if (textField == self.companyNameField) {
//            
//            if (companyNameField.text?.isEmpty == true) {
//                
//                let alert = UIAlertController(title: "Error", message: "Fill required information", preferredStyle: .Alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                    
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
//            else {
//                self.performSegueWithIdentifier("registreationStep2Segue", sender: self)
//            }
//
//        }
        
        return true
    }
}
