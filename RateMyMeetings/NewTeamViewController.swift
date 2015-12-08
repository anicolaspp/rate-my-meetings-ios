//
//  NewTeamViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class NewTeamViewController: UIViewController {

    let teamRepository: ICompanyRepository = CompanyRepositoryStub()
    
    var user: User?
    
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var teamNameField: UITextField!
    
    var delegate: TeamDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ownerLabel.text = user?.email
        domainLabel.text = user?.email!.componentsSeparatedByString("@")[1]
        
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
        let team = teamRepository.team(teamNameField.text!, shouldBeCreateWithOwner: self.user!)
        
        self.delegate?.didCreateTeam(team)
        
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
