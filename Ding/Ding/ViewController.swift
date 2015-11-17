//
//  ViewController.swift
//  Ding
//
//  Created by Tim.Andrews on 9/11/15.
//  Copyright (c) 2015 justTim. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var myHotel = Hotel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myHotel.name = "Test Hotel"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "sequeToResults") {
            var svc = segue.destinationViewController as! ResultsViewController;
            
            svc.toPass = myHotel
            println("toPass")
            println(svc.toPass)
            println("toPass")
            
        }
    }

    
}

