//
//  RateMyMeetingsUITests.swift
//  RateMyMeetingsUITests
//
//  Created by Nicolas Perez on 11/18/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import XCTest



class LoginUITests: XCTestCase {
    
    let userRepository = UserRepositoryStub()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication.launch()
      
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoginFailedWhenUserAndPassNotMatch() {
        
        
        let app = XCUIApplication()
        
        let page = app.value as! LoginViewController
        
        let userRepository = UserRepositoryStub()
        userRepository.userId = 1
        
        page.userRepository = userRepository

        
        app.buttons["Login"].tap()
        
        let collectionViewsQuery = app.alerts["Login"].collectionViews
        collectionViewsQuery.textFields["User Name"].typeText("aaaa")
        
        let passwordSecureTextField = collectionViewsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("bbbb")
        collectionViewsQuery.buttons["Login"].tap()
        
        assert(<#T##condition: Bool##Bool#>)
    }
    
}


