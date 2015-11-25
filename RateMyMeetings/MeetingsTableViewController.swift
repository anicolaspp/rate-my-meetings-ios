//
//  MeetingsTableViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/24/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import EventKitUI

class MeetingsTableViewController: UITableViewController {

    var user: User?
    let eventManager = EventManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.requestAccessToEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestAccessToEvents() {
        self.eventManager.eventStore.requestAccessToEntityType(EKEntityType.Event) { (granted, error) -> Void in
        
            if (error == nil) {
                self.eventManager.eventsAccessGranted = granted
                self.eventManager.setEventsAccessGranted(granted)
            }
        }
        
    }
    
    func accessToCalendar() {
        let store = EKEventStore()
        store.requestAccessToEntityType(EKEntityType.Event) { (accessGranted, error) -> Void in
            
            if (accessGranted) {
                
                let calendar = NSCalendar.currentCalendar()
                
                let oneDayAgoComponnents = NSDateComponents()
                oneDayAgoComponnents.day = -1
                
                let oneDayAgo = calendar.dateByAddingComponents(oneDayAgoComponnents, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)
                
                let oneYearFromNowComponnent = NSDateComponents()
                oneYearFromNowComponnent.year = 1
                
                let oneYearFromNow = calendar.dateByAddingComponents(oneYearFromNowComponnent, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)
                
                let predicate = store.predicateForEventsWithStartDate(oneDayAgo!, endDate: oneYearFromNow!, calendars:  nil)
                
                let events = store.eventsMatchingPredicate(predicate)
                
                let firstTittle = events[0].title
                
                
                
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                let alertController = UIAlertController(title: "Alert", message: firstTittle, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(alertAction)
                
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
