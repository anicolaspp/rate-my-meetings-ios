//
//  CalendarRepository.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 12/8/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse
import EventKit
import CVCalendar

protocol CalendarRepositoryDelegate {
    func user(user: User, didEventFetchComplete events: [Event]?) -> Void
}

class CalendarRepository: ICalendarRepository {
    
    var delegate: CalendarRepositoryDelegate?
    
    func getInUseCalendarFor(user: User) -> Calendar? {
        
        if let id = user.inUseCalendarId {
            let query = PFQuery(className: Calendar.parseClassName())
            query.whereKey("objectId", equalTo: id)
            
            do {
                let result = try query.findObjects().first as? Calendar
                return result
            }
            catch let excep as NSError {
                print(excep)
            }
        }
        
        return nil
    }
    
    func getEventForUser(user: User, usingData date: NSDate) {
        
        let today = NSDate()
        
        if today.compare(date) == .OrderedAscending {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.user(user, didEventFetchComplete: nil)
            })

        }
        
        let calendar = NSCalendar.currentCalendar()
        
        var comp = calendar.components([.Day, .Month, .Year], fromDate: date)
        comp.day = 1

        let start = calendar.dateFromComponents(comp)!
        
        comp = calendar.components([.Day, .Month, .Year], fromDate: start)
        comp.month = 1
        
        let end = calendar.dateByAddingComponents(comp, toDate: start, options: .MatchNextTime)!
        
        let userCalendarsQuery = PFQuery(className: Calendar.parseClassName())
        userCalendarsQuery.whereKey("owner", equalTo: user)
        
        let query = PFQuery(className: Event.parseClassName())
        query
            .whereKey("eventDate", greaterThanOrEqualTo: start)
            .whereKey("eventDate", lessThanOrEqualTo: end)
            .whereKey("calendar", matchesQuery: userCalendarsQuery)
        
        query.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            print(error)
            print(events)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.user(user, didEventFetchComplete: events as? [Event])
            })

        }
    }
}
