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
        
        /* URL for single hotel query by ID */
        let url = NSURL(string: "https://api.staysmarter.com/v1/query/54693")
        /* URL for multi hotel query by long/lat */
        //let url = NSURL(string: "https://api.staysmarter.com/v1/query?arrivalDate=1447525547&numNights=1&numAdults=2&radius=4.886431949732083&longitude=-77.13445322151701&latitude=38.86523864575938&numRooms=1")
        
        
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
                        
                        /* Address */
                        if let address = hotel["address"] as? NSDictionary {
                            
                            address1 = address["address1"] as! String
                            city = address["city"] as! String
                            state = address["state"] as! String
                            zip = address["zip"] as! String
                            csv = city + ", " + state + "  " + zip
                            
                        }
                        
                        /* Update Labels */
                        dispatch_async(dispatch_get_main_queue(), {
                            self.lblHotelName.text = hotelName
                            self.lblHotelAddress1.text = address1
                            self.lblHotelCSV.text = csv
                            
                        })

                        
                        /* Photos */
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
                        
                        /* Location / Maps */
                        if let hotelLocation = hotel["location"] as? NSDictionary {
                            
                            //println(hotelLocation)
                            //println(hotelLocation["latitude"])
                            //println(hotelLocation["longitude"])
                            
                            var rawLat = hotelLocation["latitude"] as! Double
                            var rawLong = hotelLocation["longitude"] as! Double
                            
                            //println(rawLat)
                            //println(rawLong)

                            var lat:CLLocationDegrees = rawLat
                            var long:CLLocationDegrees = rawLong
                            var latDelta:CLLocationDegrees = 0.01
                            var longDelta:CLLocationDegrees = 0.01
                            var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                            var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                            var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                            
                            self.mapHotelMap.setRegion(region, animated: true)
                            
                            var annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = hotelName
                            annotation.subtitle = csv
                            self.mapHotelMap.addAnnotation(annotation)
                            
                            
                            
                        }
                        
                    } else {
                        
                        /* No  hotel found */
                        var hotelName = "n/a"
                        dispatch_async(dispatch_get_main_queue(), {
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
