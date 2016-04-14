//
//  MapViewController.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 4/6/16.
//  Copyright © 2016 si363. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapview: MKMapView!
    
    let initialloc = CLLocation(latitude: 42.279594, longitude: -83.732124) // set to Ann Arbor by default
    let regionrad : CLLocationDistance = 1000   // in meters, 1000m
    let pin = Pin(content: "test", coordinate: CLLocationCoordinate2D(latitude: 42.279594, longitude: -83.732124), confirmed: 1)
    
    // Show the default map around initialloc
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionrad * 2.0, regionrad * 2.0)
        mapview.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centerMapOnLocation(initialloc)
        mapview.addAnnotation(pin)
        mapview.delegate = self
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
