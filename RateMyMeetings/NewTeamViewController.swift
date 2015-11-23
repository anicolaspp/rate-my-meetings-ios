//
//  NewTeamViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class NewTeamViewController: UIViewController {

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
        //create new team and login
        
        
    }
}

extension NewTeamViewController : UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (string.containsString("@")) {
            return false
        }
        
        if (textField.text!.characters.count + string.characters.count > 15) {
            return false
        }
        
        return true
    }
}
