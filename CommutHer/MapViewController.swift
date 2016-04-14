//
//  MapViewController.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 4/6/16.
//  Copyright © 2016 si363. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var searchController: UISearchController!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    
    var pinAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    let locationManager = CLLocationManager()
    
//    let initialloc = CLLocation(latitude: 42.279594, longitude: -83.732124) // set to Ann Arbor by default
//    let regionrad : CLLocationDistance = 1000   // in meters, 1000m
//    let pin = Pin(content: "test", coordinate: CLLocationCoordinate2D(latitude: 42.279594, longitude: -83.732124), confirmed: 1)
    
    // Show the default map around initialloc
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionrad * 2.0, regionrad * 2.0)
//        mapview.setRegion(coordinateRegion, animated: true)
//    }
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
//        if self.mapview.annotations.count != 0{
//            annotation = self.mapview.annotations[0]
//            self.mapview.removeAnnotation(annotation)
//        }
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler({(localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            self.locationManager.stopUpdatingLocation()
            self.pinAnnotation = MKPointAnnotation()
            self.pinAnnotation.title = searchBar.text
            let resultLatitude = localSearchResponse!.boundingRegion.center.latitude
            let resultLongitude = localSearchResponse!.boundingRegion.center.longitude
            self.pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: resultLatitude, longitude: resultLongitude)
        
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pinAnnotation, reuseIdentifier: nil)
            self.mapview.centerCoordinate = self.pinAnnotation.coordinate
            self.mapview.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: resultLatitude, longitude: resultLongitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            self.mapview.addAnnotation(self.pinAnnotationView.annotation!)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Request the user for authorization
        self.locationManager.requestAlwaysAuthorization()
        // self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print("location enabled")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
//        centerMapOnLocation(initialloc)
//        mapview.addAnnotation(pin)
        mapview.delegate = self
        mapview.showsUserLocation = true
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var usercoordinate = manager.location?.coordinate
//        print("\(usercoordinate?.latitude)")
        var userlocation2d = CLLocationCoordinate2D(latitude: usercoordinate!.latitude, longitude: usercoordinate!.longitude)
        mapview.setRegion(MKCoordinateRegion(center: userlocation2d, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
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
