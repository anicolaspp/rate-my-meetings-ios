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
    
    var event: EKEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitUserRating(sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
