//
//  AvailabilityViewController.swift
//  Ding
//
//  Created by Tim.Andrews on 9/13/15.
//  Copyright (c) 2015 justTim. All rights reserved.
//

import UIKit

class AvailabilityViewController: UIViewController {
    
    @IBOutlet weak var lblTest: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTest.text = "Connected"

        // Do any additional setup after loading the view.
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
