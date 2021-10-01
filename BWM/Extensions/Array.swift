//
//  Array.swift
//  BWM
//
//  Created by Serhii on 8/28/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation

extension Array where Iterator.Element == Ethnicity {
    
    var values: [String] {
        return self.compactMap({ (obj) -> String? in
            return obj.name
        })
    }
}

extension Array where Iterator.Element == Category {
    
    var values: [String] {
        return self.compactMap({ (obj) -> String? in
            return obj.name
        })
    }
}
