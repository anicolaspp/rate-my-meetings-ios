//
//  NewTeamViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class NewTeamViewController: UIViewController {

    var userRepository: IUserRepository?
    var teamRepository: ICompanyRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createNewTeamButton(sender: AnyObject) {
        // Register user
        // Create new team and login
        // Return control to login page to login
        
        // let newUser = userRepository?.register("company", email: "email", password: "password")
        // let newTeam = teamRepository?.team("teamName", shouldBeCreateWithOwner: newUser!)
        
        // Use Delegate to return control 
    }
}

extension NewTeamViewController : UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (string.containsString("@")) {
            return false
        }
        
        if (textField.text!.characters.count + string.characters.count > 25) {
            return false
        }
        
        return true
    }
}
