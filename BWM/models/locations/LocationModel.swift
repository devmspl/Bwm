//
//  LocationModel.swift
//  BWM
//
//  Created by Serhii on 10/17/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation

class LocationModel {
    
    var locationName: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var locationId: Int?
    
    var dictionary: [String: Any] {
        return [
            "address": locationName,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
    
    convenience init(withLocation loc: Locations) {
        self.init()
        self.locationName = loc.address ?? ""
        self.locationId = loc.id
        if let lat = loc.latitude,
            let lon = loc.longitude {
            self.latitude = Double(lat) ?? 0.0
            self.longitude = Double(lon) ?? 0.0
        }
    }
}
