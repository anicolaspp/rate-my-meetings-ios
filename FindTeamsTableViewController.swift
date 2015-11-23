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
        // Load team for domain
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
     
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
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
