//
//  FirstViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/18/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import EventKit

class FirstViewController: UIViewController {

    @IBOutlet weak var calendar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func accessToCalendar(sender: AnyObject) {
        
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
}

