//
//  String.swift
//  BWM
//
//  Created by obozhdi on 21/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import UIKit

extension String {
  func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
  //: ### Base64 encoding a string
  func base64Encoded() -> String? {
    if let data = self.data(using: .utf8) {
      return data.base64EncodedString()
    }
    return nil
  }
  //: ### Base64 decoding a string
  func base64Decoded() -> String? {
    if let data = Data(base64Encoded: self) {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }
}
