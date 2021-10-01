//
//  UploadAvatarRequest.swift
//  BWM
//
//  Created by obozhdi on 05/06/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class UploadAvatarRequest {
  
  class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
}

struct ImageStructInfo {
  var fileName: String
  var type: String
  var data: Data
}

class UploadImage {
  
  private let boundary = "Boundary-\(NSUUID().uuidString)"
  private var request: URLRequest?
  
  init(url: String, parameter param : [String: AnyObject]) {
    
    guard let url = URL(string: url) else { return }
    request = URLRequest(url: url)
    request?.httpMethod = "POST"
    request?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request?.httpBody = createBody(with: param, boundary: boundary)
  }
  
  func responseJSON(completionHandler: @escaping ([String: Any]?, Error?) -> Void) {
    guard let request = request else { return }
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      
      guard let data = data, error == nil else {
        completionHandler(nil, error)
        return
      }
      
      DispatchQueue.main.async {
        do {
          let dicResponse = try JSONSerialization.jsonObject(with: data, options: []) as?  [String: Any]
          completionHandler(dicResponse, nil)
        } catch {
          completionHandler(nil, error)
        }
      }
    }
    
    task.resume()
  }
  
  internal func createBody(with parameters: [String: Any], boundary: String) -> Data {
    var body = Data()
    
    for (key, value) in parameters {
      if let imageInfo = value as? ImageStructInfo {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(imageInfo.fileName)\"\r\n")
        body.append("Content-Type: \(imageInfo.type)\r\n\r\n")
        body.append(imageInfo.data)
        body.append("\r\n")
      } else {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.append("\(value)\r\n")
      }
    }
    
    body.append("--\(boundary)--\r\n")
    return body
  }
}

extension UIImage {
  func toData() -> Data {
    return UIImageJPEGRepresentation(self, 0.7)! as Data
  }
}

extension Data {
  
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}
