//
//  MapViewController.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 4/6/16.
//  Copyright © 2016 si363. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var searchController: UISearchController!
    
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    
    var directionsRequest: MKDirectionsRequest!
    var directions: MKDirections!
    
    
    var pinAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    let locationManager = CLLocationManager()
    
    var popupview: UIView!
    var datepicker: UIDatePicker!
    
    var locationstart : CLLocationCoordinate2D!
    var locationend : CLLocationCoordinate2D!
    var destination : String!
//    let initialloc = CLLocation(latitude: 42.279594, longitude: -83.732124) // set to Ann Arbor by default
//    let regionrad : CLLocationDistance = 1000   // in meters, 1000m
//    let pin = Pin(content: "test", coordinate: CLLocationCoordinate2D(latitude: 42.279594, longitude: -83.732124), confirmed: 1)
    
    // Show the default map around initialloc
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionrad * 2.0, regionrad * 2.0)
//        mapview.setRegion(coordinateRegion, animated: true)
//    }
    @IBAction func placePin(sender: AnyObject) {
        var annotation = MKPointAnnotation()
        var annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotation.coordinate = self.mapview.centerCoordinate
        annotation.title = "Warning"
        annotationView.pinTintColor = UIColor.redColor()
        self.mapview.addAnnotation(annotation)
    }
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch (newState) {
            case .Starting:
                view.dragState = .Dragging
            case .Ending, .Canceling:
                view.dragState = .None
            default: break
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)



        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        
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
            self.destination = searchBar.text!
            
            self.locationManager.stopUpdatingLocation()
            let userlong = self.locationManager.location?.coordinate.longitude
            let userlat = self.locationManager.location?.coordinate.latitude
            
            self.locationstart = CLLocationCoordinate2D(latitude: userlat!, longitude: userlong!)
            
            // Remove any existing pins
            let annotations = self.mapview.annotations
            self.mapview.removeAnnotations(annotations)
            
            self.pinAnnotation = MKPointAnnotation()
            self.pinAnnotation.title = searchBar.text
            let resultLatitude = localSearchResponse!.boundingRegion.center.latitude
            let resultLongitude = localSearchResponse!.boundingRegion.center.longitude
            self.pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: resultLatitude, longitude: resultLongitude)
            
            self.locationend = CLLocationCoordinate2D(latitude: resultLatitude, longitude: resultLongitude)
            
            self.directionsRequest = MKDirectionsRequest()
            self.directionsRequest.source = MKMapItem.mapItemForCurrentLocation()
//            self.directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userlat!, longitude: userlong!), addressDictionary: nil))
            self.directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude), addressDictionary: nil))
            print("\(searchBar.text)")
            print("latitude: \(localSearchResponse!.boundingRegion.center.latitude)")
            print("longitude: \(localSearchResponse!.boundingRegion.center.longitude)")
            self.directionsRequest.transportType = .Walking
            self.directions = MKDirections(request: self.directionsRequest)
            self.directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }

                // Remove any existing directions
                let overlays = self.mapview.overlays
                self.mapview.removeOverlays(overlays)
                
                for route in unwrappedResponse.routes {

                    self.mapview.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
                    self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)

                }
            }

        
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pinAnnotation, reuseIdentifier: nil)
            self.pinAnnotationView.pinTintColor = UIColor.greenColor()
            self.mapview.centerCoordinate = self.pinAnnotation.coordinate
            self.mapview.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: resultLatitude, longitude: resultLongitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            self.mapview.addAnnotation(self.pinAnnotationView.annotation!)
        })
        
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.purpleColor()
        renderer.lineWidth = 4.0
        return renderer
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
//            pinAnnotationView.pinColor = .Purple
        pinAnnotationView.draggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = true
        
        let custombtn = UIButton(type: UIButtonType.ContactAdd)
        custombtn.addTarget(self, action: "makeRequest:", forControlEvents: .TouchUpInside)
//        custombtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        custombtn.setTitle("Go!!!!!", forState: UIControlState.Normal)
//            let deleteButton = UIButton(type: UIButtonType.Custom) as UIButton
//            deleteButton.frame.size.width = 44
//            deleteButton.frame.size.height = 44
//            deleteButton.backgroundColor = UIColor.redColor()
//            deleteButton.setImage(UIImage(named: "trash"), forState: .Normal)
    
        pinAnnotationView.leftCalloutAccessoryView = custombtn

        return pinAnnotationView
    }
//
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
    func makeRequest(Sender: UIButton!){
        popupview = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        popupview.backgroundColor = UIColor.whiteColor()
        view.addSubview(popupview)
        popupview.hidden = false
        
        datepicker = UIDatePicker(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200))
        popupview.addSubview(datepicker)
        let okaybtn = UIButton(type: UIButtonType.RoundedRect)
        okaybtn.frame = CGRect(x: 0, y: 300, width: self.view.frame.width, height: 75)
        okaybtn.setTitle("Request", forState: .Normal)
        popupview.addSubview(okaybtn)
        
        let cancelbtn = UIButton(type: UIButtonType.RoundedRect)
        cancelbtn.frame = CGRect(x: 0, y: 375, width: self.view.frame.width, height: 75)
        cancelbtn.setTitle("Cancel", forState: .Normal)
        popupview.addSubview(cancelbtn)
        
        okaybtn.addTarget(self, action: "requestReceived:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelbtn.addTarget(self, action: "requestCancelled:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func requestReceived(Sender: UIButton!){
        var dateformatter1 = NSDateFormatter()
        dateformatter1.dateFormat = "dd-MM-yyyy HH:mm"
        var timeend : String = dateformatter1.stringFromDate(self.datepicker.date)
        print("\(dateformatter1.stringFromDate(self.datepicker.date))")
        
        var curdate = NSDate()
        var dateformatter2 = NSDateFormatter()
        dateformatter2.dateFormat = "dd-MM-yyyy HH:mm"
        var timestart : String = dateformatter2.stringFromDate(curdate)
        
        
        var request = PFObject(className: "Request")
        request.setObject(timestart, forKey: "timestart")
        request.setObject(timeend, forKey: "timeend")
        request.setObject(locationstart.latitude, forKey: "startlatitude")
        request.setObject(locationstart.longitude, forKey: "startlongitude")
        request.setObject(locationend.latitude, forKey: "endinglatitude")
        request.setObject(locationend.longitude, forKey: "endinglongitude")
        request.setObject(self.destination, forKey: "destination")
        request.saveInBackground()
        popupview.removeFromSuperview()
    }
    func requestCancelled(Sender: UIButton!){
        popupview.removeFromSuperview()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
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
