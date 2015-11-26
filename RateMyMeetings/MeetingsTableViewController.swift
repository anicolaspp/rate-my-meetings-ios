//
//  MeetingsTableViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/24/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import EventKitUI
import CVCalendar

class MeetingsTableViewController: UIViewController {

    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    var _calendarView: CVCalendarView?
    
    var user: User?
    let eventManager = EventManager()
    var events: [EKEvent] = []
    var selectedCalendar: EKCalendar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.checkCalendarAuthorizationStatus()
        
        self.title = CVDate(date: NSDate()).globalDescription
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
    }
    
    
    @IBAction func showCalendars(sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "Actions", message: "Actions", preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Change Calendar", style: .Default, handler: { (action) -> Void in
            self.showCalendarPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Invite people to this calendar", style: .Default, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
//        showCalendarPicker()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            self.requestAccessToCalendar()
            
            
        case EKAuthorizationStatus.Authorized:
            if (self.eventManager.calendar == nil) {
                self.showCalendarPicker()
            }
            else {
                self.loadEvents(NSDate())
            }
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            self.requestAccessToCalendar()

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
                    //self.showCalendarPicker()
                })
            }
        })
    }
    
    func loadEvents(currentDay: NSDate) {
        self.events = self.eventManager.getEventForDay(currentDay)
        
        self.tableView.reloadData()
    }
    
    func showCalendarPicker()
    {
        let calendarChooser = EKCalendarChooser(selectionStyle: .Single, displayStyle: .AllCalendars, entityType: .Event, eventStore: self.eventManager.eventStore)
        calendarChooser.showsDoneButton = true
        
        calendarChooser.showsCancelButton = self.eventManager.calendar != nil
        calendarChooser.delegate = self
        calendarChooser.modalPresentationStyle = .CurrentContext
      
        let navControllerForCalendarChooser = UINavigationController(rootViewController: calendarChooser)
        
        self.navigationController?.presentViewController(navControllerForCalendarChooser, animated: true, completion: nil)
    }
}

extension MeetingsTableViewController : EKCalendarChooserDelegate {
    
    func calendarChooserDidFinish(calendarChooser: EKCalendarChooser) {
        
        if let calendar = calendarChooser.selectedCalendars.first {
        
            self.eventManager.setCalendar(calendar)
            self.loadEvents(NSDate())
        
            calendarChooser.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            let calendarSelectionAlert = UIAlertController(title: "Selection Error", message: "Please, select a calendar", preferredStyle: .Alert)
            calendarSelectionAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            calendarChooser.presentViewController(calendarSelectionAlert, animated: true, completion: nil)
        }
    }
    
    func calendarChooserDidCancel(calendarChooser: EKCalendarChooser) {
         calendarChooser.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MeetingsTableViewController : CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    func firstWeekday() -> Weekday {
        return .Sunday
    }

    func dayOfWeekTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func presentedDateUpdated(date: CVDate) {
        self.title = date.globalDescription
        
        let currentDate = date.convertedDate()?.atMidnight()
        
        print(currentDate)
        
        self.loadEvents(currentDate!)
    }
}

extension MeetingsTableViewController :  UITableViewDataSource, UITableViewDelegate {
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
}


