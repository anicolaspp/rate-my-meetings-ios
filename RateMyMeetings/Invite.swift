//
//  Invite.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 12/9/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse

class Invite: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return "Invites"
    }
}