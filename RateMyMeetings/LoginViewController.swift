//
//  LoginViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {
    
    var userRepository = UserRepositoryStub()
    var userId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
    //        print("here\n")
        }
    }
    
    @IBAction func loginUser(sender: AnyObject) {
        
       let form = getLoginForm()
       self.presentViewController(form, animated: true, completion: nil)
    }
    
    func loadMainAppPageFor(user: User) {
        
        let tabController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTabController")
        
        self.presentViewController(tabController!, animated: true, completion: nil)
    }
    
    func getLoginForm() -> UIAlertController {
        
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
            
            self.executeAsyncWithIndicator(UIActivityIndicatorView(),
                action: { () -> AnyObject? in
                    
                    let user = self.userRepository.longin(user, password: pass)
                    
                    return user

                }, completion: { (result) -> Void in
                    
                    if let user = result as? User {
                        self.loadMainAppPageFor(user)
                    }
                    else {
                        self.showAlert("Error", message: "Invalid user or password", handler: nil)
                    }
            })
        }
        
        login.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        login.addAction(ok)
        
        return login
    }
}