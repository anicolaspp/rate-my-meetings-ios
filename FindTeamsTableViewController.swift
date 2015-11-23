//
//  FindTeamsTableViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class FindTeamsTableViewController: UITableViewController {

    
    var teamName: String?
    var companyRepository: ICompanyRepository? = CompanyRepositoryStub()
    var teams: [Team]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let domain = teamName?.characters.split(isSeparator: { (Character) -> Bool in
            return Character == "@"
        })[1]
        
        title = String(domain!)
        
        teams = companyRepository?.getTeamsWithDomain(title!)
      
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addNewTeam"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return teams.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("teamCell", forIndexPath: indexPath)

        // Configure the cell...

        cell.textLabel?.text = teams[indexPath.row].name
        
        return cell
    }
   
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "showTeamMembersSegue") {
            if let _ = self.tableView.indexPathForSelectedRow?.row {
                return true
            }
            else {
                return false
            }
        }
         return true
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let teamMembersTable = segue.destinationViewController as! TeamMembersTableViewController
        teamMembersTable.teamMembers = self.teams[self.tableView.indexPathForSelectedRow!.row].members
    }
    
    func addNewTeam() -> Void {
        let newTeamController = self.storyboard?.instantiateViewControllerWithIdentifier("newTeamViewController")
        self.presentViewController(newTeamController!, animated: true, completion: nil)
    }
}
