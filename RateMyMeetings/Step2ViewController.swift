//
//  Step2ViewController.swift
//  RateMyMeetings
//
//  Created by Nicolas Perez on 11/22/15.
//  Copyright © 2015 Nicolas Perez. All rights reserved.
//

import UIKit

class Step2ViewController: UIViewController {

    
    var companyName: String?
    var domainName: String?


    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.domainLabel.text = "@" + domainName!
        self.companyLabel.text = companyName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
