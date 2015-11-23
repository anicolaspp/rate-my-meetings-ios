//
//  TeamMembersTableViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class TeamMembersTableViewController: UITableViewController {

    var teamName: String?
    var teamMembers: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = teamName
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("joinToThisTeam"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return teamMembers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teamMemberCell", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = teamMembers[indexPath.row].email

        return cell
    }
    
    func joinToThisTeam() -> Void {
        
        let joinConfirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to join this team?", preferredStyle: .Alert)
        joinConfirmationAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) -> Void in
            // request to join
        }))
        joinConfirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(joinConfirmationAlert, animated: true, completion: nil)
    }
}
