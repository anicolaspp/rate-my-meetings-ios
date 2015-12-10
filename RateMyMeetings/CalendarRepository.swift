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
    
    func getRatingForEvent(event: Event) -> Double? {
        
        let calendar = event.calendar!
        
        do {
            try calendar.fetch()
        }
        catch _ {}
        
        print(calendar)
        
        let user = calendar.owner
        
        let invitesQuery = PFQuery(className: Invite.parseClassName())
        invitesQuery
            .whereKey("calendar", equalTo: calendar)
            .whereKey("from", equalTo: user!)
        
        do {
            let invites = try invitesQuery.findObjects() as? [Invite]
            
            print(invites)
            
            let users = invites?.map({ (i) -> User? in
                return i["to"] as? User
            })
            
            if let events = users.flatMap({ (u) -> [Event]? in
                return self.a(user!, startingAt: event.eventDate!, endingDate: event.eventDate!)
            }) {
            
                print(events)
                
                let sum = events.map({ (x) -> Double in
                    return x.rating
                })
                    .reduce(0, combine: { (x, y) -> Double in
                        return x + y
                    })
                
                return sum / Double(events.count)
            }
        }
        catch let exception as NSError {
            print(exception)
        }
        
        
        
       
        
        return 0
    }
    
    private func a(user: User, startingAt startDate: NSDate, endingDate endDate: NSDate) -> [Event]? {
        let userCalendarsQuery = PFQuery(className: Calendar.parseClassName())
        userCalendarsQuery.whereKey("owner", equalTo: user)
        
        let query = PFQuery(className: Event.parseClassName())
        query
            .whereKey("eventDate", greaterThanOrEqualTo: startDate)
            .whereKey("eventDate", lessThanOrEqualTo: endDate)
            .whereKey("calendar", matchesQuery: userCalendarsQuery)
        
        do {
            let events = try query.findObjects()
            return events as? [Event]
        }
        catch _ {}
        
        return nil
    }
    
    func getEventForUser(user: User, usingDate date: NSDate) -> Void {
        
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
//        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0))  { () -> Void in
            let events = self.a(user, startingAt: start, endingDate: end)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.user(user, didEventFetchComplete: events)
            })
        }
//
//        let userCalendarsQuery = PFQuery(className: Calendar.parseClassName())
//        userCalendarsQuery.whereKey("owner", equalTo: user)
//        
//        let query = PFQuery(className: Event.parseClassName())
//        query
//            .whereKey("eventDate", greaterThanOrEqualTo: start)
//            .whereKey("eventDate", lessThanOrEqualTo: end)
//            .whereKey("calendar", matchesQuery: userCalendarsQuery)
//        
//        query.findObjectsInBackgroundWithBlock { (events, error) -> Void in
//            print(error)
//            print(events)
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.delegate?.user(user, didEventFetchComplete: events as? [Event])
//            })
//
//        }
    }
}
