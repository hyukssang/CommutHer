//
//  RequestsMgr.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 4/17/16.
//  Copyright © 2016 si363. All rights reserved.
//

import UIKit
import Parse
var requestMgr = RequestMgr()

struct request{
    var destination = "destination"
    var time = "time"
}

class RequestMgr: NSObject {
    var requests = [request]()
    override init(){
        super.init()
        var query = PFQuery(className: "Request")
        var requestarray = query.findObjectsInBackgroundWithBlock({ (objects, error) in
            if error == nil {
                for obj in objects!{
                    let dest = obj.objectForKey("destination") as! String
                    let time = obj.objectForKey("timeend") as! String
                    self.requests.append(request(destination: dest, time: time))
                }
            }
        })
        
    }
    func addRequest(destination: String, time: String){
        requests.append(request(destination: destination, time: time))
    }
}