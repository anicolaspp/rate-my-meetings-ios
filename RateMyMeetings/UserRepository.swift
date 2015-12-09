//
//  UserRepository.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/21/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import Parse
import EventKit
import CVCalendar


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
    
    func setCalendar(calendar: EKCalendar, forUser user: User) {
        self.setInUseCalendarForCurrentUserAsync(calendar, forUser: user)
    }
    
    private func setInUseCalendarForCurrentUserAsync(calendar: EKCalendar, forUser user: User) {
        let query = PFQuery(className: Calendar.parseClassName())
        
        query
            .whereKey("owner", equalTo: PFUser(withoutDataWithObjectId: user.objectId))
            .whereKey("localEntity", equalTo: calendar.calendarIdentifier)
        
        query.getFirstObjectInBackgroundWithBlock { (rcalendar, error) -> Void in
            if let remoteCalendar = rcalendar {
                print("Calendar Found")
                
                self.setInUserCalendarForUser(user, calendarId: remoteCalendar.objectId!)
            }
            else {
                let pfcalendar = Calendar()
                
                pfcalendar.owner = user
                pfcalendar.name = calendar.title
                pfcalendar.localEntity = String( calendar.calendarIdentifier )
                
                pfcalendar.saveInBackgroundWithBlock({ (saved, savingError) -> Void in
                    self.setInUserCalendarForUser(user, calendarId: pfcalendar.objectId!)
                })
            }
        }
    }
    
    private func setInUserCalendarForUser(user: User, calendarId: String) {
        user.inUseCalendarId = calendarId
        user.saveInBackground()
    }
}



