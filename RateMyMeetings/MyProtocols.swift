//
//  MyProtocols.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import EventKit

protocol UserRegistrationCompleteDelegate {
    func registrationComplete(user: User?) -> Void
}

protocol CalendarSelectionDelegate {
    func didSelectCalendar(calendar: EKCalendar)
}

protocol TeamDelegate {
    func didCreateTeam(team: Team?) -> Void
}

protocol IUserRepository {
    func longin(username: String!, password: String!) -> User?
    func register(email: String, password: String) -> User?
}



protocol ICompanyRepository {
    func getTeamsWithDomain(domain: String) -> [Team]
    func team(teamName: String, shouldBeCreateWithOwner owner: User) -> Team
}