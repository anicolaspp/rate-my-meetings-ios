//
//  MyProtocols.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation

protocol UserRegistrationCompleteDelegate {
    func registrationComplete(user: User?) -> Void
}

protocol IUserRepository {
    func longin(username: String!, password: String!) -> User?
    func register(companyName: String, email: String, password: String) -> User?
}

protocol ICompanyRepository {
    func getTeamsWithDomain(domain: String) -> [Team]
    func team(teamName: String, shouldBeCreateWithOwner owner: User) -> Team
}