//
//  EventManager.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/24/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import EventKit

class EventManager {
    let eventStore: EKEventStore
    var eventsAccessGranted: Bool
    var calendar: EKCalendar?
    
    init() {
        self.eventStore = EKEventStore()
       // self.eventStore.sources
        
        let userDeaults = NSUserDefaults()
        
        let calendarToSync = userDeaults.valueForKey("eventkit_events_sync_calendars") as? String
        
        if  (calendarToSync != nil) {
            let calendars = self.eventStore.calendarsForEntityType(.Event)
        
            for c in calendars {
                if (c.title == calendarToSync!) {
                    self.calendar = c
                    break
                }
            }
        }
        
        if let key = userDeaults.valueForKey("eventkit_events_access_granted") {
            self.eventsAccessGranted = key as! Bool
        }
        else {
            self.eventsAccessGranted = false
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
//        oneMonthAgoComponnents. = monthsAgo * -1
        
        let oneMonthAgo = calendar.dateByAddingComponents(oneMonthAgoComponnents, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)
        
        let oneMonthFromNowComponnent = NSDateComponents()
        oneMonthFromNowComponnent.day = monthsInTheFuture
        
        let oneMonthFromNow = calendar.dateByAddingComponents(oneMonthFromNowComponnent, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)
        let predicate = eventStore.predicateForEventsWithStartDate(oneMonthAgo!, endDate: oneMonthFromNow!, calendars: [self.calendar!])
        //let predicate = eventStore.predicateForEventsWithStartDate(NSDate(), endDate: NSDate(), calendars: [self.calendar!])
        
        let events = eventStore.eventsMatchingPredicate(predicate)
        
        return events
    }
    
    func getEventForDay(day: NSDate) -> [EKEvent] {
       // let calendar = NSCalendar.currentCalendar()
        
        //let todayComponnents = NSDateComponents()
        //        oneMonthAgoComponnents. = monthsAgo * -1
        
        let todayComponnents = day.atMidnight()
        
        let tomorrowComponnent = NSDate(timeInterval: NSTimeInterval.init(86400), sinceDate: day)
        
        
        let predicate = eventStore.predicateForEventsWithStartDate(todayComponnents, endDate: tomorrowComponnent, calendars: [self.calendar!])
        //let predicate = eventStore.predicateForEventsWithStartDate(NSDate(), endDate: NSDate(), calendars: [self.calendar!])
        
        let events = eventStore.eventsMatchingPredicate(predicate)
        
        return events
    }
    
    func setCalendar(calendar: EKCalendar) {
        let userDeaults = NSUserDefaults()
        
        userDeaults.setValue(calendar.title, forKey: "eventkit_events_sync_calendars")
        
        self.calendar = calendar
    }
    
    func saveEvents(events: [EKEvent]) {
        // save on user online profile
    }
}






