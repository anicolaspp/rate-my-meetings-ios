//
//  Event.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 12/8/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse
import EventKit



class Event: PFObject, PFSubclassing {
    
    private var ekEvent: EKEvent?
    
    @NSManaged var calendar: Calendar?
    @NSManaged var eventName: String?
    @NSManaged var eventDate: NSDate?
    @NSManaged var rating: Double
    
    func setEvent(event: EKEvent, inCalendar calendar: Calendar?) {
        self.ekEvent = event
        self.eventName = event.title
        self.eventDate = event.startDate
        self.calendar = calendar
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
}