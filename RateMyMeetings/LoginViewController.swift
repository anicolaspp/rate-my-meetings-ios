//
//  LoginViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    var userRepository: IUserRepository! = UserRepositoryStub()
    var userId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLogingForm() -> UIAlertController {
        
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
            
            self.userId = self.userRepository!.longin(user, password: pass)
            
            if (self.userId > 0) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
                self.showAlert("Error", message: "Invalid user or password", handler: nil)
            }
        }
        
        login.addAction(ok)
        
        return login
    }
    
    @IBAction func registerNewUser(sender: UIButton) {
       
    }

    @IBAction func loginUser(sender: AnyObject) {
       
        let loginForm = getLogingForm()
        self.presentViewController(loginForm, animated: true, completion: nil)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        
        print("here\n")
        
    }


}

extension UIViewController {
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: handler))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}