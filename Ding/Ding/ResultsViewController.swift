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

        lblResults.text = "Results go here!"
        
        let url = NSURL(string: "http://www.telize.com/geoip")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                println(error)
            } else {
                
                println("rawData: ", data)
                
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                println("jsonResult: ", jsonResult)
                println("city: ", jsonResult["city"])
                
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
