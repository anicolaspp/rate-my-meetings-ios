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

protocol UserRegistrationCompleteDelegate {
    func registrationComplete(user: User?) -> Void
}

protocol IUserRepository {
    func longin(username: String!, password: String!) -> User?
    func register(companyName: String, email: String, password: String) -> User?
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



class UserRepository: IUserRepository {
    
    func longin(username: String!, password: String!) -> User? {
        return nil
    }
    
    func register(companyName: String, email: String, password: String) -> User? {
        return nil
    }
}