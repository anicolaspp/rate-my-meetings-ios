//
//  Team.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation

class Team {
    let name: String?
    var members: [User]?
    
    init(name: String) {
        self.name = name
    }
}