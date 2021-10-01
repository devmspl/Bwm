//
//  Int.swift
//  BWM
//
//  Created by obozhdi on 16/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation

extension Int {
  
  var roundedString: String {
    let number = Double(self)
    let thousand = number / 1000
    let million = number / 1000000
    if million >= 1.0 {
      return "\(round(million*10)/10)M"
    } else if thousand >= 1.0 {
      return "\(round(thousand*10)/10)K"
    } else {
      return "\(Int(number))"
    }
  }
  
}
