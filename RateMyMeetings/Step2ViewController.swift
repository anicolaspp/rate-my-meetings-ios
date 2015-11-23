//
//  Step2ViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/22/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class Step2ViewController: UIViewController {

    
    var companyName: String?
    var domainName: String?
    
    var userRepository: IUserRepository?


    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var delegate: UserRegistrationCompleteDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.domainLabel.text = "@" + domainName!
        self.companyLabel.text = companyName
        
        self.emailLabel.returnKeyType = .Next
        self.passwordLabel.returnKeyType = .Go
        
        self.registerButton.layer.cornerRadius = 2
        self.registerButton.layer.borderWidth = 1
        self.registerButton.layer.borderColor = UIColor.blueColor().CGColor
        
        self.emailLabel.becomeFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser() -> Void {
        
        let user = userRepository?.register(companyName!, email: self.emailLabel.text! + self.domainLabel.text!, password: self.passwordLabel.text!)
        
        self.removeFromParentViewController()
        self.delegate?.registrationComplete(user)
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

extension Step2ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if (textField == emailLabel) {
            
            passwordLabel.becomeFirstResponder()
        }
        else if (textField == passwordLabel) {
         // register here
            
            registerUser()
        }
        
        return true
    }
}
