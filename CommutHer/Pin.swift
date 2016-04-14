//
//  Pin.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 4/6/16.
//  Copyright © 2016 si363. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject, MKAnnotation {
    var content: String
    var coordinate: CLLocationCoordinate2D
    var confirmed: Int
    
    init(content: String, coordinate: CLLocationCoordinate2D, confirmed: Int){
        self.content = content
        self.coordinate = coordinate
        self.confirmed = confirmed
        super.init()
    }
}