//
//  User.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse
import EventKit

class User : PFUser {
    @NSManaged var inUseCalendarId: String?
    @NSManaged var calendars: [Calendar]?
    
}

