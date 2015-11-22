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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        companyNameField.returnKeyType = .Next
        domainNameField.returnKeyType = .Go
        
        tabRecognizer.cancelsTouchesInView = false
        tabRecognizer.addTarget(self, action: Selector("dismissKeyBoard"))
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegistrationViewController : UITextFieldDelegate {
    
     func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if (textField == companyNameField) {

            domainNameField.becomeFirstResponder()
        }
        else if (textField == domainNameField) {
            textField.resignFirstResponder()
            
            //attenpt to register company here
        }
        
        return true
    }
    
   
}
