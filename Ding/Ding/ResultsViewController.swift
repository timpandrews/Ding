//
//  ResultsViewController.swift
//  Ding
//
//  Created by Tim.Andrews on 9/11/15.
//  Copyright (c) 2015 justTim. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var imgHotelHeroPic: UIImageView!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress1: UILabel!
    @IBOutlet weak var lblHotelCSV: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var address1 = ""
        var hotelName = ""
        var city = ""
        var state = ""
        var zip = ""
        var csv = ""
        
        lblHotelName.text = ""
        lblHotelAddress1.text = ""
        lblHotelCSV.text = ""

        //let url = NSURL(string: "http://www.telize.com/geoip")
        let url = NSURL(string: "https://api.staysmarter.com/v1/query/2222")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                println(error)
            } else {
                let jsonResult : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                if jsonResult.count > 0 {
                    
                    println(jsonResult["results"])
                    
                    if let hotel = jsonResult["results"] as? NSDictionary {
                        
                        hotelName = hotel["name"] as! String
                        
                        if let address = hotel["address"] as? NSDictionary {
                            
                            address1 = address["address1"] as! String
                            city = address["city"] as! String
                            state = address["state"] as! String
                            zip = address["zip"] as! String
                            csv = city + ", " + state + "  " + zip
                            
                        }
                        
                                                
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            //perform all UI stuff here
                            self.lblHotelName.text = hotelName
                            self.lblHotelAddress1.text = address1
                            self.lblHotelCSV.text = csv
                            
                        })
                        
                        
                        
                    } else {
                        
                        var hotelName = "n/a"
                        dispatch_async(dispatch_get_main_queue(), {
                            //perform all UI stuff here
                            self.lblHotelName.text = hotelName
                        })
                        
                    }
                    
                }

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
