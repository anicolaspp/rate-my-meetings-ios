//
//  EventManager.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/24/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import EventKit
import Parse

class EventManager {
    let eventStore: EKEventStore
    var eventsAccessGranted: Bool
    var calendar: EKCalendar?
    
    init() {
        self.eventStore = EKEventStore()
       
        let userDeaults = NSUserDefaults()
        
        if let key = userDeaults.valueForKey("eventkit_events_access_granted") {
            self.eventsAccessGranted = key as! Bool
        }
        else {
            self.eventsAccessGranted = false
        }
        
        self.setStoredCalendar()
    }
    
    private func setStoredCalendar() {
        
        let user = PFUser.currentUser() as! User
        
        if let id = user.inUseCalendarId {
            let query = PFQuery(className: Calendar.parseClassName())
            query.whereKey("objectId", equalTo: id)
            
            do {
                let result = try query.findObjects().first as? Calendar
                
                if let calendarid = result?.localEntity {
                    self.calendar = self.eventStore.calendarWithIdentifier(calendarid)
                }
            }
            catch let excep as NSError {
                print(excep)
            }
        }
    }
    
    func setEventsAccessGranted(accessGranted: Bool) {
        let userDeaults = NSUserDefaults()

        userDeaults.setValue(accessGranted, forKey: "eventkit_events_access_granted")
    }
    
    func getLocalEventCalendars() -> [EKCalendar] {
        let calendars = eventStore.calendarsForEntityType(.Event) 
        
        return calendars
    }
    
    func getSyncCalendarNames() -> [String]? {
        
        let userDeaults = NSUserDefaults()
        
        return userDeaults.valueForKey("eventkit_events_sync_calendars") as? [String]
    }
    
    func getEventsWithInitialMonth(monthsAgo: Int, monthsInTheFuture: Int) -> [EKEvent] {
        let calendar = NSCalendar.currentCalendar()
        
        let oneMonthAgoComponnents = NSDateComponents()
        let oneMonthAgo = calendar.dateByAddingComponents(oneMonthAgoComponnents, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)
        
        let oneMonthFromNowComponnent = NSDateComponents()
        oneMonthFromNowComponnent.day = monthsInTheFuture
        
        let oneMonthFromNow = calendar.dateByAddingComponents(oneMonthFromNowComponnent, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)
        let predicate = eventStore.predicateForEventsWithStartDate(oneMonthAgo!, endDate: oneMonthFromNow!, calendars: [self.calendar!])
        
        let events = eventStore.eventsMatchingPredicate(predicate)
        
        return events
    }
    
    func getEventForDay(day: NSDate) -> [EKEvent] {

        let todayComponnents = day.atMidnight()
        let tomorrowComponnent = NSDate(timeInterval: NSTimeInterval.init(86400), sinceDate: day)
        let predicate = eventStore.predicateForEventsWithStartDate(todayComponnents, endDate: tomorrowComponnent, calendars: [self.calendar!])
        let events = eventStore.eventsMatchingPredicate(predicate)
        
        return events
    }
    
    func setCalendar(calendar: EKCalendar) {

        let user = PFUser.currentUser() as! User
        let query = PFQuery(className: Calendar.parseClassName())
        
        query
            .whereKey("owner", equalTo: PFUser(withoutDataWithObjectId: user.objectId))
            .whereKey("localEntity", equalTo: calendar.calendarIdentifier)
        
        query.getFirstObjectInBackgroundWithBlock { (rcalendar, error) -> Void in
            if let remoteCalendar = rcalendar {
                print("Calendar Found")
                
                user.inUseCalendarId = remoteCalendar.objectId
                user.saveInBackground()
            }
            else {
                let pfcalendar = Calendar()
                
                pfcalendar.owner = user
                pfcalendar.name = calendar.title
                pfcalendar.localEntity = String( calendar.calendarIdentifier )
                
                pfcalendar.saveInBackgroundWithBlock({ (saved, savingError) -> Void in
                    user.inUseCalendarId = pfcalendar.objectId
                    user.saveInBackground()
                })
            }
        }
        
        self.calendar = calendar
    }
    
    func saveEvents(events: [EKEvent]) {
        // save on user online profile
    }
}






