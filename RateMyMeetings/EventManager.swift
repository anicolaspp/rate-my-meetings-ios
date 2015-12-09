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
    
    let user: User?
    let calendarRepository: CalendarRepository?
    
    init(user: User, withCalendarRepository: CalendarRepository) {
        self.eventStore = EKEventStore()
        self.user = user
        self.calendarRepository = withCalendarRepository
       
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
        if let inUseCalendar = self.calendarRepository?.getInUseCalendarFor(self.user!) {
            self.calendar = self.eventStore.calendarWithIdentifier(inUseCalendar.localEntity)
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
}






