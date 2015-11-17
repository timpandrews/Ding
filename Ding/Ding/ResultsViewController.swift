//
//  ResultsViewController.swift
//  Ding
//
//  Created by Tim.Andrews on 9/11/15.
//  Copyright (c) 2015 justTim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ResultsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var imgHotelHeroPic: UIImageView!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress1: UILabel!
    @IBOutlet weak var lblHotelCSV: UILabel!
    @IBOutlet weak var mapHotelMap: MKMapView!
    
    
    var locationManger = CLLocationManager()
    var latString = ""
    var longString = ""
    
    var toPass:AnyObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var address1 = ""
        var hotelName = ""
        var city = ""
        var state = ""
        var zip = ""
        var csv = ""
        
        println(toPass)
        println(toPass.name)
        println(toPass.address)
        
        /* Get Location */
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        // Try getting location on initial ViewController and then use it here in ResultsViewController ????
        delay(0.4) {
            //println(self.latString)
            //println(self.longString)

        
            self.lblHotelName.text = ""
            self.lblHotelAddress1.text = ""
            self.lblHotelCSV.text = ""
            
            /* URL for single hotel query by ID */
            //let url = NSURL(string: "https://api.staysmarter.com/v1/query/54693")
            /* URL for multi hotel query by long/lat */
            let url = NSURL(string: "https://api.staysmarter.com/v1/query?arrivalDate=1447525547&numNights=1&numAdults=2&radius=4.886431949732083&longitude=" + self.longString + "&latitude=" + self.latString + "&numRooms=1")
            
            //println(url)
            
            var request = NSURLRequest(URL: url!)
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            if data != nil {
                var jsonSwifty = JSON(data: data!)
                //println("jsonSwifty:")
                //println(jsonSwifty)
                
                //println(jsonSwifty["results"].count)
                //println(jsonSwifty["results"][1])  // Bug with hotel at [0]index for Apple Test Location
                //println(jsonSwifty["results"][1]["name"])
                
                
                /* Name & Address */
                hotelName = jsonSwifty["results"][1]["name"].string!
                address1 = jsonSwifty["results"][1]["address"]["address1"].string!
                city = jsonSwifty["results"][1]["address"]["city"].string!
                state = jsonSwifty["results"][1]["address"]["state"].string!
                zip = jsonSwifty["results"][1]["address"]["zip"].string!
                csv = city + ", " + state + "  " + zip
                
                
                
                self.lblHotelName.text = hotelName
                self.lblHotelAddress1.text = address1
                self.lblHotelCSV.text = csv
                
                /* Photo */
                //println(jsonSwifty["results"][1]["photos"][0])
                
                var url = NSURL(string: jsonSwifty["results"][1]["photos"][0].stringValue)
                var urlRequest = NSURLRequest(URL: url!)
                
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                    
                    if error != nil {
                        
                        println(error)
                        
                    } else {
                        
                        var image = UIImage(data: data)
                        self.imgHotelHeroPic.image = image
                        
                    }
                    
                })
                
                /* Location / Maps */
                //println(jsonSwifty["results"][1]["location"])
                //println(jsonSwifty["results"][1]["location"]["longitude"])
                //println(jsonSwifty["results"][1]["location"]["latitude"])
                
                var rawLat = jsonSwifty["results"][1]["location"]["latitude"].double
                var rawLong = jsonSwifty["results"][1]["location"]["longitude"].double
                
                //println(rawLat)
                //println(rawLong)
                
                var lat:CLLocationDegrees = rawLat!
                var long:CLLocationDegrees = rawLong!
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
            
        
            } else {
            
                self.lblHotelName.text = "n/a"
            
            }
        
        }
        
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        //println("locationManager")
        //println(locations)
        
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        self.latString = String(stringInterpolationSegment: userLocation.coordinate.latitude)
        self.longString = String(stringInterpolationSegment: userLocation.coordinate.longitude)
        
        //println(latString)
        //println(longString)
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
