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
    @IBOutlet weak var domainNameField: UITextField!
    
    @IBOutlet var tabRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        companyNameField.returnKeyType = .Next
        domainNameField.returnKeyType = .Next
        
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
        
        if (companyNameField.text?.isEmpty == true && domainNameField.text?.isEmpty == true){
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
        domainNameField.resignFirstResponder()
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let step2 = segue.destinationViewController as! Step2ViewController
        
        step2.companyName = self.companyNameField.text
        step2.domainName = self.domainNameField.text
        
    }


}

extension RegistrationViewController : UITextFieldDelegate {
    
     func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if (textField == companyNameField) {

            domainNameField.becomeFirstResponder()
        }
        else if (textField == domainNameField) {
            
            self.performSegueWithIdentifier("registreationStep2Segue", sender: self)
        }
        
        return true
    }
}
