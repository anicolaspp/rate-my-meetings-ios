//
//  User.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse

class User : PFUser {
    //@NSManaged var inUseCalendar: Calendar?
    @NSManaged var calendars: [Calendar]?
    
}

class Calendar : PFObject, PFSubclassing {
    
    @NSManaged var  owner: User?
    @NSManaged var  sharedWith : [User]?
    
    @NSManaged var  name: String?
    
    @NSManaged var localEntity: String
    
    static func parseClassName() -> String {
        return "Calendar"
    }
    

}