//
//  StartVideoController.swift
//  BWM
//
//  Created by obozhdi on 19/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit

class BWMFlatButton: UIButton {
  
  var isFilled: Bool = false
  
  private var separatorView = UIView()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    customize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    customize()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  fileprivate func customize() {
    separatorView.backgroundColor = UIColor.gray
    
    addSubviews()
  }
  
  fileprivate struct Padding {
    static let side   = CGFloat(12)
    static let top    = CGFloat(20)
    static let bottom = CGFloat(20)
    static let inter  = CGFloat(10)
    
    struct Image {
      static let side = CGFloat(12)
      static let top  = CGFloat(12)
    }
    
    struct Button {
      static let height = CGFloat(50)
      static let width  = CGFloat(296)
    }
  }
  
  func addSubviews() {
    self.addSubview(separatorView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let screenHeight = self.bounds.size.height
    let screenWidth  = self.bounds.size.width
    
    separatorView.frame = CGRect(x: 0, y: screenHeight - 0.5, width: screenWidth, height: 0.5)
  }
  
  func setGreyColor() {
    UIView.animate(withDuration: 1.0) {
      self.separatorView.backgroundColor = UIColor.gray
      self.separatorView.setNeedsDisplay()
    }
  }
  
  func setRedColor() {
    UIView.animate(withDuration: 1.0) {
      self.separatorView.backgroundColor = UIColor.red
      self.separatorView.setNeedsDisplay()
    }
  }
  
  func setGreenColor() {
    UIView.animate(withDuration: 1.0) {
      self.separatorView.backgroundColor = UIColor.green
      self.separatorView.setNeedsDisplay()
    }
  }
  
}
