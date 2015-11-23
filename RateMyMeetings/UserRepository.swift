//
//  UserRepository.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation

class User  {
    
    let email: String!
    
    init(email: String) {
        self.email = email
    }
}

class Team {
    let name: String?
    var members: [User]?
    
    init(name: String) {
        self.name = name
    }
}

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

class CompanyRepositoryStub : ICompanyRepository {
    func getTeamsWithDomain(domain: String) -> [Team] {
        let team1 = Team(name: "Fusion")
        team1.members = [User(email: "nperez@ipcoop.com")]
        
        let team2 = Team(name: "BI")
        team2.members = [User(email: "ctriana@gmail.com"), User(email: "nperez@ipcoop.com")]
        
        return [team1, team2]
    }
    
    func team(teamName: String, shouldBeCreateWithOwner owner: User) -> Team {
        let team = Team(name: teamName)
        team.members = [owner]
        
        return team
    }
}


class UserRepositoryStub: IUserRepository {
    
    func longin(username: String!, password: String!) -> User? {
        if (username != "" && username == password) {
            return User(email: "email")
        }
        
        return nil
    }
    
    func register(companyName: String, email: String, password: String) -> User? {
        return User(email: email)
    }
}



//class UserRepository: IUserRepository {
//    
//    func longin(username: String!, password: String!) -> User? {
//        return nil
//    }
//    
//    func register(companyName: String, email: String, password: String) -> User? {
//        return nil
//    }
//}