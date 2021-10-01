//
//  EthnicityStorage.swift
//  BWM
//
//  Created by Serhii on 8/28/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation

class EthnicityStorage {
    
    var ethnicities: [Ethnicity] = []
    
    static let shared: EthnicityStorage = EthnicityStorage()
    
    private init() {
    }
    
    static func idForName(_ name: String) -> Int {
        var id = 0
        for item in shared.ethnicities {
            if item.name == name {
                id = item.id
            }
        }
        
        return id
    }
    
    static func nameForId(_ iId: Int) -> String {
        var name = ""
        for item in shared.ethnicities {
            if item.id == iId {
                name = item.name
            }
        }
        
        return name
    }
}
