//
//  CalendarsTableViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/24/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import EventKitUI

class CalendarsTableViewController: UITableViewController{

    var calendars: [EKCalendar]?
    
    var dataLoaded = false
    
    var delegate: CalendarSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        dataLoaded = true
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if (dataLoaded){
            return 1
        }
        else
        {
            return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarCell", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = calendars![indexPath.row].title

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCalendar = self.calendars![indexPath.row]
        
        self.delegate?.didSelectCalendar(selectedCalendar)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
