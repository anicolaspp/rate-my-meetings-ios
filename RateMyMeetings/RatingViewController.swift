//
//  RatingViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/27/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit
import Cosmos
import EventKit

class RatingViewController: UIViewController {

    @IBOutlet weak var userRatingControl: CosmosView!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func submitUserRating(sender: AnyObject) {
        let rating = userRatingControl.rating
        
        self.event?.rating = rating
        self.event?.saveInBackground()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
