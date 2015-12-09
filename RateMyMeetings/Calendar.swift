//
//  Calendar.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 12/8/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse
import EventKit


class Calendar : PFObject, PFSubclassing {
    
    @NSManaged var  owner: User?
    @NSManaged var  sharedWith : [User]?
    
    @NSManaged var  name: String?
    
    @NSManaged var localEntity: String
    
    static func parseClassName() -> String {
        return "Calendar"
    }
}