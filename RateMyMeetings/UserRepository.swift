//
//  UserRepository.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation

protocol IUserRepository {
    func longin(username: String!, password: String!) -> Int
}

protocol UIAlertPresenter {
    
}


class UserRepositoryStub: IUserRepository {
    
    func longin(username: String!, password: String!) -> Int {
        if (username != "" && username == password) {
            return 1
        }
        
        return 0
    }
}



class UserRepository: IUserRepository {
    
    func longin(username: String!, password: String!) -> Int {
        return 0
    }
}