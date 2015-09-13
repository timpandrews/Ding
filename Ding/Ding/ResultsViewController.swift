//
//  ResultsViewController.swift
//  Ding
//
//  Created by Tim.Andrews on 9/11/15.
//  Copyright (c) 2015 justTim. All rights reserved.
//

import UIKit
import MapKit

class ResultsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var imgHotelHeroPic: UIImageView!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress1: UILabel!
    @IBOutlet weak var lblHotelCSV: UILabel!
    @IBOutlet weak var mapHotelMap: MKMapView!
    
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
        
        
        
        
        
        /* Sample Map Location */
        var lat:CLLocationDegrees = 40.7
        var long:CLLocationDegrees = -73.9
        var latDelta:CLLocationDegrees = 0.01
        var longDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapHotelMap.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Hotel"
        annotation.subtitle = "Address"
        mapHotelMap.addAnnotation(annotation)
        
        
        
        
        

        //let url = NSURL(string: "http://www.telize.com/geoip")
        let url = NSURL(string: "https://api.staysmarter.com/v1/query/54693")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                println(error)
            } else {
                let jsonResult : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                if jsonResult.count > 0 {
                    
                    //println(jsonResult["results"])
                    
                    if let hotel = jsonResult["results"] as? NSDictionary {
                        
                        hotelName = hotel["name"] as! String
                        
                        if let address = hotel["address"] as? NSDictionary {
                            
                            address1 = address["address1"] as! String
                            city = address["city"] as! String
                            state = address["state"] as! String
                            zip = address["zip"] as! String
                            csv = city + ", " + state + "  " + zip
                            
                        }
                        
                        if let photos = hotel["photos"] as? NSArray {
                            
                            //println(photos)
                            //println(photos[0])
                            
                            var url = NSURL(string: photos[0] as! String)
                            var urlRequest = NSURLRequest(URL: url!)
                            
                            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                                
                                if error != nil {
                                    
                                    println(error)
                                    
                                } else {
                                    
                                    var image = UIImage(data: data)
                                    self.imgHotelHeroPic.image = image
                                    
                                }
                                
                            })
                            
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
