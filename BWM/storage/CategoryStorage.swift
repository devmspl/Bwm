//
//  CategoryStorage.swift
//  BWM
//
//  Created by Serhii on 8/28/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation

class CategoryStorage {
    
    var categories: [Category] = []
    
    static let shared: CategoryStorage = CategoryStorage()
    
    private init() {
    }
    
    static func idForName(_ name: String) -> Int {
        var id = 0
        for item in shared.categories {
            if item.name == name {
                id = item.id
            }
        }
        
        return id
    }
    
    static func nameForId(_ iId: Int) -> String {
        var name = ""
        for item in shared.categories {
            if item.id == iId {
                name = item.name
            }
        }
        
        return name
    }
}
