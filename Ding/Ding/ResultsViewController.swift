//
//  ResultsViewController.swift
//  Ding
//
//  Created by Tim.Andrews on 9/11/15.
//  Copyright (c) 2015 justTim. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var lblResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "http://www.telize.com/geoip")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                println(error)
            } else {
                
                println("rawData: ", data)
                
                let jsonResult : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                println("jsonResult: ", jsonResult)
                println(jsonResult["city"] as! String)
                
                var city = jsonResult["city"] as! String
                
                println("city: ", city as String)
                
                dispatch_async(dispatch_get_main_queue(), {
                    //perform all UI stuff here
                    self.lblResults.text = city
                })
                
                
            }
        
        })
        
        task.resume()
        
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
