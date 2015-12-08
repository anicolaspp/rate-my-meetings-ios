//
//  UserRepository.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse

class CompanyRepositoryStub : ICompanyRepository {
    func getTeamsWithDomain(domain: String) -> [Team] {
        let team1 = Team(name: "Fusion")
        
        var user = User()
        user.email = "anicolaspp@gmail.com"
        
        team1.members = [user]
        
        let team2 = Team(name: "BI")
        
        user = User()
        user.email = "ctriana@gmail.com"
        
        team2.members = [user]
        
        return [team1, team2]
    }
    
    func team(teamName: String, shouldBeCreateWithOwner owner: User) -> Team {
        let team = Team(name: teamName)
        team.members = [owner]
        
        return team
    }
}


//class UserRepositoryStub: IUserRepository {
//    
//    func longin(username: String!, password: String!) -> User? {
//        if (username != "" && username == password) {
//            return User()
//        }
//        
//        return nil
//    }
//    
//    func register(companyName: String, email: String, password: String) -> User? {
//        if (email.containsString(".com")) {
//            let user = User()
//            user.email = email
//
//            return user
//        }
//        else {
//            return nil
//        }
//    }
//}



class UserRepository: IUserRepository {
    
    func longin(username: String!, password: String!) -> User? {
        let loginTask = PFUser.logInWithUsernameInBackground(username, password: password)
        loginTask.waitUntilFinished()
        
        let user = PFUser.currentUser()
        
        return user as? User
    }
    
    func register(email: String, password: String) -> User? {
        var user = User()
        user.username = email
        user.email = email
        user.password = password
        
        let task = user.signUpInBackground()
        task.waitUntilFinished()
        
        user = PFUser.currentUser() as! User
        
        PFUser.logOutInBackground()
        
        return user

    }
}



