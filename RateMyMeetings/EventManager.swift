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
    
    init() {
        self.eventStore = EKEventStore()
        
        let userDeaults = NSUserDefaults()
        
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
}