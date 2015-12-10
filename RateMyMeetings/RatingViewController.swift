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

    @IBOutlet weak var allRatings: CosmosView!
    @IBOutlet weak var userRatingControl: CosmosView!
    @IBOutlet weak var rateButton: UIButton!
    
    var event: Event?
    var overallRating = Double(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event?.rating > 0 {
            self.userRatingControl.rating = event!.rating
            self.userRatingControl.userInteractionEnabled = false
            self.rateButton.enabled = false
        }
        
        self.allRatings.rating = self.overallRating
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
