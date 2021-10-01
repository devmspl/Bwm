//
//  SearchRequestObject.swift
//  BWM
//
//  Created by Serhii on 8/27/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import CoreLocation

class SearchRequestObject {
    
    var userCoordinates: CLLocationCoordinate2D
    var radius: Int?
    var ageFrom: Int?
    var ageTo: Int?
    var gender: Int?
    var ethnicity: Ethnicity?
    var birthDate: TimeInterval?
    var category: Category?
    var city: String?
    var userName: String?
    var isInitial: Bool = true
    
    var page: Int?
    
    let perPage: Int = 20
    
    init(withCoordinates coordinates: CLLocationCoordinate2D) {
        self.userCoordinates = coordinates
    }
    
    func clear() {
        self.radius = nil
        self.ageTo = nil
        self.ageFrom = nil
        self.gender = nil
        self.ethnicity = nil
        self.city = nil
        self.category = nil
        self.userName = nil
        self.birthDate = nil
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = ["coordinates": [userCoordinates.longitude, userCoordinates.latitude]]
        dictionary["isInitial"] = self.isInitial ? 1 : 0
        
        if let radius = self.radius { dictionary["radius"] = radius }
        if let ageFrom = self.ageFrom { dictionary["ageFrom"] = ageFrom }
        if let ageTo = self.ageTo { dictionary["ageTo"] = ageTo }
        if let gender = self.gender { dictionary["gender"] = gender }
        if let ethnicityId = self.ethnicity?.id { dictionary["ethnicityId"] = ethnicityId }
        if let birthDate = self.birthDate { dictionary["birthDate"] = birthDate }
        if let categoryId = self.category?.id { dictionary["categoryId"] = categoryId }
        if let city = self.city { dictionary["city"] = city }
        if let userName = self.userName { dictionary["username"] = userName }
        
        return dictionary
    }
}
