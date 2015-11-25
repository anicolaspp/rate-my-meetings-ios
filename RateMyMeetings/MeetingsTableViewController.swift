//
//  MeetingsTableViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/24/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import EventKitUI

class MeetingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var user: User?
    let eventManager = EventManager()
    var events: [EKEvent] = []
    var selectedCalendar: EKCalendar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.checkCalendarAuthorizationStatus()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showCalendars(sender: UIBarButtonItem) {
        showCalendarPicker()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            self.requestAccessToCalendar()
            
        case EKAuthorizationStatus.Authorized:
            self.requestAccessToCalendar()
//
            return
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            // We need to help them give us permission
//            needPermissionView.fadeIn()
            return
        }
    }
    
    
    
    func requestAccessToCalendar() {
        self.eventManager.eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                   self.showCalendarPicker()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    //self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    func loadEvents() {
        self.events = self.eventManager.getEventsWithInitialMonth(1, monthsInTheFuture: 1)
        self.tableView.reloadData()
    }
    
    func showCalendarPicker()
    {
        let calendarChooser = EKCalendarChooser(selectionStyle: .Single, displayStyle: .AllCalendars, entityType: .Event, eventStore: self.eventManager.eventStore)
        calendarChooser.showsDoneButton = true
        calendarChooser.delegate = self
    
        self.navigationController?.pushViewController(calendarChooser, animated: true)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = self.events[indexPath.row].title

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MeetingsTableViewController : EKCalendarChooserDelegate {
    func calendarChooserDidFinish(calendarChooser: EKCalendarChooser) {
        self.eventManager.calendar = calendarChooser.selectedCalendars.first
        self.loadEvents()
        
        calendarChooser.navigationController?.popViewControllerAnimated(true)
    }
}


