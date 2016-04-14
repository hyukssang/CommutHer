//
//  MapViewControl.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 4/6/16.
//  Copyright © 2016 si363. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(mapview: MKMapView!, viewForAnnocation annotation: MKAnnotation!) -> MKAnnotationView!{
        if let annotation = annotation as? Pin{
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapview.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.draggable = true
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            return view
        }
        return nil
    }
}