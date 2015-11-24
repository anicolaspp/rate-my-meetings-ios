//
//  Extensions.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/23/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidEmail() -> Bool {
        let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", pattern)
        
        return emailTest.evaluateWithObject(self)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: handler))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func executeAsyncWithIndicator(activityIndicator: UIActivityIndicatorView, action: () -> AnyObject?, completion: (result: AnyObject?) -> Void) {
        showActivityIndicatory(activityIndicator, uiView: self.view)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let result = action()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                activityIndicator.stopAnimating()
                self.view.userInteractionEnabled = true
                
                completion(result: result)
            })
        })
    }
    
    
    func showActivityIndicatory(activityIndicator: UIActivityIndicatorView, uiView: UIView) {
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        activityIndicator.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        
        self.view.userInteractionEnabled = false
        
        activityIndicator.startAnimating()
        uiView.addSubview(activityIndicator)
    }
    
}
