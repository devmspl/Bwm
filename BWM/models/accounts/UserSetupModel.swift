//
//  UserSetupModel.swift
//  BWM
//
//  Created by Serhii on 10/17/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import UIKit

class UserSetupModel {
    
    var isFBSignUp: Bool = false
    var userData: [String: Any] = [:]
    var image: UIImage?
    var isCustomer: Bool = false
    var isEditing: Bool = false
    var verificationCode: String = ""
}
